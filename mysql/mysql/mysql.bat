@echo off

cls
title ���ݿ�γ��ϻ�ϰ�������
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

echo=���ݿ�γ��ϻ�ϰ�������ʼִ��...
echo=
pause
echo=

for /f "delims=# tokens=1,2,3" %%a in (ex\ex.txt) do (

	REM %%a - ��Ŀģ��
	REM %%b - sql����ļ�, �ṩģ��ʵ��
	REM %%c - ���ļ�

	echo=@echo off > ex_bat\%%c.bat

	for /f "delims= tokens=*" %%l in (ex\%%c) do (

		REM %%l - ��

		echo=echo=    %%l >> ex_bat\%%c.bat
	)

	for /f "usebackq delims=? tokens=1,2,3" %%i in ('%%a') do (

		REM %%i - ?�ָ������
		REM %%j - ?�ָ������
		REM %%k - ?�ָ������

		for /f "usebackq tokens=1,2" %%x in (`%executesql% -N -s -e"source ex\%%b"`) do (

			REM %%x - ʵ��
			REM %%y - ʵ��

			call ex_bat\%%c.bat %%x %%y > ex_sql\%%c.sql

			echo=��Ŀ:
			echo=    %%i%%x%%j%%y%%k
			echo=
			pause > nul

			echo=sql���:
			type ex_sql\%%c.sql
			echo=
			pause > nul

			echo=ִ�н��:
			%executesql% -e"source ex_sql\%%c.sql"
			echo=
			pause
			echo=
		)
	)
)

echo=���ݿ�γ��ϻ�ϰ�������ִ�����!
echo=
pause
echo=

exit
