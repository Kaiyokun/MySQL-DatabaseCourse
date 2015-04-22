DROP DATABASE IF EXISTS DatabaseCourse;

SOURCE DBC/tbl_src.sql;

SOURCE DBC/ev_record.sql;
SOURCE DBC/sp_record.sql;

CALL DatabaseCourse.sp_CreateClientConnectionRecords;

SOURCE DBC/fn_helper.sql;
SOURCE DBC/sp_helper.sql;

SOURCE DBC/tbl_sample.sql;

CALL DatabaseCourse.sp_CreateSupplier(60);
CALL DatabaseCourse.sp_CreateProject(70);
CALL DatabaseCourse.sp_CreatePart(80);
CALL DatabaseCourse.sp_CreateSupplyForm(90);

CALL DatabaseCourse.sp_ExecuteSqlOnSql(

        'GRANT SELECT ON DatabaseCourse.[table_name] TO "[Number]"@"%" IDENTIFIED BY "[Number]"',
        'DatabaseCourse.Students, information_schema.tables WHERE table_schema = "DatabaseCourse" AND table_name IN ( "Supplier", "Project", "Part", "SupplyForm" )'
     );

SHOW DATABASES;
DO Sleep(5);

USE DatabaseCourse;

SHOW TABLE STATUS;
DO Sleep(5);

CALL DatabaseCourse.sp_ExecuteSqlOnSql(

        'SHOW FULL COLUMNS FROM DatabaseCourse.[table_name]',
        'information_schema.tables WHERE table_schema = "DatabaseCourse"'
     );
DO Sleep(5);

SHOW FUNCTION STATUS WHERE db = 'DatabaseCourse';
DO Sleep(5);

SHOW PROCEDURE STATUS WHERE db = 'DatabaseCourse';
DO Sleep(5);

SHOW EVENTS WHERE db = 'DatabaseCourse';
DO Sleep(5);
