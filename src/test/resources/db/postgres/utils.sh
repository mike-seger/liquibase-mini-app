function postgres_run_server() {
  docker rm -f local-pg
  docker run --name local-pg -p $1:5432 -e POSTGRES_PASSWORD=secret -d postgres:13-alpine
}

function postgres_run_sql() {
  docker exec -it local-pg psql -U $1 -c "$2"
}

function postgres_sql_shell() {
  docker exec -it local-pg psql -U postgres
}

function postgres_init_schema() {
  postgres_run_sql postgres "
    DROP SCHEMA public CASCADE;
    CREATE SCHEMA public;
    GRANT ALL ON SCHEMA public TO postgres;
    GRANT ALL ON SCHEMA public TO public;"
}

function postgres_table_count_rows() {
  postgres_run_sql postgres "
    SELECT relname as table_name, n_live_tup as row_count
    FROM pg_stat_user_tables
    WHERE schemaname='public'
    ORDER BY row_count DESC, table_name;"
}
