DELIMITER //

CREATE PROCEDURE DatabaseCourse.sp_CreateClientConnectionRecords()
/*******************************************************************************
 *
 * Procedure Name: sp_CreateClientConnectionRecords
 * Description:    初始化上机操作记录
 * Parameter:      NULL
 *
 ******************************************************************************/
BEGIN
        SET GLOBAL event_scheduler = 'on';

        UPDATE
                performance_schema.setup_consumers
        SET
                enabled = 'yes'
        WHERE
                name IN (

                        'global_instrumentation',
                        'thread_instrumentation',
                        'statements_digest',
                        'events_statements_history_long'
                );

        UPDATE
                performance_schema.setup_instruments
        SET
                enabled = 'no', timed = 'no';

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
 * Description:    获取上机记录
 * Parameter:
 *
 ******************************************************************************/
        IN StartTime TIMESTAMP, -- 开始时间
        IN EndTime   TIMESTAMP  -- 结束时间
)
BEGIN
        SELECT
                dbcc.name                AS '班级',
                dbcs.name                AS '姓名',
                dbcs.number              AS '学号',
                dbcccr.host              AS '主机IP',
                dbcccr.conntime          AS '上机时间',
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
 * Description:    获取缺勤记录
 * Parameter:
 *
 ******************************************************************************/
        IN StartTime TIMESTAMP, -- 开始时间
        IN EndTime   TIMESTAMP  -- 结束时间
)
BEGIN
        SET @ID = 0;

        SELECT
                @ID := @ID + 1 AS '', subset.*
        FROM (
                SELECT
                        dbcc.name   AS '班级',
                        dbcs.name   AS '姓名',
                        dbcs.number AS '学号'
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



CREATE PROCEDURE DatabaseCourse.sp_ShowOnlineUsers()
/*******************************************************************************
 *
 * Procedure Name: sp_ShowOnlineUsers
 * Description:    获取当前在线用户列表
 * Parameter:      NULL
 *
 ******************************************************************************/
BEGIN
        SET @ID = 0;

        SELECT
                @ID := @ID + 1 AS '', subset.*
        FROM (
                SELECT DISTINCT
                        dbcc.name   AS '班级',
                        dbcs.name   AS '姓名',
                        dbcs.number AS '学号',
                        Now()       AS '当前时间'
                FROM
                        DatabaseCourse.Students dbcs
                INNER JOIN
                        DatabaseCourse.Classes dbcc
                                ON dbcc.ID = dbcs.ClassID
                INNER JOIN
                        performance_schema.threads pst
                                ON pst.processlist_user = dbcs.number
                WHERE
                        pst.name = 'thread/sql/one_connection'
                ORDER BY
                        dbcc.ID     ASC,
                        dbcs.Number ASC
        ) subset;
END//

DELIMITER ;
