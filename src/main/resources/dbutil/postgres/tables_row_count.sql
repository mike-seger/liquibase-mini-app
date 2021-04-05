SELECT relname as table_name, n_live_tup as row_count
FROM pg_stat_user_tables
WHERE schemaname='user01'
ORDER BY row_count DESC, table_name;