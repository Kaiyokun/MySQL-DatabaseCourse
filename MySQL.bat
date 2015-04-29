@ECHO	off

MODE con cols=800 lines=600

COLOR	03

SET	mysql_home=C:\Program Files (x86)\MySQL\MySQL Server 5.6
SET	path=%path%;%mysql_home%\bin
SET	ip=localhost
SET	port=3306
SET	user=root
SET	password=1267
SET	database=DatabaseCourse

IF	defined password	(

	SET	password=-p%password%
)

IF	not [%1] == []	(

	SET	executesql=-e"SOURCE %1"
)

mysql.exe	--default-character-set=gbk -h%ip% -P%port% -u%user% %password% %database% %executesql%

PAUSE

EXIT
