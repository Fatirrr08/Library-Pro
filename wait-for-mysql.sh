#!/bin/sh
# wait-for-mysql.sh — Tunggu MySQL siap sebelum menjalankan Tomcat

set -e

host="$1"
port="$2"
shift 2
cmd="$@"

until mysql -h "$host" -P "$port" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" -e "SELECT 1" >/dev/null 2>&1; do
  echo "⏳ Menunggu MySQL $host:$port siap..."
  sleep 3
done

echo "✅ MySQL siap! Mengimpor skema database..."
mysql -h "$host" -P "$port" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" --force < /schema.sql 2>&1 || echo "⚠️ Beberapa error saat impor skema (mungkin sudah ada)"

echo "✅ Menjalankan migrasi database..."
mysql -h "$host" -P "$port" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" -e "ALTER TABLE buku ADD COLUMN foto_buku VARCHAR(255) DEFAULT NULL AFTER abstraksi;" 2>/dev/null || true
mysql -h "$host" -P "$port" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" -e "ALTER TABLE user ADD COLUMN security_question VARCHAR(255) DEFAULT NULL AFTER foto_profil;" 2>/dev/null || true
mysql -h "$host" -P "$port" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" -e "ALTER TABLE user ADD COLUMN security_answer VARCHAR(255) DEFAULT NULL AFTER security_question;" 2>/dev/null || true

echo "✅ Skema siap! Menjalankan: $cmd"
exec $cmd
