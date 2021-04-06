. /home/.env

export CONTAINER_NAME=oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe

function oracle_run_sql0() {
  docker exec -it -e ORACLE_HOME=$ORACLE_HOME $CONTAINER_NAME bash -c "$@"
}

function oracle_run_sql() {
  if [ $# -ge 2 ] ; then
    cred="$1"
    shift
  else
    cred="${DB_USER}/${DB_PASSWORD}@XE"
  fi
  run_sql=/tmp/$(date +%s%N).sql
  echo "@/home/db/sqlplus-init.sql" >"$run_sql"
  # shellcheck disable=SC2059
  printf "$*" >>"$run_sql"
  oracle_run_sql0 "exit | $ORACLE_HOME/bin/sqlplus -S $cred @$run_sql"
}

function oracle_sql_shell() {
  oracle_run_sql0 "$ORACLE_HOME/bin/sqlplus" "${DB_USER}/${DB_PASSWORD}@XE"
}

function oracle_init_schema() {
  oracle_run_sql "system/oracle@XE" "@/home/db/init.sql"
}

function oracle_table_count_rows() {
  oracle_run_sql "${1:-${DB_USER}/${DB_PASSWORD}@XE}" "@/home/db/tables_row_count.sql"
}
