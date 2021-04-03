export ORA_DB_USER=PUBLIC1
export ORA_DB_PWD=secret
export ORA_NAME=local-oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe

function oracle_init_schema() {
  oracle_run_sql "sys/oracle@XE as sysdba" "WHENEVER SQLERROR CONTINUE;
    DROP USER $ORA_DB_USER CASCADE;
    CREATE USER $ORA_DB_USER IDENTIFIED BY $ORA_DB_PWD;
    GRANT CONNECT, RESOURCE, DBA TO $ORA_DB_USER;"
}

function oracle_run_server() {
  docker rm -f $ORA_NAME
  docker run --name $ORA_NAME -d -p $1:1521 -e TZ=UTC --env JAVA_OPTS="-Doracle.jdbc.timezoneAsRegion=false -Duser.timezone=UTC" \
    -e ORACLE_PWD="$ORA_DB_PWD" -e ORACLE_DISABLE_ASYNCH_IO=true \
    -e ORACLE_CHARACTERSET=utf8 -e ORACLE_ALLOW_REMOTE=true oracleinanutshell/oracle-xe-11g:1.0.0
  echo "Started DB server. Waiting for initialization"
  sleep 25
  oracle_init_schema >/dev/null
}

function oracle_run_sql() {
  docker exec -it -e ORACLE_HOME=$ORACLE_HOME $ORA_NAME bash -c \
    '
    run_sql=$(date +%s%N).sql
    printf "
      set feedback off
      set underline off
      set pagesize 0
      set linesize 32767
      set colsep \"\t\"
      set heading on
      " >$run_sql
    printf "'"$2"'\n" >>$run_sql
    $ORACLE_HOME/bin/sqlplus -S '"$1"' <$run_sql
    '
}

function oracle_sql_shell() {
  docker exec -it -e ORACLE_HOME=$ORACLE_HOME $ORA_NAME bash -c '$ORACLE_HOME/bin/sqlplus '"$ORA_DB_USER/$ORA_DB_PWD"'@XE'
}

function oracle_table_count_rows() {
  oracle_run_sql "$ORA_DB_USER/$ORA_DB_PWD"@XE "SELECT TABLE_NAME, to_number(extractvalue(xmltype(
    dbms_xmlgen.getxml('select count(*) c from '||chr(34)||TABLE_NAME||chr(34))),'/ROWSET/ROW/C')) ROW_COUNT
    FROM user_tables
    WHERE iot_type IS NULL
    ORDER BY ROW_COUNT DESC, TABLE_NAME;"
}
