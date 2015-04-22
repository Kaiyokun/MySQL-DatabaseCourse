DELIMITER //

CREATE PROCEDURE DatabaseCourse.sp_Offset (
/*******************************************************************************
 *
 * Procedure Name: sp_Offset
 * Description:    ��ȡָ�����ָ����Ԫ������
 * Parameter:
 *
 ******************************************************************************/
        IN  szTable   VARCHAR(64), -- ָ����
        IN  nRow      INT,         -- ָ������
        IN  szCol     VARCHAR(64), -- ָ���ֶ�
        OUT szContent VARCHAR(64)  -- ��Ԫ������
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
 * Description:    ��ִ̬��sql���
 * Example:
 *      SET @szTable = 'TableName';
 *      CALL sp_ExecuteSql(
 *
 *              Concat( 'SELECT "Literal", * FROM ', @szTable )
 *           );
 * Parameter:
 *      IN szStmt TEXT: sql���
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
 * Description:    ��sql������ɶ�̬sql��䲢ִ��
 * Example:
 *      CALL sp_ExecuteSqlOnSql(
 *
 *              'SHOW FULL COLUMNS FROM SchemaName.[table_name]',
 *              'information_schema.tables WHERE table_schema = "SchemaName"'
 *           );
 * Parameter:
 *
 ******************************************************************************/
        IN szStmt TEXT, -- ��̬sql���
        IN szRef  TEXT  -- �ο���
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
 * Description:    ����mysql�û�
 * Parameter:
 *
 ******************************************************************************/
        IN szUser     VARCHAR(128), -- �û���@������
        IN szPassword VARCHAR(64)   -- ����(����)
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
 * Description:    ɾ��mysql�û�
 * Parameter:
 *
 ******************************************************************************/
        IN szUser VARCHAR(128) -- �û���@������
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
 * Description:    ��Ȩ�������ݱ�
 * Parameter:
 *
 ******************************************************************************/
        IN szUser  VARCHAR(128),  -- �û���@������
        IN szTable VARCHAR(128),  -- ���ݿ�.��
        IN szPriv  SET( 'SELECT', -- Ȩ�޼���
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
 * Description:    ����Ȩ�������ݱ�
 * Parameter:
 *
 ******************************************************************************/
        IN szUser  VARCHAR(128),  -- �û���@������
        IN szTable VARCHAR(128),  -- ���ݿ�.��
        IN szPriv  SET( 'SELECT', -- Ȩ�޼���
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
 * Description:    ��ȡ�����ߵ��ϻ���¼
 * Parameter:
 *
 ******************************************************************************/
        IN StartTime TIMESTAMP, -- ��ʼʱ��
        IN EndTime   TIMESTAMP  -- ����ʱ��
)
BEGIN
        SET @ID = 0;

        SELECT
                @ID := @ID + 1           AS '',
                pseshl.event_name        AS '����',
                pseshl.sql_text          AS 'SQL���',

                DatabaseCourse.Timer2DateTime( pseshl.timer_start )
                                         AS '��ʼʱ��',

                Format( pseshl.timer_wait, 0 )
                                         AS '����ʱ��(Ƥ��)',

                pseshl.current_schema    AS '���ݿ�',
                pseshl.returned_sqlstate AS 'SQL״̬',
                pseshl.message_text      AS '��ʾ��Ϣ',
                pseshl.errors            AS '����',
                pseshl.warnings          AS '����'
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
/*
CREATE PROCEDURE DatabaseCourse.sp_AlterUser (
\*******************************************************************************
 *
 * Procedure Name: sp_AlterUser
 * Description:    �޸�mysql�û�
 * Parameter:
 *
 ******************************************************************************\
        IN szUserOld VARCHAR(128), -- ԭ�û���@������
        IN szUserNew VARCHAR(128)  -- ���û���[@������]
)
LABEL: BEGIN

        SET @szUserNameOld = substring_index( szUserOld, '@',  1 );
        SET @szUserHostOld = substring_index( szUserOld, '@', -1 );

        IF (szUserOld = @szUserNameOld) THEN

                LEAVE LABEL;
        END IF;

        SET @szUserNameNew = substring_index( szUserNew, '@',  1 );
        SET @szUserHostNew = substring_index( szUserNew, '@', -1 );

        IF (szUserNew = @szUserNameNew) THEN

                UPDATE
                        mysql.user
                SET
                        user = szUserNew
                WHERE
                        user = @szUserNameOld
                        AND
                        host = @szUserHostOld
                ;
        ELSE
                UPDATE
                        mysql.user
                SET
                        user = @szUserNameNew,
                        host = @szUserHostNew
                WHERE
                        user = @szUserNameOld
                        AND
                        host = @szUserHostOld
                ;
        END IF;

        FLUSH PRIVILEGES;
END//
*/

DELIMITER ;
