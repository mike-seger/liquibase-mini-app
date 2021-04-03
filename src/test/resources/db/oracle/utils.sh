function dockerSqlPlus() {
    docker exec -it local-oracle bash -c \
        '
        cat /dev/null >run.sql
        printf "
          set feedback off
          set underline off
          set pagesize 0
          set linesize 32767
          set colsep \"\t\"
          set heading on
          " >>run.sql
        printf "'"$2"'\n" >>run.sql
        #cat run.sql
        export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
        export PATH=$PATH:$ORACLE_HOME/bin
        sqlplus -S '"$1"' <run.sql
        '
}

function oracleTableSizes() {
  dockerSqlPlus "$1" "SELECT table_name, to_number(extractvalue(xmltype(
    dbms_xmlgen.getxml('select count(*) c from '||chr(34)||table_name||chr(34))),'/ROWSET/ROW/C')) row_count
    FROM user_tables
    WHERE iot_type IS NULL
    ORDER BY row_count DESC, table_name;"
}