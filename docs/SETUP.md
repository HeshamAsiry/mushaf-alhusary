# إعداد Neon وCloudflare R2

## 1. Neon

المشروع الحالي:

`young-brook-54728721`

القيمة المطلوبة في:

`DATABASE_URL`

### مكان الحصول عليها

Neon Console -> المشروع -> **Connect** -> PostgreSQL connection string.

ضع قيمة الاتصال كاملة في `.env.local`.

مثال شكلي فقط:

`DATABASE_URL="postgresql://USER:PASSWORD@HOST/DATABASE?sslmode=require"`

لا تستخدم المثال نفسه؛ استخدم القيمة التي يعطيها Neon.

---

## 2. Cloudflare R2

### R2_ACCOUNT_ID

Cloudflare Dashboard -> R2 -> Overview -> **Account ID**.

ضعه في:

`R2_ACCOUNT_ID`

### R2_ACCESS_KEY_ID

Cloudflare Dashboard -> R2 -> Manage R2 API Tokens -> الـAPI Token الذي أنشأته.

انسخ **Access Key ID** إلى:

`R2_ACCESS_KEY_ID`

### R2_SECRET_ACCESS_KEY

في نفس API Token، انسخ **Secret Access Key** إلى:

`R2_SECRET_ACCESS_KEY`

> هذه قيمة سرية مثل كلمة المرور. لا تضعها في GitHub ولا ترسلها في المحادثة.

### R2_BUCKET_NAME

Cloudflare Dashboard -> R2 -> افتح الـBucket الذي أنشأته للمشروع.

انسخ **اسم الـBucket حرفيًا** إلى:

`R2_BUCKET_NAME`

---

## 3. المسارات داخل الـBucket

نستخدم:

`raw/`
المصدر الأصلي.

`processed/`
الناتج بعد القص والتجميع، قبل الاعتماد.

`public/`
الملفات النهائية التي تم اعتمادها للنشر.

لا نحتاج إلى إنشاء Buckets منفصلة لهذه المسارات.

---

## 4. Local vs Production

محليًا: استخدم `.env.local`.

عند نشر التطبيق: ضع نفس المتغيرات في إعدادات منصة التشغيل (مثل Railway) كـEnvironment Variables.

لا تضع القيم الحقيقية داخل ملفات TypeScript أو JSON أو README.

---

## 5. اختبار الربط

بعد إنشاء تطبيق Next.js سنضيف اختبارًا بسيطًا للتأكد من:

- اتصال Neon.
- الوصول إلى R2.
- معرفة اسم الـBucket.

الاختبار لن يطبع Secret Access Key في logs.
