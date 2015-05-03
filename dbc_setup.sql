DROP DATABASE IF EXISTS DatabaseCourse;

SOURCE dbc/tbl_src.sql;

SOURCE dbc/ev_record.sql;
SOURCE dbc/sp_record.sql;

CALL DatabaseCourse.sp_CreateClientConnectionRecords;

SOURCE dbc/fn_helper.sql;
SOURCE dbc/sp_helper.sql;

SOURCE dbc/tbl_sample.sql;

CALL DatabaseCourse.sp_CreateSupplier(50);
CALL DatabaseCourse.sp_CreateProject(50);
CALL DatabaseCourse.sp_CreatePart(300);
CALL DatabaseCourse.sp_CreateSupplyForm(1000);

CALL DatabaseCourse.sp_ExecuteSqlOnSql(

        'GRANT SELECT ON DatabaseCourse.[table_name] TO "[Number]"@"%" IDENTIFIED BY "[Number]"',
        'DatabaseCourse.Students, information_schema.tables WHERE table_schema = "DatabaseCourse" AND table_name IN ( "Supplier", "Project", "Part", "SupplyForm" )'
     );

CALL DatabaseCourse.sp_ExecuteSqlOnSql(

        'GRANT EXECUTE ON PROCEDURE DatabaseCourse.sp_ShowOperationRecords TO "[Number]"@"%"',
        'DatabaseCourse.Students'
     );

GRANT ALL ON DatabaseCourse.* TO 'proxy'@'%' IDENTIFIED BY 'proxy';

USE DatabaseCourse;

SHOW DATABASES;
DO Sleep(3);

SHOW TABLE STATUS;
DO Sleep(3);

CALL DatabaseCourse.sp_ExecuteSqlOnSql(

        'SHOW FULL COLUMNS FROM DatabaseCourse.[table_name]',
        'information_schema.tables WHERE table_schema = "DatabaseCourse"'
     );
DO Sleep(3);

SHOW FUNCTION STATUS WHERE db = 'DatabaseCourse';
DO Sleep(3);

SHOW PROCEDURE STATUS WHERE db = 'DatabaseCourse';
DO Sleep(3);

SHOW EVENTS WHERE db = 'DatabaseCourse';
