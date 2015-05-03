@echo off

cls
title 数据库课程上机习题解答程序
mode con cols=800 lines=600
color 03

set host=localhost
set port=3306
set user=proxy
set pswd=proxy
set charset=gbk
set database=databasecourse

set home=%~dp0dbex
set path=%path%;%home%
set executesql=mysql.exe -h%host% -P%port% -u%user% -p%pswd% --default-character-set=%charset% %database%

echo=请输入你的学号:
set /p sid=

mysql.exe -h%host% -P%port% -u%sid% -p%sid% -e"exit"

if errorlevel 1 (

	cls
	echo=
	echo=    无法访问数据库!
	echo=

	pause
	exit
) else (

	cls
	echo=
	echo=    身份验证成功!
	echo=
)

echo=数据库课程上机习题解答程序开始执行, 请等待...
echo=
echo=

for /f "usebackq tokens=*" %%t in (`%executesql% -N -s -e"SELECT Name FROM Students WHERE Number = '%sid%'"`) do (

	set reporting=3-%sid%-%%t.doc
)

if exist %reporting% (

	del %reporting%
)

set q_tmplt=%%a
set tmplt_arg=%%b
set ans_tmplt=%%c

set ex_idx=1,2,3,4,5,6,7,8,9,10,11,12,13
set ex_split=%%N%%O%%P%%Q%%R%%S%%T%%U%%V%%W%%X%%Y%%Z

set arg_idx=1,2,3,4,5,6,7,8,9,10,11,12
set arg_split=%%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L

set ex_text=%%N%%A%%O%%B%%P%%C%%Q%%D%%R%%E%%S%%F%%T%%G%%U%%H%%V%%I%%W%%J%%X%%K%%Y%%L%%Z

for /f "delims=# tokens=1,2,3" %%a in (%home%\ex\ex.txt) do (

	echo=@echo off > %home%\ex_bat\%ans_tmplt%.bat

	for /f "delims= tokens=*" %%l in (%home%\ex\%ans_tmplt%) do (

		echo=echo=    %%l>> %home%\ex_bat\%ans_tmplt%.bat
	)

	for /f "usebackq delims=? tokens=%ex_idx%" %%N in ('%q_tmplt%') do (

		for /f "usebackq tokens=%arg_idx%" %%A in (`%executesql% -N -s -e"source %home%\ex\%tmplt_arg%"`) do (

			call %home%\ex_bat\%ans_tmplt%.bat %arg_split% > %home%\ex_sql\%ans_tmplt%.sql

			echo=题目:>> %reporting%
			echo=    %ex_text%>> %reporting%
			echo=>> %reporting%

			echo=sql语句:>> %reporting%
			type %home%\ex_sql\%ans_tmplt%.sql>> %reporting%
			echo=>> %reporting%

			echo=执行结果:>> %reporting%
			%executesql% -t -e"source %home%\ex_sql\%ans_tmplt%.sql">> %reporting%
			echo=>> %reporting%
		)
	)
)

start %reporting%

exit
