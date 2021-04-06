#wait for the SQL Server to come up
/home/docker/wait-for localhost:1433 -- Server listening on localhost:1433

mkdir /var/opt/mssql/ReplData/
chown mssql /var/opt/mssql/ReplData/

echo "Running set up script"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Secret01 -d master -i /home/db/init.sql
