@echo off

cls
title MySQL���ݿ�ͻ���
mode con cols=800 lines=600
color 03

set host=localhost
set port=3306
set user=proxy
set pswd=proxy
set charset=gbk
set database=databasecourse

echo=�������û���:
set /p usr=

if [%usr%] == [] (

	set usr=%user%
) else (

	set pswd=
)

%~dp0dbex\mysql.exe -h%host% -P%port% -u%usr% -p%pswd% --default-character-set=%charset% %database%

exit
