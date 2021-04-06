-- Schema initialization
CREATE DATABASE user01;
GO

USE user01;
GO

EXEC sys.sp_configure 'user options', '512'; -- 512 = NOCOUNT
GO
RECONFIGURE
GO

DROP SCHEMA user01;
GO

DROP USER user01;
GO

CREATE SCHEMA user01;
GO

CREATE LOGIN user01 WITH PASSWORD = 'Secret01', DEFAULT_DATABASE = master;
GO

CREATE USER user01 FOR LOGIN user01;
GO

ALTER ROLE [db_owner] add member [user01];
GO

ALTER LOGIN user01 WITH DEFAULT_DATABASE = user01;
GO

ALTER USER [user01] WITH DEFAULT_SCHEMA=user01

ALTER DATABASE user01 SET ANSI_WARNINGS OFF;
GO

--EXEC sp_addrolemember 'db_owner', 'user01'
