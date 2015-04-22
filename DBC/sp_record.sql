DELIMITER //

CREATE PROCEDURE DatabaseCourse.sp_CreateClientConnectionRecords()
/*******************************************************************************
 *
 * Procedure Name: sp_CreateClientConnectionRecords
 * Description:    ��ʼ���ϻ�������¼
 * Parameter:      NULL
 *
 ******************************************************************************/
BEGIN
        SET GLOBAL event_scheduler = 'ON';

        -- performance_schema.setup_*s

        UPDATE
                performance_schema.setup_consumers
        SET
                enabled = 'yes'
        WHERE
                name IN (

                        'global_instrumentation',
                        'thread_instrumentation',
                        'events_statements_history_long'
                );

        UPDATE
                performance_schema.setup_instruments
        SET
                enabled = 'yes', timed = 'yes'
        WHERE
                name LIKE 'statements/%';

        CREATE TABLE IF NOT EXISTS
                DatabaseCourse.ClientConnectionRecords (

                        ID       BIGINT(20) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
                        ThreadID BIGINT(20) UNSIGNED UNIQUE      NOT NULL,
                        User     VARCHAR(64)                     NOT NULL,
                        Host     VARCHAR(64)                     NOT NULL,
                        ConnTime TIMESTAMP  DEFAULT CURRENT_TIMESTAMP
                );

        ALTER EVENT DatabaseCourse.ev_ClientConnect ENABLE;
END//



CREATE PROCEDURE DatabaseCourse.sp_ShowClientOperationRecords (
/*******************************************************************************
 *
 * Procedure Name: sp_ShowClientOperationRecords
 * Description:    ��ȡ�ϻ���¼
 * Parameter:
 *
 ******************************************************************************/
        IN StartTime TIMESTAMP, -- ��ʼʱ��
        IN EndTime   TIMESTAMP  -- ����ʱ��
)
BEGIN
        SELECT
                dbcc.name                AS '�༶',
                dbcs.name                AS '����',
                dbcs.number              AS 'ѧ��',
                dbcccr.host              AS '����IP',
                dbcccr.conntime          AS '�ϻ�ʱ��',
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
        INNER JOIN
                DatabaseCourse.Students dbcs
                        ON dbcs.Number = dbcccr.User
        INNER JOIN
                DatabaseCourse.Classes dbcc
                        ON dbcc.ID = dbcs.ClassID
        WHERE
                dbcccr.ConnTime >= StartTime
                AND
                dbcccr.ConnTime <  EndTime
        ORDER BY
                dbcc.ID         ASC,
                dbcs.Number     ASC,
                dbcccr.ConnTime ASC
        ;
END//



CREATE PROCEDURE DatabaseCourse.sp_ShowAbsenceRecords (
/*******************************************************************************
 *
 * Procedure Name: sp_ShowAbsenceRecords
 * Description:    ��ȡȱ�ڼ�¼
 * Parameter:
 *
 ******************************************************************************/
        IN StartTime TIMESTAMP, -- ��ʼʱ��
        IN EndTime   TIMESTAMP  -- ����ʱ��
)
BEGIN
        SET @ID = 0;

        SELECT
                @ID := @ID + 1 AS '', subset.*
        FROM (
                SELECT
                        dbcc.name   AS '�༶',
                        dbcs.name   AS '����',
                        dbcs.number AS 'ѧ��'
                FROM
                        DatabaseCourse.Students dbcs
                INNER JOIN
                        DatabaseCourse.Classes dbcc
                                ON dbcc.ID = dbcs.ClassID
                WHERE
                        dbcs.Number NOT IN (

                                SELECT
                                        User
                                FROM
                                        DatabaseCourse.ClientConnectionRecords
                                WHERE
                                        ConnTime >= StartTime
                                        AND
                                        ConnTime <  EndTime
                        )
                ORDER BY
                        dbcc.ID     ASC,
                        dbcs.Number ASC
        ) subset;
END//

DELIMITER ;