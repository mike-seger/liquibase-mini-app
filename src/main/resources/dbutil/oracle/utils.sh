export ORA_DB_USER=USER01
export ORA_DB_PWD=secret
export ORA_NAME=local-oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe

function oracle_run_sql0() {
  docker exec -it -e ORACLE_HOME=$ORACLE_HOME $ORA_NAME bash -c "$@"
}

function oracle_run_sql() {
  if [ $# -ge 2 ] ; then
    cred="$1"
    shift
  else
    cred="${ORA_DB_USER}/${ORA_DB_PWD}@XE"
  fi
  run_sql=/tmp/$(date +%s%N).sql
  echo "@/home/sqlplus-init.sql" >"$run_sql"
  # shellcheck disable=SC2059
  printf "$*" >>"$run_sql"
  oracle_run_sql0 "exit | $ORACLE_HOME/bin/sqlplus -S $cred @$run_sql"
}

function oracle_sql_shell() {
  oracle_run_sql0 "$ORACLE_HOME/bin/sqlplus $ORA_DB_USER/${ORA_DB_PWD}@XE"
}

function oracle_init_schema() {
  oracle_run_sql "@/tmp/init.sql"
}

function oracle_table_count_rows() {
  oracle_run_sql "${1:-${ORA_DB_USER}/${ORA_DB_PWD}@XE}" "@/home/tables_row_count.sql"
}
