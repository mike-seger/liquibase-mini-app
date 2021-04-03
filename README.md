# DB servers
## Postgresql
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/postgres/utils.sh

postgres_run_server
postgres_run_sql
postgres_init_schema
postgres_table_count_rows

# Start DB on port 25432
postgres_run_server 25432

# Connect to DB on port 25432
docker exec -it local-pg psql -U postgres
    
# re-initialize DB with user/schema public1
postgres_init_schema

# Show table statistics
SELECT relname as table_name, n_live_tup as row_count
    FROM pg_stat_user_tables WHERE schemaname='public' 
    ORDER BY row_count DESC, table_name;

# recreate public schema
DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO postgres; GRANT ALL ON SCHEMA public TO public;
```

## MySQL
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/mysql/utils.sh

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
# source shell convenience functions to manage DB in docker
. src/test/resources/db/oracle/utils.sh

# Start DB on port 49521
oracle_run_server 49521
    
# re-initialize DB with user/schema public1
oracle_init_schema

# Show table row count
oracle_table_count_rows
        
# Run interactive sqlplus against local-oracle
docker exec -it local-oracle bash
sqlplus public1/secret@XE

# More info
# https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g
# https://catonrug.blogspot.com/2019/12/run-oracle-xe-11g-via-docker.html
```

# Start a liquibase migration
```
SPRING_PROFILES_ACTIVE=liquibase-migrate,h2 ./gradlew bootRun
```
Instead of h2, one of the following profiles can be used:
- postgres
- mysql
- oracle (work in progress)
```
