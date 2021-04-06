. /home/.env

export CONTAINER_NAME=mysql

function mysql_mysql() {
  # shellcheck disable=SC2145
  docker exec -it mysql -e MYSQL_PWD="${DB_PASSWORD}" bash -c "mysql $@"
}

function mysql_run_sql() {
  local run_sql=/tmp/$(date +%s%N).sql
  local user="$1"
  shift
  echo "$*" >"$run_sql"
  MYSQL_PWD="${DB_PASSWORD}" mysql_mysql -u "$user" "${DB_NAME}" -e "source $run_sql"
}

function mysql_sql_shell() {
  mysql_mysql -u "${1:-$DB_USER}" -p"${DB_PASSWORD}"
}

function mysql_init_schema() {
  mysql_run_sql root "source /home/db/init.sql"
}

function mysql_table_count_rows() {
  mysql_run_sql "${1:-$DB_USER}" "source /home/db/tables_row_count.sql"
}
