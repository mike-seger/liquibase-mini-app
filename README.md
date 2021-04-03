This is a mini SpringBoot application demonstrating liquibase for postgres, mysql and oracle.
The DBs are run in docker and can be managed by the provided convenience scripts.

# DB servers

## Postgresql
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/postgres/utils.sh

postgres_run_server 25432
postgres_sql_shell
postgres_table_count_rows
postgres_init_schema
```

## MySQL
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/mysql/utils.sh

mysql_run_server 33306
mysql_sql_shell
mysql_table_count_rows
mysql_init_schema
```

## Oracle
```
# source shell convenience functions to manage DB in docker
. src/test/resources/db/oracle/utils.sh

oracle_run_server 49521
oracle_sql_shell
oracle_table_count_rows
oracle_init_schema
```
More info:
- https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g
- https://catonrug.blogspot.com/2019/12/run-oracle-xe-11g-via-docker.html

# Start a liquibase migration
```
SPRING_PROFILES_ACTIVE=liquibase-migrate,h2 ./gradlew bootRun
```
Instead of h2, one of the following profiles can be used:
- postgres
- mysql
- oracle
```
