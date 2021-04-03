# DB servers
## Postgresql
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/postgres/utils.sh

# Start DB on port 25432
postgres_run_server 25432

# Connect to DB
postgres_sql_shell
    
# Re-initialize user/schema public1
postgres_init_schema

# Count table rows
postgres_table_count_rows
```

## MySQL
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/mysql/utils.sh

# Start DB on port 33306
mysql_run_server 33306

# Run SQL shell in local-mysql
mysql_sql_shell

# Count table rows
mysql_table_count_rows

# Re-initialize the PUBLIC schema
mysql_init_schema
```

## Oracle
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/oracle/utils.sh

# Start DB on port 49521
oracle_run_server 49521
    
# Re-initialize DB with user/schema public1
oracle_init_schema

# Count table rows
oracle_table_count_rows
        
# Run interactive sqlplus against local-oracle
oracle_sql_shell

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
