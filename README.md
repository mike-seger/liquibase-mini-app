# LiquiBase Mini App

This is a mini SpringBoot application demonstrating liquibase for a selection of DBs.

## DB servers
The docker-compose.yaml file defines the following dbs:
- postgres 
- oracle
- mysql

### Starting
All DB servers can be started by issuing one of the commands in the repository root:
```
## start all DBs: postgres, oracle, mysql
docker-compose up -d
## start the selected DBs:
docker-compose up -d postgres ...
```

### Running DB commands
A shell function is provided to run commands on any of the started DBs.  
The function can be activated by sourcing the common.sh script: 
```
. src/main/resources/common.sh
```

The following commands are now available:
```
dbex postgres run_sql
dbex postgres sql_shell
dbex postgres init_schema
dbex postgres table_count_rows
```
You can apply these commands to any of the other DBs listed above, instead of postgres.

## Start a liquibase migration
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
