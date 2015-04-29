DROP VIEW IF EXISTS DatabaseCourse.view_SuppInfo;

CREATE VIEW DatabaseCourse.view_SuppInfo
        AS
SELECT
        *
FROM
        DatabaseCourse.Supplier
WHERE
        City
                IN ( '北京市', '上海市', '天津市' )
;

SELECT * FROM DatabaseCourse.view_SuppInfo;
