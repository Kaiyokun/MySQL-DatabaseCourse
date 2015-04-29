CALL sp_Offset( 'Project', Rand() * CountRows( 'Project' ), 'Name', @ProjName1 );
CALL sp_Offset( 'Project', Rand() * CountRows( 'Project' ), 'Name', @ProjName2 );
SELECT Left( @ProjName1, 1 ), Right( @ProjName2, 1 );
