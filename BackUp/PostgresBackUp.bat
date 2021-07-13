@echo off
SET WDIR=C:\Respaldo\PG
SET PGHOST=localhost
SET PGUSER=postgres
SET PGPASSWORD=Passw0rd
SET FILEPRFIX=%date:~6,4%%date:~3,2%%date:~0,2%%time:~0,2%%time:~3,2%.custom
SET PGBIN=C:\Program Files\PostgreSQL\9.5\bin\


mkdir "%WDIR%"
cd "%WDIR%"

if exist "%WDIR%\dbs.lst" del "%WDIR%\dbs.lst"
"%PGBIN%psql" -h %PGHOST% -p 5432 -U %PGUSER% -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;" -o "%WDIR%\dbs.lst"

for /f %%a IN (%WDIR%\dbs.lst) DO (
	echo Backup start %date%  %time% %%a
	"%PGBIN%pg_dump" -h %PGHOST% -p 5432 -U %PGUSER% -F c -b -v -f "%WDIR%\%%a%FILEPRFIX%"  %%a
)

forfiles /P "%WDIR%" /M *.* /D -30 /C "cmd /c del @path"
