@echo off

cls
title MySQL数据库客户端
mode con cols=800 lines=600
color 03

set host=localhost
set port=3306
set user=proxy
set pswd=proxy
set charset=gbk
set database=databasecourse

echo=请输入用户名:
set /p usr=

if [%usr%] == [] (

	set usr=%user%
) else (

	set pswd=
)

%~dp0dbex\mysql.exe -h%host% -P%port% -u%usr% -p%pswd% --default-character-set=%charset% %database%

exit
