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

# Connect
docker exec -it local-oracle bash
# sqlplus sys as sysdba
# enter 'oracle' as password

# -v [<host mount point>:]/opt/oracle/oradata \

drop table system.article cascade constraints;
drop table system.article_favorited cascade constraints;
drop table system.article_tag cascade constraints;
drop table system.author cascade constraints;
drop table system.author_follower cascade constraints;
drop table system.claim cascade constraints;
drop table system.claim_rebuttal cascade constraints;
drop table system."comment" cascade constraints;
drop table system.contact cascade constraints;
drop table system.crisis cascade constraints;
drop table system.hero cascade constraints;
drop table system.jhi_authority cascade constraints;
drop table system.jhi_persistent_audit_event cascade constraints;
drop table system.jhi_persistent_audit_evt_data cascade constraints;
drop table system.jhi_social_user_connection cascade constraints;
drop table system.jhi_user cascade constraints;
drop table system.jhi_user_authority cascade constraints;
drop table system.message cascade constraints;
drop table system.note cascade constraints;
drop table system.rebuttal cascade constraints;
drop table system.tag cascade constraints;
drop table system.talk cascade constraints;
drop table system.databasechangelog cascade constraints;
drop table system.databasechangeloglock cascade constraints;
drop sequence system.hibernate_sequence;

```

# Start a liquibase migration
```
SPRING_PROFILES_ACTIVE=liquibase-migrate,<ds-profile> ./gradlew bootRun
```
ds-profile is one of:
- h2
- postgres
- mysql
- oracle (work in progress)

# so e.g.:
```
SPRING_PROFILES_ACTIVE=liquibase-migrate,postgres ./gradlew bootRun
```
