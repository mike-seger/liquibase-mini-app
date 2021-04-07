# Liquibase Mini App

This is a core SpringBoot application demonstrating a portable liquibase configuration for a selection of databases.
The configuration contains a typical set of tables and data.

## Databases
The docker-compose.yaml file provides the following databases as a service:
- postgres 
- oracle
- mysql

### Starting
Database servers can be started by issuing one of the commands from the repository root:
```
## start all database servers: postgres, oracle, mysql
docker-compose up -d
## start "just" selected database servers:
docker-compose up -d postgres ...
```
The databases will initially contain no user tables.

### Running DB commands
A convenience bash function is provided to run commands on any of the started databases.  
The function can be activated by sourcing the common.sh script: 
```
. src/main/resources/dbutil/common/common.sh
```

The following commands are now available:
```
dbex postgres run_sql
dbex postgres sql_shell
dbex postgres init_schema
dbex postgres table_count_rows
```
Any started database from above can be accessed, instead of postgres.

## Run a liquibase migration
```
SPRING_PROFILES_ACTIVE=liquibase-migrate,h2 ./gradlew bootRun
```
Instead of h2, one of the following profiles can be used:
- postgres
- mysql
- oracle

## Links
- https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g
- https://catonrug.blogspot.com/2019/12/run-oracle-xe-11g-via-docker.html
- https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-deployment?view=sql-server-ver15&pivots=cs1-bash
- https://www.mssqltips.com/sqlservertip/2537/sql-server-row-count-for-all-tables-in-a-database/
