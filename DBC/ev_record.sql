DELIMITER //

CREATE EVENT IF NOT EXISTS
/*******************************************************************************
 *
 * 创建客户端连接监听事件，轮询周期：2s
 *
 ******************************************************************************/
        DatabaseCourse.ev_ClientConnect
ON SCHEDULE
        EVERY 2 SECOND
DISABLE
        COMMENT 'Monitor client connection, polling cycle time: 2s'
DO
        BEGIN
                INSERT INTO
                        DatabaseCourse.ClientConnectionRecords (

                                ThreadID,
                                User,
                                Host
                        )
                SELECT
                        pst.thread_id,
                        pst.processlist_user,
                        pst.processlist_host
                FROM
                        performance_schema.threads pst
                WHERE
                        pst.name = 'thread/sql/one_connection'
                        AND
                        pst.thread_id NOT IN (

                                SELECT
                                        dcccr.ThreadID
                                FROM
                                        DatabaseCourse.ClientConnectionRecords dcccr
                        )
                ;
        END//

DELIMITER ;
