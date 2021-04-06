. /home/.env

export CONTAINER_NAME=mssql

function mssql_sqlcmd() {
  # shellcheck disable=SC2145
  docker exec -it mssql bash -c "/opt/mssql-tools/bin/sqlcmd -S localhost $@"
}

function mssql_sql_script() {
  mssql_sqlcmd -U SA -P "${DB_PASSWORD}" -i "$2"
}

function mssql_run_sql() {
  local run_sql=/tmp/$(date +%s%N).sql
  echo "$*" >"$run_sql"
  mssql_sqlcmd -U SA -P "${DB_PASSWORD}" -i "$run_sql"
}

function mssql_sql_shell() {
  mssql_sqlcmd -U SA -P "${DB_PASSWORD}"
}

function mssql_init_schema() {
  mssql_sql_script SA "/home/db/init.sql"
}

function mssql_table_count_rows() {
  mssql_sql_script SA "/home/db/tables_row_count.sql"
}
