### MS SQL Server

To connect:

```bash
docker run --rm -it -e 'ACCEPT_EULA=Y' -p 1433:1433 \
'mcr.microsoft.com/mssql/server:2019-latest' /opt/mssql-tools/bin/sqlcmd \
-S demosqlwesteurope.database.windows.net -U 'student_01' -P '!MiptSql_01' -d 'demo'
```

To list all tables:

```bash
SELECT * FROM SYSOBJECTS WHERE xtype = 'U';
GO
```

[T-SQL reference here.](https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver15)
