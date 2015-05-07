@echo off

cls
mode con cols=800 lines=600
color 03

set host=localhost
set port=3306
set user=root
set pswd=1267
set charset=gbk

mysql.exe -h%host% -P%port% -u%user% -p%pswd% --default-character-set=%charset% -v -v -v -e"source dbc_setup.sql"

pause

exit
