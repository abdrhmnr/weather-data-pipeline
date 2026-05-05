#!/bin/bash

# إعدادات
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_DIR="backups"
BACKUP_FILE="$BACKUP_DIR/weather_backup_$DATE.sql"

# إنشاء مجلد الـ backups
mkdir -p $BACKUP_DIR

# تصدير قاعدة البيانات
docker-compose exec -T db pg_dump -U postgres weather_db > $BACKUP_FILE

echo "✅ تم التصدير: $BACKUP_FILE"

# رفع على GitHub
git add $BACKUP_FILE
git commit -m "🔄 Auto backup - $DATE"
git push origin main

echo "✅ تم الرفع على GitHub!"
