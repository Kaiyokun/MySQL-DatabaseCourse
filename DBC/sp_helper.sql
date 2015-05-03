DELIMITER //

CREATE PROCEDURE DatabaseCourse.sp_Offset (
/*******************************************************************************
 *
 * Procedure Name: sp_Offset
 * Description:    获取指定表的指定单元格内容
 * Parameter:
 *
 ******************************************************************************/
        IN  szTable   VARCHAR(64), -- 指定表
        IN  nRow      INT,         -- 指定行数
        IN  szCol     VARCHAR(64), -- 指定字段
        OUT szContent VARCHAR(64)  -- 单元格内容
)
BEGIN
        CREATE TEMPORARY TABLE IF NOT EXISTS tblCell( Cell VARCHAR(64) );
        TRUNCATE TABLE tblCell;

        SET @szStmt = Concat( ' INSERT INTO tblCell ',
                              ' SELECT ', szCol,
                              ' FROM ',   szTable,
                              ' LIMIT ',  nRow - 1, ', 1;' );

        PREPARE sqlStmt FROM @szStmt;

        EXECUTE sqlStmt;

        DEALLOCATE PREPARE sqlStmt;

        SET szContent = (SELECT * FROM tblCell);
END//



CREATE PROCEDURE DatabaseCourse.sp_ExecuteSql( IN szStmt TEXT )
/*******************************************************************************
 *
 * Procedure Name: sp_ExecuteSql
 * Description:    动态执行sql语句
 * Example:
 *      SET @szTable = 'TableName';
 *      CALL sp_ExecuteSql(
 *
 *              Concat( 'SELECT "Literal", * FROM ', @szTable )
 *           );
 * Parameter:
 *      IN szStmt TEXT: sql语句
 *
 ******************************************************************************/
BEGIN
        SET @szStmt = Replace( szStmt, '"', '''' );

        PREPARE sqlStmt FROM @szStmt;
        EXECUTE sqlStmt;

        DEALLOCATE PREPARE sqlStmt;
END//



CREATE PROCEDURE DatabaseCourse.sp_ExecuteSqlOnSql (
/*******************************************************************************
 *
 * Procedure Name: sp_ExecuteSqlOnSql
 * Description:    由sql语句生成动态sql语句并执行
 * Example:
 *      CALL sp_ExecuteSqlOnSql(
 *
 *              'SHOW FULL COLUMNS FROM SchemaName.[table_name]',
 *              'information_schema.tables WHERE table_schema = "SchemaName"'
 *           );
 * Parameter:
 *
 ******************************************************************************/
        IN szStmt TEXT, -- 动态sql语句
        IN szRef  TEXT  -- 参考表
)
BEGIN
        DECLARE i INT DEFAULT -1;

        CREATE TEMPORARY TABLE IF NOT EXISTS tblStmt( Stmt TEXT );
        TRUNCATE TABLE tblStmt;

        SET szStmt  = Replace( szStmt, '[', ''',' );
        SET szStmt  = Replace( szStmt, ']', ',''' );

        SET @szStmt = Concat( ' INSERT INTO tblStmt SELECT Concat( ''',
                                Replace( szStmt, '"', '''''' ),
                              ''' ) FROM ',
                                Replace( szRef, '"', '''' ) );

        PREPARE sqlStmt FROM @szStmt;
        EXECUTE sqlStmt;

        SET @nRec = (SELECT Count(*) FROM tblStmt) - 1;

        WHILE (i < @nRec) DO SET i = i + 1;

                SET @szStmt = (SELECT * FROM tblStmt LIMIT i, 1);

                PREPARE sqlStmt FROM @szStmt;
                EXECUTE sqlStmt;

        END WHILE;

        DEALLOCATE PREPARE sqlStmt;
END//



CREATE PROCEDURE DatabaseCourse.sp_CreateUser (
/*******************************************************************************
 *
 * Procedure Name: sp_CreateUser
 * Description:    创建mysql用户
 * Parameter:
 *
 ******************************************************************************/
        IN szUser     VARCHAR(128), -- 用户名@主机名
        IN szPassword VARCHAR(64)   -- 密码(明文)
)
LABEL: BEGIN

        SET @szUserName = substring_index( szUser, '@',  1 );
        SET @szUserHost = substring_index( szUser, '@', -1 );

        IF (szUser = @szUserName) THEN

                LEAVE LABEL;
        END IF;

        INSERT INTO
                mysql.user
        SET
                user         = @szUserName,
                host         = @szUserHost,
                password     = Password( szPassword ),
                ssl_cipher   = '',
                x509_issuer  = '',
                x509_subject = ''
        ;

        FLUSH PRIVILEGES;
END//



CREATE PROCEDURE DatabaseCourse.sp_DeleteUser (
/*******************************************************************************
 *
 * Procedure Name: sp_DeleteUser
 * Description:    删除mysql用户
 * Parameter:
 *
 ******************************************************************************/
        IN szUser VARCHAR(128) -- 用户名@主机名
)
LABEL: BEGIN

        SET @szUserName = substring_index( szUser, '@',  1 );
        SET @szUserHost = substring_index( szUser, '@', -1 );

        IF (szUser = @szUserName) THEN

                LEAVE LABEL;
        END IF;

        DELETE FROM
                mysql.user
        WHERE
                user = @szUserName
                AND
                host = @szUserHost
        ;

        FLUSH PRIVILEGES;
END//



CREATE PROCEDURE DatabaseCourse.sp_AuthTblAccess (
/*******************************************************************************
 *
 * Procedure Name: sp_AuthTblAccess
 * Description:    授权访问数据表
 * Parameter:
 *
 ******************************************************************************/
        IN szUser  VARCHAR(128),  -- 用户名@主机名
        IN szTable VARCHAR(128),  -- 数据库.表
        IN szPriv  SET( 'SELECT', -- 权限集合
                        'INSERT',
                        'UPDATE',
                        'DELETE',
                        'CREATE',
                        'DROP',
                        'GRANT',
                        'REFERENCES',
                        'INDEX',
                        'ALTER',
                        'CREATE VIEW',
                        'SHOW VIEW',
                        'TRIGGER' )
)
LABEL: BEGIN

        DECLARE CONTINUE HANDLER
                FOR SQLSTATE '23000'
        BEGIN
                UPDATE
                        mysql.tables_priv
                SET
                        table_priv = table_priv | szPriv
                WHERE
                        user       = @szUserName
                        AND
                        host       = @szUserHost
                        AND
                        db         = @szTableSchema
                        AND
                        table_name = @szTableName
                ;
        END;

        SET @szUserName    = substring_index( szUser, '@',  1 );
        SET @szUserHost    = substring_index( szUser, '@', -1 );
        SET @szTableSchema = substring_index( szTable, '.',  1 );
        SET @szTableName   = substring_index( szTable, '.', -1 );

        IF (szUser = @szUserName || szTable = @szTableName) THEN

                LEAVE LABEL;
        END IF;

        INSERT INTO
                mysql.tables_priv
        SET
                user       = @szUserName,
                host       = @szUserHost,
                db         = @szTableSchema,
                table_name = @szTableName,
                table_priv = szPriv
        ;

        FLUSH PRIVILEGES;
END//



CREATE PROCEDURE DatabaseCourse.sp_UnauthTblAccess (
/*******************************************************************************
 *
 * Procedure Name: sp_UnauthTblAccess
 * Description:    反授权访问数据表
 * Parameter:
 *
 ******************************************************************************/
        IN szUser  VARCHAR(128),  -- 用户名@主机名
        IN szTable VARCHAR(128),  -- 数据库.表
        IN szPriv  SET( 'SELECT', -- 权限集合
                        'INSERT',
                        'UPDATE',
                        'DELETE',
                        'CREATE',
                        'DROP',
                        'GRANT',
                        'REFERENCES',
                        'INDEX',
                        'ALTER',
                        'CREATE VIEW',
                        'SHOW VIEW',
                        'TRIGGER' )
)
LABEL: BEGIN

        SET @szUserName    = substring_index( szUser, '@',  1 );
        SET @szUserHost    = substring_index( szUser, '@', -1 );
        SET @szTableSchema = substring_index( szTable, '.',  1 );
        SET @szTableName   = substring_index( szTable, '.', -1 );

        IF (szUser = @szUserName || szTable = @szTableName) THEN

                LEAVE LABEL;
        END IF;

        UPDATE
                mysql.tables_priv
        SET
                table_priv = table_priv & (~szPriv)
        WHERE
                user       = @szUserName
                AND
                host       = @szUserHost
                AND
                db         = @szTableSchema
                AND
                table_name = @szTableName
        ;

        FLUSH PRIVILEGES;
END//



CREATE PROCEDURE DatabaseCourse.sp_ShowOperationRecords (
/*******************************************************************************
 *
 * Procedure Name: sp_ShowOperationRecords
 * Description:    获取调用者的上机记录
 * Parameter:
 *
 ******************************************************************************/
        IN StartTime TIMESTAMP, -- 开始时间
        IN EndTime   TIMESTAMP  -- 结束时间
)
BEGIN
        SET @ID = 0;

        SELECT
                @ID := @ID + 1           AS '',
                pseshl.event_id          AS '操作ID',
                pseshl.event_name        AS '操作',
                pseshl.sql_text          AS 'SQL语句',
                pseshl.digest_text       AS '格式化SQL语句',

                DatabaseCourse.Timer2DateTime( pseshl.timer_start )
                                         AS '开始时间',

                Format( pseshl.timer_wait, 0 )
                                         AS '运行时间(皮秒)',

                pseshl.current_schema    AS '数据库',
                pseshl.mysql_errno       AS '提示ID',
                pseshl.message_text      AS '提示消息',
                pseshl.returned_sqlstate AS 'SQL返回状态',
                pseshl.errors            AS '错误',
                pseshl.warnings          AS '警告'
        FROM
                DatabaseCourse.ClientConnectionRecords dbcccr
        INNER JOIN
                performance_schema.events_statements_history_long pseshl
                        ON pseshl.thread_id = dbcccr.ThreadID
        WHERE
                dbcccr.ConnTime >= StartTime
                AND
                dbcccr.ConnTime <  EndTime
                AND
                dbcccr.user = substring_index( session_user(), '@',  1 )
        ;
END//

DELIMITER ;
