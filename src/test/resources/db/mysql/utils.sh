function mysql_run_sql() {
  docker exec -e MYSQL_PWD=secret -it local-mysql bash -c '
    run_sql=$(date +%s%N).sql
    echo "'"$2"'" >$run_sql
    mysql '"$1"' <$run_sql
    '
}

function mysql_sql_shell() {
  docker exec -it local-mysql mysql -u user01 -psecret
}

function mysql_init_schema() {
  mysql_run_sql user01 "source /docker-entrypoint-initdb.d/init.sql"
}

function mysql_table_count_rows() {
  mysql_run_sql user01 "source /tmp/tables_row_count.sql;"
}
