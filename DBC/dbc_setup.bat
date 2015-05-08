@echo off

cls
title 数据库课程数据库部署程序
mode con cols=800 lines=600
color 03

set home=%~dp0
set path=%path%;%home%

mysql.exe -h%host% -P%port% -u%user% -p%pswd% --default-character-set=%charset% -v -v -v -e"SOURCE %home%\sql\dbc_setup.sql"
mysql.exe -h%host% -P%port% -u%user% -p%pswd% --default-character-set=%charset% -s -t %database%

exit
