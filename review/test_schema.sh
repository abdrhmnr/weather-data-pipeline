#!/usr/bin/env bash
# ============================================================================
# test_schema.sh
# ============================================================================
# سكريبت اختبار schema.sql الخاصة برنا.
#
# يقوم بـ:
#   1. تشغيل خدمة db فقط (بدون pipeline) باستخدام docker-compose
#   2. الانتظار لحد ما PostgreSQL جاهز
#   3. عرض الجداول والأنواع والـ constraints
#   4. تنفيذ smoke tests (إدخال بيانات + اختبار idempotency + اختبار ENUM + FK)
#   5. إيقاف الـ container ومسح الـ volume
#
# طريقة التشغيل:
#   cd ~/projects/weather-data-pipeline
#   bash review/test_schema.sh
#
# المخرج:
#   ينطبع على الشاشة + يحفظ نسخة كاملة في review/schema_test_output.log
# ============================================================================

set -e

# الانتقال لجذر المشروع لو السكريبت اتنفذ من مكان تاني
cd "$(dirname "$0")/.."

LOG="review/schema_test_output.log"
DB_SERVICE="db"
DB_USER="postgres"
DB_NAME="weather_db"

echo "=================================================" | tee "$LOG"
echo "  Weather Pipeline Schema Test (Rana's M3)" | tee -a "$LOG"
echo "  Date: $(date)" | tee -a "$LOG"
echo "=================================================" | tee -a "$LOG"

# ---------- 1. تنظيف أي تشغيل سابق ----------
echo -e "\n[STEP 1] تنظيف أي container أو volume سابق..." | tee -a "$LOG"
docker compose down -v 2>&1 | tee -a "$LOG" || true

# ---------- 2. تشغيل خدمة db فقط ----------
echo -e "\n[STEP 2] تشغيل خدمة PostgreSQL..." | tee -a "$LOG"
docker compose up -d "$DB_SERVICE" 2>&1 | tee -a "$LOG"

# ---------- 3. انتظار الجاهزية ----------
echo -e "\n[STEP 3] الانتظار لحد ما PostgreSQL جاهز..." | tee -a "$LOG"
for i in {1..30}; do
    if docker compose exec -T "$DB_SERVICE" pg_isready -U "$DB_USER" >/dev/null 2>&1; then
        echo "✓ PostgreSQL جاهز بعد $i ثانية" | tee -a "$LOG"
        break
    fi
    sleep 1
done

# انتظار إضافي لضمان تطبيق schema.sql من /docker-entrypoint-initdb.d/
sleep 3

# ---------- 4. التحقق من الجداول ----------
echo -e "\n[STEP 4] الجداول الموجودة:" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" -c "\dt" 2>&1 | tee -a "$LOG"

echo -e "\n[STEP 4.1] تفاصيل الأعمدة لكل جدول:" | tee -a "$LOG"
for tbl in locations pipeline_runs weather_readings; do
    echo -e "\n--- $tbl ---" | tee -a "$LOG"
    docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" -c "\d+ $tbl" 2>&1 | tee -a "$LOG"
done

echo -e "\n[STEP 4.2] الـ ENUM types:" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" -c "\dT+ wind_direction_enum" 2>&1 | tee -a "$LOG"

# ---------- 5. Smoke Tests ----------
echo -e "\n[STEP 5] Smoke Tests" | tee -a "$LOG"

# 5.1 ENUM يقبل القيم الصحيحة ويرفض الخاطئة
echo -e "\n[5.1] اختبار ENUM (wind_direction_enum)" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
-- يجب أن ينجح
INSERT INTO locations (city, country, latitude, longitude) VALUES ('TestCity', 'XX', 0, 0);
INSERT INTO pipeline_runs (status) VALUES ('SUCCESS') RETURNING id;

-- يجب أن ينجح: قيمة ENUM صحيحة
DO $$
DECLARE loc_id UUID; run_id UUID;
BEGIN
    SELECT id INTO loc_id FROM locations WHERE city='TestCity';
    SELECT id INTO run_id FROM pipeline_runs ORDER BY started_at DESC LIMIT 1;
    INSERT INTO weather_readings (location_id, pipeline_run_id, wind_direction, observation_timestamp)
        VALUES (loc_id, run_id, 'NNE', '2026-04-27 10:00:00+00');
    RAISE NOTICE '✓ wind_direction=NNE قُبلت بنجاح';
END $$;

-- يجب أن يفشل: قيمة ENUM خاطئة
DO $$
BEGIN
    INSERT INTO weather_readings (wind_direction, observation_timestamp)
        VALUES ('XYZ'::wind_direction_enum, '2026-04-27 11:00:00+00');
    RAISE NOTICE '✗ خطأ: قيمة wind_direction خاطئة قُبلت!';
EXCEPTION WHEN invalid_text_representation THEN
    RAISE NOTICE '✓ wind_direction=XYZ تم رفضها كما هو متوقع';
END $$;
SQL

# 5.2 UNIQUE constraint على (location_id, observation_timestamp)
echo -e "\n[5.2] اختبار idempotency: UNIQUE(location_id, observation_timestamp)" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
DO $$
DECLARE loc_id UUID; run_id UUID;
BEGIN
    SELECT id INTO loc_id FROM locations WHERE city='TestCity';
    SELECT id INTO run_id FROM pipeline_runs ORDER BY started_at DESC LIMIT 1;
    -- محاولة إدخال نفس (location, timestamp) مرة تانية
    INSERT INTO weather_readings (location_id, pipeline_run_id, wind_direction, observation_timestamp)
        VALUES (loc_id, run_id, 'N', '2026-04-27 10:00:00+00');
    RAISE NOTICE '✗ خطأ: السجل المكرر تم قبوله!';
EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE '✓ السجل المكرر تم رفضه (UNIQUE constraint شغّال)';
END $$;
SQL

# 5.3 UNIQUE constraint على (city, country) في locations
echo -e "\n[5.3] اختبار UNIQUE(city, country) في locations" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
DO $$
BEGIN
    INSERT INTO locations (city, country) VALUES ('TestCity', 'XX');
    RAISE NOTICE '✗ خطأ: مدينة مكررة قُبلت!';
EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE '✓ المدينة المكررة تم رفضها (UNIQUE شغّال)';
END $$;
SQL

# 5.4 Foreign Key
echo -e "\n[5.4] اختبار Foreign Key (location_id -> locations.id)" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
DO $$
BEGIN
    -- إدخال weather_readings بـ location_id غير موجود
    INSERT INTO weather_readings (location_id, observation_timestamp)
        VALUES ('00000000-0000-0000-0000-000000000000', '2026-04-27 12:00:00+00');
    RAISE NOTICE '✗ خطأ: FK غير موجودة قُبلت!';
EXCEPTION WHEN foreign_key_violation THEN
    RAISE NOTICE '✓ FK غير موجودة تم رفضها (FK constraint شغّال)';
END $$;
SQL

# 5.5 ⚠️ مشكلة محتملة: location_id يقبل NULL!
echo -e "\n[5.5] اختبار: هل location_id في weather_readings يقبل NULL؟" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
DO $$
BEGIN
    INSERT INTO weather_readings (location_id, observation_timestamp)
        VALUES (NULL, '2026-04-27 13:00:00+00');
    RAISE NOTICE '⚠ ملاحظة: location_id قَبِلَ NULL — يُفضّل إضافة NOT NULL';
EXCEPTION WHEN not_null_violation THEN
    RAISE NOTICE '✓ NOT NULL على location_id شغّال';
END $$;
SQL

# 5.6 ⚠️ status field يقبل أي string (مش ENUM)
echo -e "\n[5.6] اختبار: هل status يقبل أي string عشوائي؟" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
DO $$
BEGIN
    INSERT INTO pipeline_runs (status) VALUES ('TYPO_VALUE');
    RAISE NOTICE '⚠ ملاحظة: status قَبِلَ TYPO_VALUE — يُفضّل CHECK constraint أو ENUM';
EXCEPTION WHEN check_violation THEN
    RAISE NOTICE '✓ CHECK على status شغّال';
END $$;
SQL

# 5.7 إحصائيات نهائية
echo -e "\n[5.7] إحصائيات الجداول بعد الاختبارات:" | tee -a "$LOG"
docker compose exec -T "$DB_SERVICE" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL' 2>&1 | tee -a "$LOG"
SELECT 'locations' AS tbl, COUNT(*) FROM locations
UNION ALL SELECT 'pipeline_runs', COUNT(*) FROM pipeline_runs
UNION ALL SELECT 'weather_readings', COUNT(*) FROM weather_readings;
SQL

# ---------- 6. تنظيف ----------
echo -e "\n[STEP 6] تنظيف..." | tee -a "$LOG"
docker compose down -v 2>&1 | tee -a "$LOG"

echo -e "\n=================================================" | tee -a "$LOG"
echo "  انتهى الاختبار. الـ log الكامل في: $LOG" | tee -a "$LOG"
echo "=================================================" | tee -a "$LOG"
