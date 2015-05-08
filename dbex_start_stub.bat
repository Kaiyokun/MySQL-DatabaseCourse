@echo off

set host=localhost
set port=3306
set user=proxy
set pswd=proxy
set charset=gbk
set database=databasecourse

start /max /d %~dp0dbex %~dp0dbex\dbex_start.bat %1 %2 %3 %4 %5 %6 %7 %8 %9

exit
