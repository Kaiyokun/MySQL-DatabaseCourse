DELIMITER //

CREATE FUNCTION DatabaseCourse.RandStr( nLen INT ) RETURNS VARCHAR(64)
/*******************************************************************************
 *
 * Function Name: RandStr
 * Description:   产生指定长度(1~64)的随机字符串,字符取值范围(A~Z)
 * Parameter:
 *      nLen INT: 指定随机字符串的长度
 * Return:        随机字符串, (nLen >= 1) && (nLen <= 64)
 *                NULL, 其它
 *
 ******************************************************************************/
BEGIN
        IF (nLen < 1) THEN

                RETURN NULL;
        ELSE
                SET nLen       = nLen - 1;
                SET @szRandStr = Char( Rand() * 26 + 64 );
        END IF;

        WHILE (nLen > 0) DO SET nLen = nLen - 1;

                SET @szRandStr = Concat( @szRandStr, Char( Ceil( Rand() * 26 ) + 64 ) );

        END WHILE;

        RETURN @szRandStr;
END//



CREATE FUNCTION DatabaseCourse.CountRows( szTable VARCHAR(64) ) RETURNS INT
/*******************************************************************************
 *
 * Function Name: CountRows
 * Description:   获取指定表的行数
 * Parameter:
 *      szTable VARCHAR(64): 表名
 * Return:        表的行数, 表存在
 *                NULL, 其它
 *
 ******************************************************************************/
BEGIN
        SET @szTableSchema = substring_index( szTable, '.',  1 );
        SET @szTableName   = substring_index( szTable, '.', -1 );

        IF (szTable = @szTableName) THEN

                SET @nRowCount = (

                        SELECT
                                table_rows
                        FROM
                                information_schema.tables
                        WHERE
                                table_name = szTable
                        LIMIT
                                1
                );
        ELSE
                SET @nRowCount = (

                        SELECT
                                table_rows
                        FROM
                                information_schema.tables
                        WHERE
                                table_name   = @szTableName
                                AND
                                table_schema = @szTableSchema
                        LIMIT
                                1
                );
        END IF;

        RETURN @nRowCount;
END//



CREATE FUNCTION DatabaseCourse.Timer2DateTime (
/*******************************************************************************
 *
 * Function Name: Timer2DateTime
 * Description:   转换定时器时间为可读时间
 * Parameter:
 *      picoseconds BIGINT(20) UNSIGNED: 定时器时间
 * Return:        可读时间(YYYY-MM-DD HH:MM:SS),picoseconds IS NOT NULL
 *                NULL, 其它
 *
 ******************************************************************************/

        picoseconds BIGINT(20) UNSIGNED

) RETURNS TIMESTAMP

BEGIN
        SET @tBaseTime = Now() - INTERVAL (

                SELECT
                        variable_value
                FROM
                        information_schema.global_status
                WHERE
                        variable_name = 'UPTIME'
        ) SECOND;

        RETURN @tBaseTime + INTERVAL (picoseconds * 10E-7) MICROSECOND;
END//

DELIMITER ;
