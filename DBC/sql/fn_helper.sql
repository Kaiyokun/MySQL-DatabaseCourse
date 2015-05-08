DELIMITER //

CREATE FUNCTION DatabaseCourse.RandStr( nLen INT ) RETURNS VARCHAR(64)
/*******************************************************************************
 *
 * Function Name: RandStr
 * Description:   ����ָ������(1~64)������ַ���,�ַ�ȡֵ��Χ(A~Z)
 * Parameter:
 *      nLen INT: ָ������ַ����ĳ���
 * Return:        ����ַ���, (nLen >= 1) && (nLen <= 64)
 *                NULL, ����
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
 * Description:   ��ȡָ���������
 * Parameter:
 *      szTable VARCHAR(64): ����
 * Return:        �������, �����
 *                NULL, ����
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
 * Description:   ת����ʱ��ʱ��Ϊ�ɶ�ʱ��
 * Parameter:
 *      picoseconds BIGINT(20) UNSIGNED: ��ʱ��ʱ��
 * Return:        �ɶ�ʱ��(YYYY-MM-DD HH:MM:SS),picoseconds IS NOT NULL
 *                NULL, ����
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
