DROP VIEW IF EXISTS DatabaseCourse.view_SuppInfo;

CREATE VIEW DatabaseCourse.view_SuppInfo
        AS
SELECT
        *
FROM
        DatabaseCourse.Supplier
WHERE
        City
                IN ( '������', '�Ϻ���', '�����' )
;

SELECT * FROM DatabaseCourse.view_SuppInfo;
