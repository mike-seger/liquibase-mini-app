

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

# recreate public schema
docker exec -i local-mysql sh -c 'MYSQL_PWD=secret mysql --force -uroot' <<< \
    "DROP DATABASE PUBLIC; CREATE DATABASE PUBLIC; GRANT ALL PRIVILEGES ON PUBLIC.* TO 'PUBLIC'@'%';"
```

# Starting the application
```
# Liquibase migrate
SPRING_PROFILES_ACTIVE=liquibase-migrate ./gradlew bootRun

# A few other datasources are accessible by using the appropriate profile, such as postgres
SPRING_PROFILES_ACTIVE=liquibase-migrate,postgres HOST=$(hostname) ./gradlew bootRun
```
