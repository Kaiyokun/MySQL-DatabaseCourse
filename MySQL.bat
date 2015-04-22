@ECHO	off

MODE CON cols=800 lines=600

COLOR	03

SET	mysql_home=C:\Program Files (x86)\MySQL\MySQL Server 5.6
SET	path=%path%;%mysql_home%\bin
SET	ip=localhost
SET	port=3306
SET	user=2013750123
SET	password=123
SET	database=DatabaseCourse

IF	defined password	(

	SET	password=-p%password%
)

mysql.exe	--default-character-set=gbk -h%ip% -P%port% -u%user% %password% %database%
