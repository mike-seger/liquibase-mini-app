# Starting a DB
## Postgresql
```
# Start DB on port 25432
docker run --name local-pg -p 25432:5432 -e POSTGRES_PASSWORD=secret -d postgres:alpine

# Connect to DB on port 25432
docker run --rm -it postgres psql postgresql://postgres:secret@$(hostname):25432/

# Show table statistics
SELECT relname as table_name, n_live_tup as row_count
    FROM pg_stat_user_tables WHERE schemaname='public' 
    ORDER BY row_count DESC, table_name;

# recreate public schema
DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO postgres; GRANT ALL ON SCHEMA public TO public;
```

## MySQL
```
# Start DB on port 33306
docker run --name local-mysql -p 33306:3306 -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=PUBLIC -e MYSQL_USER=PUBLIC -e MYSQL_PASSWORD=secret -d mysql

# Connect to DB on port 33306
docker run -it mysql mysql -h $(hostname) -P 33306 -uPUBLIC -psecret

# Show table statistics
SELECT * FROM (SELECT TABLE_NAME,SUM(TABLE_ROWS) AS row_count 
    FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() 
    GROUP BY TABLE_NAME) T ORDER BY row_count DESC, TABLE_NAME;

# recreate the PUBLIC schema
docker exec -i local-mysql sh -c 'MYSQL_PWD=secret mysql --force -uroot' <<< \
    "DROP DATABASE PUBLIC; CREATE DATABASE PUBLIC; GRANT ALL PRIVILEGES ON PUBLIC.* TO 'PUBLIC'@'%';"
```

## Oracle
```
# https://catonrug.blogspot.com/2019/12/run-oracle-xe-11g-via-docker.html
# Start DB on port 49161
docker run --name local-oracle -d -p 49521:1521 -e ORACLE_PWD=secret -e ORACLE_DISABLE_ASYNCH_IO=true \
    -e ORACLE_CHARACTERSET=utf8 -e ORACLE_ALLOW_REMOTE=true oracleinanutshell/oracle-xe-11g

# source shell convenience functions to run sql commands against DB
. src/test/resources/db/oracle/utils.sh
    
# re-initialize DB with user/schema public1
dockerSqlPlus "sys/oracle@XE as sysdba" "DROP USER public1 CASCADE;\nCREATE USER PUBLIC1 IDENTIFIED BY secret;\nGRANT CONNECT, RESOURCE, DBA  TO PUBLIC1;"

# Show table statistics
oracleTableSizes "public1/secret@XE"
        
# Run interactive sqlplus against local-oracle
docker exec -it local-oracle bash
sqlplus public1/secret@XE
```

# Start a liquibase migration
```
SPRING_PROFILES_ACTIVE=liquibase-migrate,h2 ./gradlew bootRun
```
h2 can alternatively be one of the following profiles:
- postgres
- mysql
- oracle (work in progress)
```
