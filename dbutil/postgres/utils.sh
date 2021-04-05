function postgres_run_server() {
  docker rm -f local-pg
  docker run --name local-pg -p "${1:-65001}":5432 -e POSTGRES_PASSWORD=secret -d postgres:13-alpine
}

function postgres_sql_shell() {
  user="${1:-postgres}"; [ $# -gt 0 ] && shift
  docker exec -it local-pg psql -U "$user" "$@"
}

function postgres_run_sql() {
  postgres_sql_shell "$1" -c "$2"
}

function postgres_init_schema() {
  postgres_run_sql "${1:-postgres}" "\i /docker-entrypoint-initdb.d/init.sql" \
    >>"/tmp/sql-$$" || cat "/tmp/sql-$$"
}

function postgres_table_count_rows() {
  postgres_run_sql "${1:-postgres}" "\i /home/tables_row_count.sql"
}
