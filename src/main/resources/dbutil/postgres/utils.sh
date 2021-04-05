function postgres_run_server() {
  docker rm -f local-pg
  docker run --name postgres -p "${1:-65001}":5432 -e POSTGRES_PASSWORD=secret -d postgres:13-alpine
}

pg_user=postgres
# shellcheck disable=SC2016
get_pg_user='if [ $# -gt 1 ] ; then pg_user=$1; shift; fi;'

function postgres_psql() {
  echo docker exec -it postgres psql "$@"
}

function postgres_sql_shell() {
  eval "$get_pg_user"
  local run_sql=/tmp/$(date +%s%N).sql
  local args=""
  if [ $# -gt 0 ] ; then
    postgres_psql -U "$pg_user" <<<"$@"
  else
    postgres_psql -U "$pg_user"
  fi
}

function postgres_run_sql() {
  eval "$get_pg_user"
  postgres_sql_shell "$pg_user" "$@"
}

function postgres_init_schema() {
  eval "$get_pg_user"
  postgres_run_sql "$pg_user" "\i /docker-entrypoint-initdb.d/init.sql" \
    >>"/tmp/sql_result-$$" || cat "/tmp/sql_result-$$"
}

function postgres_table_count_rows() {
  eval "$get_pg_user"
  postgres_run_sql "$pg_user" "\i /home/tables_row_count.sql"
}
