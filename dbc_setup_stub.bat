@echo off

set host=localhost
set port=3306
set user=root
set pswd=1267
set charset=gbk
set database=databasecourse

start /max /d %~dp0dbc %~dp0dbc\dbc_setup.bat %1 %2 %3 %4 %5 %6 %7 %8 %9

exit
