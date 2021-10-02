### MS SQL Server

**For Windows**: in every command replace `\` (backslash) at the end of line with `` ` `` (backtick). And use PowerShell.

To connect:

```bash
docker run --rm -e 'ACCEPT_EULA=Y' -p 1433:1433 -d \
-v $(pwd):/userdir -w /userdir \
--name 'msserver' 'mcr.microsoft.com/mssql/server:2019-latest'
```

To open `sqlcmd` shell in `demo` database:

```bash
docker exec -it msserver /opt/mssql-tools/bin/sqlcmd \
-S demosqlwesteurope.database.windows.net -U 'student_01' -P '!MiptSql_01' -d 'demo'
```

To list all tables:

```bash
SELECT * FROM SYSOBJECTS WHERE xtype = 'U';
GO
```

To execute `.sql` file:

```bash
docker exec -it msserver /opt/mssql-tools/bin/sqlcmd \
-S demosqlwesteurope.database.windows.net -U 'student_01' -P '!MiptSql_01' -d 'demo' \
-i 'temp.sql'
```

**`temp.sql` must be in the same directory where the first command was executed.**

---

[T-SQL reference here.](https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver15)
