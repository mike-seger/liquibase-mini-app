--;WITH x AS
--(
--  SELECT
--    [text] = SUBSTRING(t.[text],
--      (s.statement_start_offset/2)+1,
--      COALESCE(NULLIF(s.statement_end_offset,-1),DATALENGTH(t.[text])*2)
--       -(s.statement_start_offset/2)),
--    s.execution_count, s.last_execution_time,
--    s.max_logical_reads, s.max_elapsed_time
--  FROM sys.dm_exec_query_stats AS s
--  CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) AS t
--)

SELECT deqs.last_execution_time AS [Time], dest.TEXT AS [Query]
FROM sys.dm_exec_query_stats AS deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
ORDER BY deqs.last_execution_time DESC
