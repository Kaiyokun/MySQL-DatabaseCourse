DELIMITER //
/*
CREATE TRIGGER DatabaseCourse.tr_BeforeInsertStudents
\*******************************************************************************
 *
 * 创建学生用户触发，将其添加到mysql用户列表
 *
 ******************************************************************************\
        BEFORE INSERT
ON DatabaseCourse.Students
        FOR EACH ROW
BEGIN
        SET @szUser = Concat( NEW.Number, '@%' );

        CALL DatabaseCourse.sp_CreateUser( @szUser, NEW.Number );

        CALL DatabaseCourse.sp_AuthTblAccess( @szUser,
                                             'DatabaseCourse.Supplier',
                                             'SELECT' );
        CALL DatabaseCourse.sp_AuthTblAccess( @szUser,
                                             'DatabaseCourse.Project',
                                             'SELECT' );
        CALL DatabaseCourse.sp_AuthTblAccess( @szUser,
                                             'DatabaseCourse.Part',
                                             'SELECT' );
        CALL DatabaseCourse.sp_AuthTblAccess( @szUser,
                                             'DatabaseCourse.SupplyForm',
                                             'SELECT' );
END//
*/
DELIMITER ;
