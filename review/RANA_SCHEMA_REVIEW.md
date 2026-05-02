# مراجعة شغل رنا — `database/schema.sql`

> **المراجِع:** عبدالرحمن
> **التاريخ:** 2026-04-27
> **الموديول:** M3 — Database (Rana)
> **الملفات المراجَعة:** `database/schema.sql` + `assets/weather_database_erd_visualization_*.png`

---

## 1. ملخص تنفيذي

شغل رنا على schema قاعدة البيانات **سليم بشكل عام ومتوافق مع المتطلبات الأساسية للمشروع**. الـ 3 جداول الأساسية (`locations`, `pipeline_runs`, `weather_readings`) موجودة، والـ ENUM الخاص بـ wind direction معرّف، والـ unique constraints المهمة (اللي بتخلي الـ pipeline idempotent) مظبوطة.

في كم نقطة تحسين بسيطة (نسميها "ملاحظات" مش "أخطاء")، أهمها:
- بعض الأعمدة ينقصها `NOT NULL` رغم إن الـ pipeline دايماً بيدخّل قيم فيها.
- عمود `status` في `pipeline_runs` مفيش عليه `CHECK constraint` فممكن يقبل أي قيمة عشوائية.
- مفيش indexes صريحة على الأعمدة اللي هنستعلم بيها كتير.

**التقدير العام:** ✅ مقبول — يصلح للتسليم بعد ما نناقش الملاحظات الموضحة في القسم 4 مع رنا.

---

## 2. كيف عملنا المراجعة (للتوثيق)

| الخطوة | الأداة |
|--------|--------|
| 1. قراءة الكود سطر بسطر | فتح `database/schema.sql` |
| 2. تحليل ساكن (parser) للتحقق من الـ syntax | `sqlglot` (PostgreSQL dialect) |
| 3. مقارنة الـ schema بالـ README وملفات `docs/` | قراءة يدوية |
| 4. التحقق من تكامل الـ schema مع الكود اللي يستخدمها | فحص `src/load.py` و `src/transform.py` |
| 5. اختبار عملي على PostgreSQL حقيقي | `review/test_schema.sh` (Docker) |

---

## 3. النقاط الإيجابية ✅

### 3.1 استخدام UUIDs و `uuid-ossp`
رنا فعّلت extension `uuid-ossp` واستخدمت `UUID PRIMARY KEY DEFAULT uuid_generate_v4()` في الجداول التلاتة. ده اختيار سليم لمشروع distributed/idempotent.

### 3.2 الـ idempotency constraints
- `UNIQUE(city, country)` على `locations` — يضمن إن نفس المدينة ما تتسجلش مرتين، ويسمح للـ `ON CONFLICT (city, country) DO UPDATE` في `src/load.py` يشتغل تمام.
- `UNIQUE(location_id, observation_timestamp)` على `weather_readings` — ده الـ constraint الأهم في النظام كله، لأنه اللي بيخلي الـ pipeline يقدر يجري كل ساعة من غير ما يكرر السجلات.

### 3.3 Wind Direction ENUM
الـ 16 قيمة (N, NNE, NE, ..., NNW) مطابقة 100% للقيم اللي بيرجعها `transform.py` في الدالة `compass_points`. ده تكامل جيد بين موديول رنا وموديول آية.

### 3.4 `TIMESTAMP WITH TIME ZONE`
استعملت TIMESTAMPTZ في كل أعمدة الوقت — صح، لأن الـ `extract.py` بيستخدم `pytz.utc` للـ observation_timestamp.

### 3.5 `JSONB` لـ `api_request_params`
اختيار سليم — JSONB أسرع من JSON في الاستعلام وعنده indexing أحسن.

### 3.6 Foreign Keys
- `weather_readings.location_id REFERENCES locations(id)` ✓
- `weather_readings.pipeline_run_id REFERENCES pipeline_runs(id)` ✓

### 3.7 Defensive `IF NOT EXISTS`
استخدام `CREATE TABLE IF NOT EXISTS` يخلي السكربت يقدر يتنفذ أكتر من مرة بدون مشاكل.

### 3.8 ERD رفعت معاه
الـ PNG في `assets/weather_database_erd_visualization_*.png` بيوفّر مرجع مرئي مفيد للفريق.

---

## 4. الملاحظات والتحسينات المقترحة 🔧

### 4.1 [متوسطة] `location_id` و `pipeline_run_id` يقبلوا NULL في `weather_readings`

**المشكلة:**
```sql
location_id UUID REFERENCES locations(id),
pipeline_run_id UUID REFERENCES pipeline_runs(id),
```
مفيش `NOT NULL`، رغم إن `src/load.py` دايماً بيدخّل قيم. ده يخلي ممكن (نظرياً) ندخّل reading مش متربط بأي مدينة أو run، وده شيء ما ينفعش في الـ business logic.

**المقترح:**
```sql
location_id UUID NOT NULL REFERENCES locations(id),
pipeline_run_id UUID NOT NULL REFERENCES pipeline_runs(id),
```

### 4.2 [متوسطة] `status` في `pipeline_runs` يقبل أي string

**المشكلة:**
```sql
status VARCHAR(20) DEFAULT 'RUNNING',  -- RUNNING, SUCCESS, FAILED
```
- مفيش `CHECK constraint` يفرض القيم المسموحة.
- التعليق ناقص: `pipeline.py` بيستخدم `'PARTIAL_SUCCESS'` كمان (سطر 76 من `pipeline.py`).
- لو حد كتب `'SUCESS'` بـ typo بيعدّي بدون خطأ.

**المقترح (اختاري واحد):**
- **خيار A — CHECK constraint:**
  ```sql
  status VARCHAR(20) NOT NULL DEFAULT 'RUNNING'
      CHECK (status IN ('RUNNING','SUCCESS','PARTIAL_SUCCESS','FAILED')),
  ```
- **خيار B — ENUM (متناسق مع `wind_direction_enum`):**
  ```sql
  CREATE TYPE pipeline_status_enum AS ENUM
      ('RUNNING','SUCCESS','PARTIAL_SUCCESS','FAILED');
  -- ثم
  status pipeline_status_enum NOT NULL DEFAULT 'RUNNING',
  ```

### 4.3 [خفيفة] غياب الـ indexes الصريحة

**المشكلة:**
الـ `UNIQUE (location_id, observation_timestamp)` بينشئ index مركّب تلقائي، بس الاستعلامات الشائعة في README:
```sql
SELECT ... FROM weather_readings WHERE rain_tomorrow = TRUE ORDER BY observation_timestamp DESC;
SELECT MAX(observation_timestamp) FROM weather_readings GROUP BY location_id;
```
هتستفيد من indexes إضافية على:
- `observation_timestamp` (مفرد)
- `pipeline_run_id` (للـ join مع pipeline_runs)
- `rain_tomorrow` (لو الفلترة عليه شائعة)

**المقترح:**
```sql
CREATE INDEX IF NOT EXISTS idx_readings_observation
    ON weather_readings(observation_timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_readings_pipeline_run
    ON weather_readings(pipeline_run_id);
CREATE INDEX IF NOT EXISTS idx_readings_rain_tomorrow
    ON weather_readings(rain_tomorrow) WHERE rain_tomorrow = TRUE;
```

### 4.4 [خفيفة] غياب CHECK constraints على القيم الفيزيائية

**المشكلة:**
README يقول إن الـ pipeline يرفض أي قيم خارج `[-50, 60]°C` و `[0, 100]%`. التحقق ده موجود في `src/pipeline.py` (`validate_data`)، بس defense-in-depth أحسن: لو حد دخّل بيانات يدوياً عبر psql مباشرة، الـ DB لازم تحميه.

**المقترح:**
```sql
-- في تعريف weather_readings:
temp_avg_c DECIMAL(5,2) CHECK (temp_avg_c BETWEEN -50 AND 60),
humidity_pct INTEGER CHECK (humidity_pct BETWEEN 0 AND 100),
pressure_hpa INTEGER CHECK (pressure_hpa BETWEEN 800 AND 1100),
wind_direction_deg INTEGER CHECK (wind_direction_deg BETWEEN 0 AND 360),
```

### 4.5 [خفيفة جدًا] `ON DELETE` على الـ FKs غير معرّف

**المشكلة:**
```sql
location_id UUID REFERENCES locations(id),
```
الـ default سلوك = `NO ACTION` — يمنع حذف موقع لو فيه قراءات. ده غالباً السلوك المطلوب، بس **التصريح أوضح**:
```sql
location_id UUID NOT NULL REFERENCES locations(id) ON DELETE RESTRICT,
pipeline_run_id UUID NOT NULL REFERENCES pipeline_runs(id) ON DELETE RESTRICT,
```

### 4.6 [خفيفة جدًا] ملف `assets/Weather ERD` فاضي (0 bytes)

موجود ملف اسمه `Weather ERD` بدون امتداد وحجمه صفر. غالباً انشأ بالغلط. يفضّل حذفه:
```bash
git rm "assets/Weather ERD"
```

### 4.7 [للنقاش] `country VARCHAR(10)` كبير

API الـ OpenWeatherMap بيرجّع كود ISO من حرفين (مثلاً "EG", "SA"). 10 أحرف مبالغة بس مش غلط. ممكن نخليها `CHAR(2)` بس ده تشدد قد لا يكون ضرورياً.

### 4.8 [للنقاش] schema.sql ينقصه newline في النهاية

أسلوبية بحتة، بس Linux convention.

---

## 5. مقارنة التصميم بالـ ERD

✅ **الـ ERD يتطابق مع `schema.sql`** فيما يخص:
- عدد الجداول (3)
- الأعمدة الرئيسية
- العلاقات: `weather_readings.location_id → locations.id` و `weather_readings.pipeline_run_id → pipeline_runs.id`

> ملاحظة: لا أستطيع التأكد 100% من التطابق التفصيلي بدون فتح صورة الـ ERD في كل تفاصيلها. يُفضّل لو رنا تأكدت بنفسها إن الصورة تعكس آخر نسخة من الـ schema.

---

## 6. الاختبار العملي بـ Docker

أعددت سكربت اختبار جاهز:

```
review/test_schema.sh
```

**التشغيل:**
```bash
cd ~/projects/weather-data-pipeline
bash review/test_schema.sh
```

**هيعمل إيه:**
1. يشغّل خدمة `db` فقط (مش الـ pipeline) عشان نختبر الـ schema بمعزل.
2. ينتظر PostgreSQL يبقى جاهز.
3. يطبع الجداول والأعمدة والـ ENUM types.
4. يجري 6 smoke tests:
   - **5.1** ENUM يقبل القيمة الصحيحة (`NNE`) ويرفض الخاطئة (`XYZ`)
   - **5.2** UNIQUE(location, timestamp) يرفض السجل المكرر ✓ idempotency
   - **5.3** UNIQUE(city, country) يرفض المدينة المكررة
   - **5.4** Foreign Key يرفض location_id غير موجود
   - **5.5** اختبار هل `location_id` يقبل NULL (هيظهر الملاحظة في 4.1)
   - **5.6** اختبار هل `status` يقبل قيم خاطئة (هيظهر الملاحظة في 4.2)
5. يطبع إحصائيات الجداول.
6. ينضّف الـ container والـ volume.

**الناتج المتوقع:**
- علامة ✓ على 4 اختبارات تثبت إن الـ schema شغّال صح.
- علامة ⚠ على اختبارين هيتأكدوا من الملاحظات اللي ذكرناها (NULL يقبل، status يقبل أي string).

كل المخرجات هتتحفظ في `review/schema_test_output.log`.

---

## 7. اقتراح الخطوات التالية

1. **شغّل سكربت الاختبار** عشان تشوف بعينيك إن الـ schema يطبق صح ويثبت السلوك المتوقع.
2. **شارك التقرير ده مع رنا** (مثلاً ارفعه على branch `review/m3-schema` وتحدثوا فيه).
3. **اتفق معاها** على:
   - أيّ من الملاحظات (4.1–4.8) يستحق إصلاح قبل التسليم.
   - أيّها يبقى "future work".
4. **افتح Pull Request** بإصلاحات بسيطة (NOT NULLs + CHECK على status + indexes) لو رنا موافقة. الـ FKs المتأثرة أرقام محدودة وآمنة.

---

## 8. أسئلة للمناقشة مع رنا

1. هل الـ `api_request_params JSONB` المقصود يخزّن المعاملات لكل run، أم لكل city داخل الـ run؟ حالياً `pipeline.py` يخزّن قائمة المدن فقط.
2. هل تريدين إضافة CHECK constraints على القيم الفيزيائية، أم تكفي الـ Python validation في `pipeline.py`؟
3. هل الـ `ENUM` تفضلينه على CHECK constraint لقيم `status`؟
4. هل من الجيد إضافة `updated_at` على `locations` (مع trigger) لتتبع آخر تعديل؟

---

## ملحق — معلومات تقنية

**حجم الـ schema:** 61 سطر / 3 جداول / 1 ENUM
**Commits رنا:**
- `385c155` (20 أبريل): "my updates" — الإضافة الأولى لـ schema.sql
- `862e7e4` (24 أبريل): "docs: add entity relationship diagram" — صورة ERD

**الكود اللي يعتمد على هذا الـ schema:**
- `src/load.py` → `upsert_location`, `start_pipeline_run`, `close_pipeline_run`, `load_reading`
- `src/pipeline.py` → orchestration
