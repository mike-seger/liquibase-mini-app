

# Starting a DB
## Postgresql
```
# Start DB on port 25432
docker run --name local-pg -p 25432:5432 -e POSTGRES_PASSWORD=secret -d postgres:alpine

# Connect a pqsl client to DB
docker run --rm -it postgres psql postgresql://postgres:secret@$(hostname):25432/

# Show table statistics
SELECT relname as table_name, n_live_tup as row_count
    FROM pg_stat_user_tables WHERE schemaname='public' 
    ORDER BY row_count DESC, table_name;

# recreate public schema
DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO postgres; GRANT ALL ON SCHEMA public TO public;
```

# Starting the application
```
# Liquibase migrate
SPRING_PROFILES_ACTIVE=liquibase-migrate ./gradlew bootRun

# A few other datasources are accessible by using the appropriate profile, such as postgres
SPRING_PROFILES_ACTIVE=liquibase-migrate,postgres ./gradlew bootRun
```
