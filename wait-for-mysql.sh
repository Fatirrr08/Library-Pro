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

echo "✅ MySQL siap! Menjalankan: $cmd"
exec $cmd
