. /home/.env

export CONTAINER_NAME=postgres

function postgres_psql() {
  docker exec -it ${CONTAINER_NAME} psql "$@"
}

function postgres_sql_script() {
  postgres_psql -d "${DB_NAME}" -U "$1" -f "$2"
}

function postgres_sql_shell() {
  local user="$1"; shift
  if [[ $# -gt 0 && "$*" != "" ]] ; then
    run_sql=/tmp/$(date +%s%N)-${user}.sql
    # shellcheck disable=SC2059
    printf "$@" >"$run_sql"
    postgres_sql_script "$user" "$run_sql"
  else
    postgres_psql -d "${DB_NAME}" -U "$user"
  fi
}

function postgres_run_sql() {
  local user="$1"; shift
  postgres_sql_shell "$user" "$@"
}

function postgres_init_schema() {
  postgres_sql_script "${1:-${DB_USER}}" "/home/db/init.sql" \
    >>"/tmp/sql_result-$$" || cat "/tmp/sql_result-$$"
}

function postgres_table_count_rows() {
  postgres_sql_script "${1:-${DB_USER}}" "/home/db/tables_row_count.sql"
}
