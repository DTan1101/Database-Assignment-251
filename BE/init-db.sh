#!/bin/bash
set -e

echo "Starting SQL Server..."
/opt/mssql/bin/sqlservr &

# Chọn đường dẫn sqlcmd phù hợp với image
if [ -x "/opt/mssql-tools18/bin/sqlcmd" ]; then
  SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
elif [ -x "/opt/mssql-tools/bin/sqlcmd" ]; then
  SQLCMD="/opt/mssql-tools/bin/sqlcmd"
else
  echo "sqlcmd not found!"
  exit 1
fi

# Lấy password SA từ env (ưu tiên SA_PASSWORD, nếu không thì MSSQL_SA_PASSWORD)
SA_PW="${SA_PASSWORD:-$MSSQL_SA_PASSWORD}"

echo "Waiting for SQL Server to be ready..."
# Retry logic: chờ tối đa 90 giây
RETRY_COUNT=0
MAX_RETRIES=90

until "$SQLCMD" -C -S localhost -U sa -P "$SA_PW" -Q "SELECT 1" &> /dev/null
do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "ERROR: SQL Server did not start within 90 seconds."
    exit 1
  fi
  echo "Attempt $RETRY_COUNT/$MAX_RETRIES: SQL Server is not ready yet, waiting 1 second..."
  sleep 1
done

echo "SQL Server is ready!"

echo "Running init scripts in /docker-entrypoint-initdb.d..."

for f in /docker-entrypoint-initdb.d/*.sql
do
  if [ -f "$f" ]; then
    echo "===================================="
    echo "Running $f"
    # THÊM -C Ở ĐÂY: trust self-signed certificate
    "$SQLCMD" -C -S localhost -U sa -P "$SA_PW" -i "$f"
  fi
done

echo "All SQL scripts executed."
wait
