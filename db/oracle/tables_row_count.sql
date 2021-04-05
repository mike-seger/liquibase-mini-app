SELECT TABLE_NAME, to_number(extractvalue(xmltype(
    dbms_xmlgen.getxml('select count(*) c from '||chr(34)||TABLE_NAME||chr(34))),'/ROWSET/ROW/C')) ROW_COUNT
FROM user_tables
WHERE iot_type IS NULL
ORDER BY ROW_COUNT DESC, TABLE_NAME;