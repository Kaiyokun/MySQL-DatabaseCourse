DELIMITER //

CREATE PROCEDURE DatabaseCourse.sp_CreateSupplier( IN nRec INT )
/*******************************************************************************
 *
 * Procedure Name: sp_CreateSupplier
 * Description:    创建供应商表(Supplier)
 * Parameter:
 *      IN nRec INT: 记录数
 *
 ******************************************************************************/
BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET nRec = nRec + 1;

        CREATE TEMPORARY TABLE IF NOT EXISTS tblCredit (

                ID   INT PRIMARY KEY AUTO_INCREMENT,
                Name ENUM( '优', '良', '中', '差' ) NOT NULL

        ); TRUNCATE TABLE tblCredit;

        INSERT INTO tblCredit( Name ) VALUES( '优' ), ( '良' ), ( '中' ), ( '差' );

        CREATE TABLE IF NOT EXISTS DatabaseCourse.Supplier (

                ID     INT         PRIMARY KEY        AUTO_INCREMENT,
                Name   VARCHAR(16) UNIQUE             NOT NULL,
                City   VARCHAR(16)                    NOT NULL,
                Tel    VARCHAR(16)                    NOT NULL,
                Credit ENUM( '优', '良', '中', '差' ) NOT NULL
        );

        SET @cName   = DatabaseCourse.CountRows( 'DatabaseCourse.Students' );
        SET @cCity   = 24;
        SET @cCredit = (SELECT Count(*) FROM tblCredit);

        WHILE (nRec > 0) DO SET nRec = nRec - 1;

                CALL DatabaseCourse.sp_Offset( 'DatabaseCourse.Students',
                                                Ceil( Rand() * @cName ),
                                               'Name',
                                                @szName );
                CALL DatabaseCourse.sp_Offset( 'DatabaseCourse.Citys',
                                                Ceil( Rand() * @cCity ),
                                               'Name',
                                                @szCity );
                CALL DatabaseCourse.sp_Offset( 'tblCredit',
                                                Ceil( Rand() * @cCredit ),
                                               'Name',
                                                @szCredit );
                SET @szTel = Concat( '1', Mid( Rand(), 3, 10 ) );

                INSERT INTO DatabaseCourse.Supplier( Name, City, Credit, Tel )
                VALUES( @szName, @szCity, @szCredit, @szTel );

        END WHILE;
END//



CREATE PROCEDURE DatabaseCourse.sp_CreateProject( IN nRec INT )
/*******************************************************************************
 *
 * Procedure Name: sp_CreateProject
 * Description:    创建工程表(Project)
 * Parameter:
 *      IN nRec INT: 记录数
 *
 ******************************************************************************/
BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET nRec = nRec + 1;

        CREATE TABLE IF NOT EXISTS DatabaseCourse.Project (

                ID      INT         PRIMARY KEY AUTO_INCREMENT,
                Name    VARCHAR(16) UNIQUE      NOT NULL,
                Manager VARCHAR(16)             NOT NULL,
                Charge  DECIMAL(10,2)           NOT NULL
        );

        SET @cManager = DatabaseCourse.CountRows( 'DatabaseCourse.Students' );

        WHILE (nRec > 0) DO SET nRec = nRec - 1;

                SET @choose = Ceil( Rand() * 2 );

                IF (@choose = 1) THEN

                        SET @szName = Concat( DatabaseCourse.RandStr(2),
                                             '_',
                                              DatabaseCourse.RandStr(4) );
                ELSE
                        SET @szName = Concat( 2000 + Ceil( Rand() * 15 ),
                                             '_',
                                              Ceil( Rand() * 100 ),
                                             '号' );
                END IF;

                CALL DatabaseCourse.sp_Offset( 'DatabaseCourse.Students',
                                                Ceil( Rand() * @cManager ),
                                               'Name',
                                                @szManager );
                SET @decCharge = Round( Rand() * 2000, 2 );

                INSERT INTO DatabaseCourse.Project( Name, Manager, Charge )
                VALUES( @szName, @szManager, @decCharge );

        END WHILE;
END//



CREATE PROCEDURE DatabaseCourse.sp_CreatePart( IN nRec INT )
/*******************************************************************************
 *
 * Procedure Name: sp_CreatePart
 * Description:    创建零件表(Part)
 * Parameter:
 *      IN nRec INT: 记录数
 *
 ******************************************************************************/
BEGIN
        CREATE TABLE IF NOT EXISTS DatabaseCourse.Part (

                ID       INT PRIMARY KEY AUTO_INCREMENT ,
                Name     VARCHAR(16)     NOT NULL,
                BatchNbr VARCHAR(16)     NOT NULL
        );

        WHILE (nRec > 0) DO SET nRec = nRec - 1;

                SET @szName     = Concat( 'P', Ceil( Rand() * 100 ) );
                SET @szBatchNbr = Concat( 'BN', Mid( Rand(), 3, 10 ) );

                INSERT INTO DatabaseCourse.Part( Name, BatchNbr )
                VALUES( @szName, @szBatchNbr );

        END WHILE;
END//



CREATE PROCEDURE DatabaseCourse.sp_CreateSupplyForm( IN nRec INT )
/*******************************************************************************
 *
 * Procedure Name: sp_CreateSupplyForm
 * Description:    创建供应表(SupplyForm)
 * Parameter:
 *      IN nRec INT: 记录数
 *
 ******************************************************************************/
BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET nRec = nRec + 1;

        CREATE TABLE IF NOT EXISTS DatabaseCourse.SupplyForm (

                ID         INT PRIMARY KEY AUTO_INCREMENT,
                SupplierID INT             NOT NULL,
                ProjectID  INT             NOT NULL,
                PartID     INT             NOT NULL,
                Quantity   INT             NOT NULL,
                Time       DATE            NOT NULL,

                CONSTRAINT FOREIGN KEY ( SupplierID )
                        REFERENCES DatabaseCourse.Supplier( ID ),
                CONSTRAINT FOREIGN KEY ( ProjectID )
                        REFERENCES DatabaseCourse.Project( ID ),
                CONSTRAINT FOREIGN KEY ( PartID )
                        REFERENCES DatabaseCourse.Part( ID )
        );

        SET @cSupplier = DatabaseCourse.CountRows( 'DatabaseCourse.Supplier' );
        SET @cProject  = DatabaseCourse.CountRows( 'DatabaseCourse.Project' );
        SET @cPart     = DatabaseCourse.CountRows( 'DatabaseCourse.Part' );

        WHILE (nRec > 0) DO SET nRec = nRec - 1;

                SET @nSupplierID = Ceil( Rand() * @cSupplier );
                SET @nProjectID  = Ceil( Rand() * @cProject );
                SET @nPartID     = Ceil( Rand() * @cPart );
                SET @nQuantity   = Ceil( Rand() * 800 );
                SET @tTime       = SubDate( '2015-04-01', Ceil( Rand() * 3210 ) );

                INSERT INTO DatabaseCourse.SupplyForm( SupplierID,
                                                       ProjectID,
                                                       PartID,
                                                       Quantity,
                                                       Time )
                VALUES( @nSupplierID, @nProjectID, @nPartID, @nQuantity, @tTime );

        END WHILE;
END//

DELIMITER ;
