# مسرد المصطلحات الموحّد — Alpha LogicX

هذا الملف نسخة مقروءة من `window.ALX_GLOSSARY` داخل `index.html` (الكتلة `<script id="alx-glossary">`).
الكتلة هي المصدر الوحيد: لكل مصطلح أساسي اسم عربي واحد واسم إنجليزي واحد، ولها الأولوية على أي ترجمة أخرى في القاموس،
فيظهر المصطلح بالترجمة نفسها في كل الصفحات.

## كيف يعمل نظام اللغتين

- العربية هي لغة المصدر. عند اختيار English يترجم المحرّك (`<script>` الذي يبدأ بـ `i18n: تبديل اللغة`) نصوص الصفحة
  من القاموس `DICT` + `ALX_GLOSSARY` + `ALX_I18N_EXTRA`، ويقلب `html[dir]` إلى `ltr`.
- **لا خلط بين اللغتين:** تُترجم الجملة كاملة (مطابقة تامة، أو بعد نزع الرموز من الطرفين، أو مقطعاً مقطعاً بين علامات الترقيم).
  إن لم تكتمل ترجمتها تبقى عربية سليمة ويُعطى عنصرها `dir="rtl" lang="ar"` كي لا تنقلب الأقواس وعلامات الترقيم،
  ولا تظهر جمل نصفها عربي ونصفها إنجليزي.
- النصوص التي لم تُترجم تُجمع أثناء التشغيل في `window.__trMissing` (افتح الكونسول في الوضع الإنجليزي لمعرفتها وإضافتها).
- لإضافة ترجمة جملة: أضفها في `ALX_I18N_EXTRA` بالنص العربي كما يظهر في الصفحة حرفياً.
- لإضافة مصطلح أساسي: أضف سطراً في `ALX_GLOSSARY` ثم حدّث هذا الملف.

## مصطلحات الواجهة

| العربية | English | اختصار |
|---|---|---|
| العرض التقديمي | Presentation | — |
| ورشة العمل | Workshop | — |
| ألعاب | Games | — |
| الألعاب | Games | — |
| الاتصالات | Communications | — |
| السحابة | Cloud | — |
| الحماية | Security | — |
| مقارنات | Comparisons | — |
| المقارنات | Comparisons | — |
| الاختصارات | Acronyms | — |
| قاموس الاختصارات | Acronyms glossary | — |
| ملخص الكتاب | Book summary | — |
| اختبار المراجعة | Review quiz | — |
| المنصة | Platform | — |
| المزيد | More | — |
| مختبر الشبكات | Network Lab | — |
| استوديو الواجب | Homework Studio | — |
| مساعد AI | AI assistant | — |
| الشرح | Explanation | — |
| شرح | Explanation | — |
| شرح موسّع | Detailed explanation | — |
| ملء الشاشة | Full screen | — |
| بحث | Search | — |
| الكل | All | — |
| التالي | Next | — |
| السابق | Previous | — |
| إغلاق | Close | — |
| رجوع | Back | — |
| حفظ | Save | — |
| إلغاء | Cancel | — |
| حذف | Delete | — |
| تعديل | Edit | — |
| إرسال | Send | — |
| الإعدادات | Settings | — |
| لوحة التحكم | Dashboard | — |
| الملف الشخصي | Profile | — |
| تسجيل الدخول | Sign in | — |
| تسجيل الخروج | Sign out | — |
| إنشاء حساب | Create account | — |
| اسم المستخدم | Username | — |
| كلمة المرور | Password | — |
| كلمة السر | Password | — |
| المحادثات | Chats | — |
| القنوات | Channels | — |
| الاجتماعات | Meetings | — |
| المهام | Tasks | — |
| لوحة الصدارة | Leaderboard | — |
| الواجب | Assignment | — |
| الواجبات | Assignments | — |
| الأستاذ | Teacher | — |
| المعلم | Teacher | — |
| الطالب | Student | — |
| الطلاب | Students | — |
| الكاردات | Cards | — |
| كارد | Card | — |
| كارد جديد | New card | — |
| الإجابة | Answer | — |
| سؤال | Question | — |
| نقطة | point | — |
| المحاكاة | Simulation | — |
| محاكاة | Simulation | — |
| المجسمات | Models | — |
| مجسم | Model | — |
| المصادر | Sources | — |

## المصطلحات التقنية

| العربية | English | اختصار |
|---|---|---|
| البنية التحتية | Infrastructure | — |
| البنية التحتية لتكنولوجيا المعلومات | IT infrastructure | — |
| تكنولوجيا المعلومات | Information technology | IT |
| الحوسبة السحابية | Cloud computing | — |
| الأمن السيبراني | Cybersecurity | — |
| أمن المعلومات | Information security | — |
| الجدار الناري | Firewall | — |
| جدار الحماية | Firewall | — |
| مضاد الفيروسات | Antivirus | — |
| البرمجيات الخبيثة | Malware | — |
| التشفير | Encryption | — |
| فك التشفير | Decryption | — |
| المصادقة الثنائية | Two-factor authentication | 2FA |
| النسخ الاحتياطي | Backup | — |
| الراوتر | Router | — |
| الموجه | Router | — |
| الموجّه | Router | — |
| السويتش | Switch | — |
| المبدل | Switch | — |
| المبدّل | Switch | — |
| الخادم | Server | — |
| السيرفر | Server | — |
| الخوادم | Servers | — |
| نظام التشغيل | Operating system | — |
| أنظمة التشغيل | Operating systems | — |
| العتاد | Hardware | — |
| البرمجيات | Software | — |
| الأجهزة | Devices | — |
| الجهاز | Device | — |
| الأجهزة الرقمية | Digital devices | — |
| الطرفيات | Peripherals | — |
| أجهزة الإدخال | Input devices | — |
| أجهزة الإخراج | Output devices | — |
| اللوحة الأم | Motherboard | — |
| المعالج | Processor | CPU |
| الذاكرة | Memory | — |
| التخزين | Storage | — |
| قاعدة البيانات | Database | — |
| قواعد البيانات | Databases | — |
| الشبكة | Network | — |
| الشبكات | Networks | — |
| الشبكة المحلية | Local area network | LAN |
| الشبكة الواسعة | Wide area network | WAN |
| البروتوكول | Protocol | — |
| البروتوكولات | Protocols | — |
| الوسائط | Media | — |
| الحزمة | Packet | — |
| الحزم | Packets | — |
| عنوان IP | IP address | — |
| قناع الشبكة | Subnet mask | — |
| البوابة الافتراضية | Default gateway | — |
| سعة النطاق | Bandwidth | — |
| النطاق الترددي | Bandwidth | — |
| زمن الاستجابة | Latency | — |
| مركز البيانات | Data centre | — |
| مراكز البيانات | Data centres | — |
| الذكاء الاصطناعي | Artificial intelligence | AI |
| نظام إدارة المحتوى | Content management system | CMS |
| إنترنت الأشياء | Internet of Things | IoT |
| الاستضافة السحابية | Cloud hosting | — |
| الاستضافة المحلية | On-premises hosting | — |
| البيانات | Data | — |
| المعلومات | Information | — |
| المؤسسة | Organisation | — |
| المؤسسات | Organisations | — |
| أصحاب المصلحة | Stakeholders | — |
| اتفاقية مستوى الخدمة | Service level agreement | SLA |
| معايير التقييم | Assessment criteria | — |
