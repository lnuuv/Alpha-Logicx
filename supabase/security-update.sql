-- =====================================================================
--  Alpha LogicX — تحديث الأمان
--  شغّله مرة واحدة في: Supabase → SQL Editor → New query → Run
--  (بعد ملفات SQL السابقة للمنصة). آمن للتشغيل أكثر من مرة ولا يحذف بياناتك.
--
--  ماذا يغيّر:
--   1) التسجيل يحتاج «كود دعوة» يضعه الأستاذ. بدون كود يكون التسجيل مغلقاً.
--   2) لا أحد يصبح أستاذاً تلقائياً عند التسجيل (حتى باسم yasser).
--   3) المكالمات الخاصة وقنوات الصوت: لا يدخلها إلا أصحابها.
--   4) صور البروفايل والبانر وأيقونات السيرفرات: من مخزن الموقع فقط.
--
--  بعد التشغيل: من المنصة → «الأعضاء والصلاحيات» → «كود الدعوة» ضع كوداً وأعطه لطلابك.
--  أو من هنا:  update public.app_settings set invite_code = 'اكتب-الكود' where id = 1;
-- =====================================================================

-- ---------- 1) كود الدعوة ----------
create table if not exists public.app_settings (
  id          smallint primary key default 1 check (id = 1),
  invite_code text not null default '' check (char_length(invite_code) <= 40),
  updated_at  timestamptz not null default now()
);
insert into public.app_settings (id) values (1) on conflict (id) do nothing;

alter table public.app_settings enable row level security;
revoke all on public.app_settings from anon, authenticated;
grant select, update (invite_code, updated_at) on public.app_settings to authenticated;

drop policy if exists "settings teacher read" on public.app_settings;
create policy "settings teacher read" on public.app_settings for select to authenticated using (public.is_teacher());
drop policy if exists "settings teacher update" on public.app_settings;
create policy "settings teacher update" on public.app_settings for update to authenticated
  using (public.is_teacher()) with check (public.is_teacher());

-- ---------- 2) إنشاء الحساب: كود الدعوة إلزامي، والجميع طلاب ----------
-- (لإنشاء حساب يدوياً من لوحة Supabase: ضع كوداً مؤقتاً ثم سجّل من الموقع نفسه)
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  u    text := lower(coalesce(nullif(new.raw_user_meta_data ->> 'username', ''), split_part(new.email, '@', 1)));
  code text;
begin
  select lower(trim(invite_code)) into code from public.app_settings where id = 1;
  if coalesce(code, '') = '' or lower(trim(coalesce(new.raw_user_meta_data ->> 'invite', ''))) <> code then
    raise exception 'ALX_INVITE: كود الدعوة غير صحيح أو التسجيل مغلق';
  end if;
  insert into public.profiles (id, username, name, avatar, role)
  values (new.id, u,
          left(coalesce(nullif(trim(new.raw_user_meta_data ->> 'name'), ''), u), 40),
          left(coalesce(new.raw_user_meta_data ->> 'avatar', ''), 16),
          'student');
  return new;
end $$;

-- ---------- 3) القنوات المباشرة (المكالمات والاجتماعات وغرف الصوت) ----------
--  alx-lobby          : من المتصل الآن — لكل الحسابات الفعّالة
--  meet:<id> ctl:<id> : اجتماعات الصف — للجميع، وأوامر التحكم ctl للأستاذ فقط
--  inbox:<uid>        : رنين المكالمات — يقرؤه صاحبه فقط، ويرسل إليه أي حساب فعّال
--  call:<a>_<b>_<x>   : المكالمة الخاصة — للطرفين a و b فقط
--  vc:<قناة> vcw:<قناة> : غرف الصوت في السيرفرات — لأعضاء السيرفر فقط
create or replace function public.alx_topic_ok(t text, writing boolean) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  me   text := auth.uid()::text;
  rest text;
  ok   boolean := false;
begin
  if me is null or t is null or not public.is_active() then return false; end if;
  if t = 'alx-lobby' or t like 'meet:%' then return true; end if;
  if t like 'ctl:%' then return (not writing) or public.is_teacher(); end if;
  if t like 'inbox:%' then return writing or t = 'inbox:' || me; end if;
  if t like 'call:%' then
    rest := substr(t, 6);
    return me = split_part(rest, '_', 1) or me = split_part(rest, '_', 2);
  end if;
  if t like 'vc:%' or t like 'vcw:%' then
    begin
      execute 'select exists (select 1 from public.channels c join public.server_members m on m.server_id = c.server_id
                              where c.id = public.try_uuid($1) and m.uid = auth.uid())'
        into ok using split_part(t, ':', 2);
    exception when others then ok := false;
    end;
    return coalesce(ok, false);
  end if;
  return false;
end $$;
grant execute on function public.alx_topic_ok(text, boolean) to authenticated;

drop policy if exists "alx realtime read" on realtime.messages;
create policy "alx realtime read" on realtime.messages for select to authenticated
  using (public.alx_topic_ok(realtime.topic(), false));
drop policy if exists "alx realtime write" on realtime.messages;
create policy "alx realtime write" on realtime.messages for insert to authenticated
  with check (public.alx_topic_ok(realtime.topic(), true));

-- ---------- 4) روابط الصور: من مخزن الموقع فقط (لا روابط خارجية تكشف عناوين IP للزوار) ----------
do $$
begin
  alter table public.profiles drop constraint if exists alx_avatar_own;
  alter table public.profiles add constraint alx_avatar_own check
    (avatar_url = '' or avatar_url ~ '^https://[a-z0-9-]+\.supabase\.co/storage/v1/object/public/alx-media/') not valid;
  alter table public.profiles drop constraint if exists alx_banner_own;
  alter table public.profiles add constraint alx_banner_own check
    (banner_url = '' or banner_url ~ '^https://[a-z0-9-]+\.supabase\.co/storage/v1/object/public/alx-media/') not valid;
exception when undefined_column or undefined_table then null;
end $$;
do $$
begin
  alter table public.servers drop constraint if exists alx_icon_own;
  alter table public.servers add constraint alx_icon_own check
    (icon_url = '' or icon_url ~ '^https://[a-z0-9-]+\.supabase\.co/storage/v1/object/public/alx-media/') not valid;
exception when undefined_column or undefined_table then null;
end $$;

-- =====================================================================
--  إعدادات من لوحة Supabase (مرة واحدة):
--   • Authentication → Sign In / Providers → Email: «Minimum password length» = 12
--     (الموقع يضيف 4 رموز ثابتة قبل كلمة المرور، فـ 12 هنا = 8 أحرف يكتبها المستخدم)
--   • Realtime → Settings: أوقف «Allow public access» حتى تعمل القنوات الخاصة فقط
--  أوامر مفيدة:
--   جعل حساب أستاذاً:  update public.profiles set role = 'teacher' where username = 'اسم_المستخدم';
-- =====================================================================
