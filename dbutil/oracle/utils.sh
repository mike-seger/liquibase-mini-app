export ORA_DB_USER=USER01
export ORA_DB_PWD=secret
export ORA_NAME=local-oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe

function oracle_init_schema() {
  oracle_run_sql "@/tmp/init.sql"
}

function oracle_run_sql() {
  if [ $# -ge 2 ] ; then
    cred="$1"
    sql=$2
  else
    cred="${ORA_DB_USER}/${ORA_DB_PWD}@XE"
    sql=$1
  fi
  docker exec -it -e ORACLE_HOME=$ORACLE_HOME $ORA_NAME bash -c \
    '
    run_sql=$(date +%s%N).sql
    printf "@/home/sqlplus-init.sql\n'"$sql"'\n" >$run_sql
    exit | $ORACLE_HOME/bin/sqlplus -S '"$cred"' @"$run_sql"
    '
}

function oracle_sql_shell() {
  docker exec -it -e ORACLE_HOME=$ORACLE_HOME $ORA_NAME bash -c \
    '$ORACLE_HOME/bin/sqlplus '"$ORA_DB_USER/$ORA_DB_PWD"'@XE'
}

function oracle_table_count_rows() {
  oracle_run_sql "${1:-${ORA_DB_USER}/${ORA_DB_PWD}@XE}" "@/home/tables_row_count.sql"
}
