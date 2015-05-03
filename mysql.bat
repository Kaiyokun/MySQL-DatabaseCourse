@echo off

cls
title 数据库课程上机习题解答程序
mode con cols=800 lines=600
color 03

set mysql_home=c:\program files (x86)\mysql\mysql server 5.6
set host=localhost
set port=3306
set user=root
set password=1267
set charset=gbk
set database=databasecourse

set path=%path%;%mysql_home%\bin
set executesql=mysql.exe -h%host% -p%port% -u%user% -p%password% --default-character-set=%charset% %database%

echo=数据库课程上机习题解答程序开始执行...
echo=
pause
echo=

for /f "delims=# tokens=1,2,3" %%a in (ex\ex.txt) do (

	REM %%a - 题目模板
	REM %%b - sql语句文件, 提供模板实参
	REM %%c - 答案文件

	echo=@echo off > ex_bat\%%c.bat

	for /f "delims= tokens=*" %%l in (ex\%%c) do (

		REM %%l - 行

		echo=echo=    %%l >> ex_bat\%%c.bat
	)

	for /f "usebackq delims=? tokens=1,2,3" %%i in ('%%a') do (

		REM %%i - ?分隔的语句
		REM %%j - ?分隔的语句
		REM %%k - ?分隔的语句

		for /f "usebackq tokens=1,2" %%x in (`%executesql% -N -s -e"source ex\%%b"`) do (

			REM %%x - 实参
			REM %%y - 实参

			call ex_bat\%%c.bat %%x %%y > ex_sql\%%c.sql

			echo=题目:
			echo=    %%i%%x%%j%%y%%k
			echo=
			pause > nul

			echo=sql语句:
			type ex_sql\%%c.sql
			echo=
			pause > nul

			echo=执行结果:
			%executesql% -e"source ex_sql\%%c.sql"
			echo=
			pause
			echo=
		)
	)
)

echo=数据库课程上机习题解答程序执行完毕!
echo=
pause
echo=

exit
