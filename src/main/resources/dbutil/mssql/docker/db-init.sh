#wait for the SQL Server to come up
sleep 25s

mkdir /var/opt/mssql/ReplData/
chown mssql /var/opt/mssql/ReplData/
chgrp mssql /var/opt/mssql/ReplData/

echo "running set up script"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Secret01 -d master -i /home/db/init.sql
