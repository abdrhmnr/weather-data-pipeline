# Setup Guide - Weather Data Pipeline

دليل تشغيل المشروع من الصفر. اتبع الخطوات بالترتيب.

---

## المتطلبات الأساسية (Prerequisites)

قبل ما تبدأ، تأكد إن عندك البرامج دي مثبتة:

| البرنامج                    | الإصدار | للتحميل                                                      |
| --------------------------- | ------- | ------------------------------------------------------------ |
| **Docker Desktop**          | 20.10+  | [docker.com](https://www.docker.com/products/docker-desktop) |
| **Git**                     | 2.30+   | [git-scm.com](https://git-scm.com/)                          |
| **حساب OpenWeatherMap API** | مجاني   | [openweathermap.org/api](https://openweathermap.org/api)     |

### تأكد من التثبيت:

```bash
docker --version          # المفروض يطلع: Docker version 20.x.x
docker-compose --version  # المفروض يطلع: Docker Compose version 2.x.x
git --version             # المفروض يطلع: git version 2.x.x
```

---

## الخطوة 1: الحصول على API Key

1. اعمل حساب مجاني على [OpenWeatherMap](https://openweathermap.org/api)
2. روح صفحة [API Keys](https://home.openweathermap.org/api_keys)
3. انسخ الـ API key بتاعك (هيبقى شكله كده: `a1b2c3d4e5f6...`)

> **ملاحظة:** الـ API key الجديد بياخد لحد ساعتين عشان يشتغل.

---

## الخطوة 2: استنسخ المشروع (Clone)

```bash
git clone <repository-url>
cd weather-data-pipeline
```

---

## ⚙️ الخطوة 3: إعداد ملف البيئة (`.env`)

### أ) انسخ الملف النموذجي:

```bash
cp .env.example .env
```

### ب) افتح `.env` وعدّل القيم:

```bash
# على Mac/Linux
nano .env

# أو افتحه في VS Code
code .env
```

### ج) املأ القيم دي:

```env
# Weather API
WEATHER_API_KEY=ضع_الـ_API_KEY_هنا

# Database
DB_NAME=weather_db
DB_USER=postgres
DB_PASSWORD=postgres_password
DB_HOST=db
DB_PORT=5432
```

> **مهم:** ملف `.env` مش هيتم رفعه على Git (موجود في `.gitignore`) عشان حماية المعلومات الحساسة.

---

## 🐳 الخطوة 4: تشغيل المشروع بـ Docker

### أ) شغّل Docker Desktop على جهازك

تأكد إن أيقونة Docker شغالة في الـ menu bar.

### ب) ابني وشغّل الحاويات:

```bash
docker-compose up -d --build
```

ده هيعمل:

- يبني صورة Docker للمشروع
- يشغّل قاعدة بيانات PostgreSQL
- يشغّل الـ Pipeline اللي بيجمع البيانات

> ⏱️ أول مرة هتاخد 3-5 دقايق (تحميل الـ images).

### ج) تأكد إن كل حاجة شغالة:

```bash
docker-compose ps
```

**النتيجة المتوقعة:**

```
NAME                               STATUS
weather-data-pipeline-db-1         Up
weather-data-pipeline-pipeline-1   Up
```

---

## 🔍 الخطوة 5: التحقق من الداتا

### أ) شوف الـ logs (عشان تتأكد إن الـ pipeline اشتغل):

```bash
docker-compose logs pipeline --tail=20
```

**المفروض تشوف:**

```
Pipeline finished. Status: SUCCESS. Loaded: 10, Rejected: 0
```

### ب) ادخل على قاعدة البيانات:

```bash
docker-compose exec db psql -U postgres -d weather_db
```

### ج) نفّذ الاستعلامات دي للتحقق:

```sql
-- 1. كم قراءة موجودة؟
SELECT COUNT(*) FROM weather_readings;

-- 2. شوف المدن
SELECT city, country FROM locations ORDER BY city;

-- 3. شوف عينة من القراءات
SELECT
    l.city,
    w.temp_avg_c AS "Temp (°C)",
    w.humidity_pct AS "Humidity (%)",
    w.wind_direction AS "Wind",
    w.rain_tomorrow AS "Rain Tomorrow?"
FROM weather_readings w
JOIN locations l ON w.location_id = l.id
ORDER BY l.city;

-- 4. شوف حالة الـ pipeline
SELECT status, records_extracted, records_loaded, records_rejected
FROM pipeline_runs
ORDER BY started_at DESC
LIMIT 5;
```

### د) للخروج من psql:

```sql
\q
```

---

## الـ Pipeline Schedule

الـ pipeline بيشتغل **أوتوماتيكياً كل ساعة** في الدقيقة `:00`.

- 17:00 → يجمع 10 قراءات
- 18:00 → يجمع 10 قراءات
- 19:00 → يجمع 10 قراءات
- ... وهكذا

---

## 🛠️ أوامر مفيدة

### إيقاف المشروع:

```bash
docker-compose down
```

### إيقاف ومسح كل البيانات (Reset كامل):

```bash
docker-compose down -v
```

### إعادة تشغيل:

```bash
docker-compose up -d
```

### عرض الـ logs بشكل مستمر:

```bash
docker-compose logs -f pipeline
```

(اضغط `Ctrl+C` للخروج)

### عرض الـ logs بتاعت قاعدة البيانات:

```bash
docker-compose logs db --tail=30
```

### إعادة بناء بعد تعديل الكود:

```bash
docker-compose down
docker-compose up -d --build
```

---

## حل المشاكل الشائعة (Troubleshooting)

### المشكلة: `Cannot connect to Docker daemon`

**الحل:** افتح Docker Desktop واستنى لحد ما يشتغل.

---

### المشكلة: `Port 5432 is already in use`

**السبب:** فيه PostgreSQL تاني شغال على نفس الـ port.

**الحل:**

```bash
# أوقف أي PostgreSQL شغال على الجهاز
brew services stop postgresql   # على Mac
sudo systemctl stop postgresql  # على Linux

# أو غير الـ port في docker-compose.yml من 5432:5432 لـ 5433:5432
```

---

### المشكلة: الـ pipeline بيدي error `WEATHER_API_KEY not found`

**الحل:**

1. تأكد إن ملف `.env` موجود في جذر المشروع
2. تأكد إن `WEATHER_API_KEY` مكتوب صح وفيه قيمة
3. أعد تشغيل الـ containers:

```bash
docker-compose down
docker-compose up -d
```

---

### المشكلة: `relation "weather_readings" does not exist`

**السبب:** الـ schema ما اتحملش بشكل صحيح.

**الحل:** Reset كامل:

```bash
docker-compose down -v
docker-compose up -d --build
```

---

### المشكلة: `401 Unauthorized` من الـ API

**السبب:** الـ API key غلط أو لسه ما اشتغلش.

**الحل:**

- تأكد إن الـ key منسوخ صح في `.env`
- استنى لحد ساعتين بعد إنشاء الـ key (سياسة OpenWeatherMap)

---

## هيكل المشروع

```
weather-data-pipeline/
├── 📂 assets/              # بيانات تاريخية وERD
├── 📂 config/              # ملفات الإعدادات
├── 📂 database/            # SQL Schema
├── 📂 docs/                # توثيق المشروع
├── 📂 logs/                # ملفات السجلات
├── 📂 scheduler/           # Scheduler (كل ساعة)
├── 📂 src/                 # الكود الرئيسي
│   ├── extract.py          # سحب البيانات من API
│   ├── transform.py        # معالجة + ML
│   ├── load.py             # تخزين في PostgreSQL
│   └── pipeline.py         # ربط كل المراحل
├── 📂 tests/               # اختبارات الكود
├── 🐳 Dockerfile
├── 🐳 docker-compose.yml
├── 📄 .env.example         # نموذج للإعدادات
├── 📄 requirements.txt     # مكتبات Python
└── 📄 README.md
```

---

## تشغيل الاختبارات (Tests)

```bash
docker-compose exec pipeline python -m pytest tests/ -v
```

---

## المساعدة

لو واجهتك أي مشكلة:

1. شوف قسم [Troubleshooting](#-حل-المشاكل-الشائعة-troubleshooting) فوق
2. شوف الـ logs: `docker-compose logs pipeline`
3. تواصل مع فريق المشروع

---

## Checklist للتأكد إن كل حاجة تمام

- [ ] Docker Desktop شغال
- [ ] ملف `.env` موجود وفيه API key
- [ ] `docker-compose ps` بيوري الحاويتين شغالين
- [ ] `docker-compose logs pipeline` بيوري `Status: SUCCESS`
- [ ] `SELECT COUNT(*) FROM weather_readings` بيرجع رقم أكبر من 0

---

**مبروك! المشروع شغال عندك دلوقتي.**
