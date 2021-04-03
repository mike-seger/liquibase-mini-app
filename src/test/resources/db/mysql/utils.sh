function mysql_run_server() {
  docker rm -f local-mysql
  docker run --name local-mysql -p $1:3306 -e MYSQL_ROOT_PASSWORD=secret \
      -e MYSQL_DATABASE=PUBLIC -e MYSQL_USER=PUBLIC -e MYSQL_PASSWORD=secret -d mysql:8.0.23
}

function mysql_run_sql() {
  docker exec -e MYSQL_PWD=secret -it local-mysql bash -c '
    run_sql=$(date +%s%N).sql
    echo "'"$2"'" >$run_sql
    mysql '"$1"' <$run_sql
    '
}

function mysql_sql_shell() {
  docker exec -it local-mysql mysql -u PUBLIC -psecret
}

function mysql_init_schema() {
  mysql_run_sql PUBLIC "
    DROP DATABASE PUBLIC;
    CREATE DATABASE PUBLIC;
    GRANT ALL PRIVILEGES ON PUBLIC.* TO 'PUBLIC'@'%';
    "
}

function mysql_table_count_rows() {
  mysql_run_sql PUBLIC "
    SELECT * FROM (SELECT TABLE_NAME,SUM(TABLE_ROWS) AS ROW_COUNT
    FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE()
    GROUP BY TABLE_NAME) T ORDER BY row_count DESC, TABLE_NAME;"
}
