. /home/.env

export CONTAINER_NAME=postgres

pg_user=${1:-DB_USER}
# shellcheck disable=SC2016
get_pg_user='if [ $# -gt 1 ] ; then pg_user=$1; shift; fi;'

function postgres_psql() {
  docker exec -it ${CONTAINER_NAME} psql "$@"
}

function postgres_sql_shell() {
  local run_sql
  eval "$get_pg_user"
  if [[ $# -gt 0 && "$*" != "" ]] ; then
    run_sql=/tmp/$(date +%s%N)-$pg_user.sql
    # shellcheck disable=SC2059
    printf "$@" >"$run_sql"
    postgres_psql -d "${DB_NAME}" -U "$pg_user" -f "$run_sql"
  else
    postgres_psql -d "${DB_NAME}" -U "$pg_user"
  fi
}

function postgres_run_sql() {
  eval "$get_pg_user"
  postgres_sql_shell "$pg_user" "$@"
}

function postgres_init_schema() {
  eval "$get_pg_user"
  postgres_run_sql "$pg_user" "\i /home/db/init.sql" \
    >>"/tmp/sql_result-$$" || cat "/tmp/sql_result-$$"
}

function postgres_table_count_rows() {
  eval "$get_pg_user"
  postgres_run_sql "$pg_user" "\i /home/db/tables_row_count.sql"
}
