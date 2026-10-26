# تشغيل Alpha LogicX على Render

انسخ الملفات الأربعة index.html وrender-client.js وserver.mjs وpackage.json إلى جذر المشروع، واستبدل index.html القديم. احتفظ بباقي ملفات مشروعك.

في Render اختر New > Web Service واربط مستودع GitHub والفرع main. إذا الخدمة الحالية Static Site، أنشئ Web Service جديدًا؛ لا تحذف القديمة قبل تجربة الجديدة.

- Language: Node
- Build Command: npm install
- Start Command: npm start

من Environment أضف:

| Name | Value |
|---|---|
| SUPABASE_URL | رابط مشروعك الذي شغّلت فيه SQL |
| SUPABASE_PUBLISHABLE_KEY | المفتاح العام لنفس المشروع |
| GEMINI_API_KEY | مفتاح Google AI Studio الخاص بك |

احفظ وانشر الخدمة. لا تضع مفتاح Gemini في GitHub أو داخل HTML. رابط Supabase ومفتاحه العام يصلان للمتصفح حسب طبيعة Supabase؛ مفتاح Gemini يبقى على السيرفر.

بعد النشر، سجّل الدخول بحساب المنصة قبل استخدام AI. السيرفر يتحقق من جلسة Supabase وأن الحساب فعال. حد الطلبات 30 طلبًا بالدقيقة لكل مستخدم، في ذاكرة كل نسخة سيرفر. إعدادات Supabase على Render لها الأولوية على إعدادات المتصفح السابقة.

الشكل والمحتوى محفوظان؛ تم تغيير مسار الاتصال وإخفاء خانة إدخال مفتاح AI. استخدام الموقع كملف HTML محلي وحده لن يشغّل اتصالات السيرفر. للتشغيل المحلي اضبط نفس متغيرات البيئة ثم npm start.

التجربة الفعلية مع Gemini تحتاج مفتاحك وبيئة Render؛ لم يتم التحقق من جودة النماذج الموجودة سابقًا بالموقع أو تغييرها.
