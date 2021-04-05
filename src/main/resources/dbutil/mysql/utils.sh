function mysql_mysql() {
  # shellcheck disable=SC2145
  docker exec -it mysql -e MYSQL_PWD=secret bash -c "mysql $@"
}

function mysql_run_sql() {
  local run_sql=/tmp/$(date +%s%N).sql
  local user="$1"
  shift
  echo "$*" >"$run_sql"
  MYSQL_PWD=secret mysql_mysql -u "$user" user01 -e "source $run_sql"
}

function mysql_sql_shell() {
  mysql_mysql -u "$1" -psecret
}

function mysql_init_schema() {
  mysql_run_sql root "source /docker-entrypoint-initdb.d/init.sql"
}

function mysql_table_count_rows() {
  mysql_run_sql "$1" "source /home/tables_row_count.sql;"
}
