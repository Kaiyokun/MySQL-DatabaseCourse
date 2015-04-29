DROP PROCEDURE IF EXISTS DatabaseCourse.sp_CountSupplierAmountByCity;

DELIMITER //

CREATE PROCEDURE DatabaseCourse.sp_CountSupplierAmountByCity (
/*******************************************************************************
 *
 * Procedure Name: sp_CountSupplierAmountByCity
 * Description:    ������ͳ�Ʒ��Ϲ�Ӧ��������������Ĺ�Ӧ����Ŀ
 * Example:        CALL DatabaseCourse.sp_CountSupplierAmountByCity ( 2000, 8000 );
 * Parameter:
 *
 ******************************************************************************/
        IN nLowerEndPoint INT, -- ������˵�
        IN nUpperEndPoint INT  -- �����Ҷ˵�
)
BEGIN
        DROP TABLE IF EXISTS tblSuppInfo;

        CREATE TABLE
                tblSuppInfo
        SELECT
                s.City             AS 'City',
                s.ID               AS 'ID',
                Sum( sf.Quantity ) AS 'Quantity'
        FROM
                DatabaseCourse.Supplier s
        INNER JOIN
                DatabaseCourse.SupplyForm sf
                        ON sf.SupplierID = s.ID
        GROUP BY
                s.City, s.ID
        ;

        SELECT
                '����'                                                     AS '',
                Concat( '������ < ', nLowerEndPoint )                      AS '',
                Concat( nLowerEndPoint, ' <= ������ <= ', nUpperEndPoint ) AS '',
                Concat( '������ > ', nUpperEndPoint )                      AS ''
        UNION

        SELECT
                '', '', '', ''
        UNION

        SELECT
                si.City,
                IfNull( lp.SuppAmt, 0 ),
                IfNull( mp.SuppAmt, 0 ),
                IfNull( up.SuppAmt, 0 )
        FROM
                (SELECT DISTINCT City FROM tblSuppInfo) si

        LEFT JOIN (

                SELECT
                        City, Count( ID ) AS 'SuppAmt'
                FROM
                        tblSuppInfo
                WHERE
                        Quantity < nLowerEndPoint
                GROUP BY
                        City

                ) lp ON lp.City = si.City

        LEFT JOIN (

                SELECT
                        City, Count( ID ) AS 'SuppAmt'
                FROM
                        tblSuppInfo
                WHERE
                        Quantity >= nLowerEndPoint AND Quantity <= nUpperEndPoint
                GROUP BY
                        City

                ) mp ON mp.City = si.City

        LEFT JOIN (

                SELECT
                        City, Count( ID ) AS 'SuppAmt'
                FROM
                        tblSuppInfo
                WHERE
                        Quantity > nUpperEndPoint
                GROUP BY
                        City

                ) up ON up.City = si.City
        ;
END//

DELIMITER ;

CALL DatabaseCourse.sp_CountSupplierAmountByCity( 2000, 8000 );
