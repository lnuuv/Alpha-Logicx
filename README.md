
## النشر على Vercel

المشروع يضمّ إعداد `vercel.json` لتضمين ملفات الواجهة التي يحتاجها خادم Node. اربط مستودع GitHub بالمشروع، ثم أضف `SUPABASE_URL` و`SUPABASE_PUBLISHABLE_KEY` و`GEMINI_API_KEY` في إعدادات Environment Variables على Vercel، واختر بيئة Production على الأقل. لا تحفظ المفاتيح في ملفات المستودع. إصدار Node محدد في `package.json` ويتطلب 22 أو أحدث. بعد تغيير متغيرات البيئة، أعد النشر لتصبح فعّالة.
