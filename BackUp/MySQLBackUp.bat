@echo on
SET WDIR=C:\Respaldo\MYSQL
SET MYHOST=localhost
SET MYUSER=root
SET MYPASSWORD=Passw0rd
SET FILESUFFIX=%date:~6,4%%date:~3,2%%date:~0,2%%time:~0,2%%time:~3,2%.sql
SET MYBIN=C:\Program Files (x86)\MySQL\MySQL Server 5.0\bin\
SET Z7BIN=C:\Program Files\7-Zip\7z.exe

mkdir "%WDIR%"
cd "%WDIR%"

if exist "%WDIR%\dbs.lst" del "%WDIR%\dbs.lst"
"%MYBIN%mysql" --password="%MYPASSWORD%" --user="%MYUSER%" --host="%MYHOST%" -sN -e "show databases;" > "%WDIR%\dbs.lst"

for /f %%a IN (%WDIR%\dbs.lst) DO (
	echo Backup start %date%  %time% %%a
	"%MYBIN%mysqldump" --single-transaction --flush-logs --opt --host="%MYHOST%" --password="%MYPASSWORD%" --user="%MYUSER%" "%%a" > "%WDIR%\%%a%FILESUFFIX%"
)

for /R "%WDIR%" %%f in (*.sql) do ("%Z7BIN%" a -sdel -tbzip2 "%%f.bz2" "%%f")

Forfiles /P "%WDIR%" /M *.* /D -30 /C "cmd /c del @path"

