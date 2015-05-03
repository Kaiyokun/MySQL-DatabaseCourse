CALL sp_Offset( 'SupplyForm', Rand() * CountRows( 'SupplyForm' ), 'ID', @SfID );

SELECT
        p.Name, '2007-01-01'
FROM
        Project p
INNER JOIN
        SupplyForm sf
                ON sf.ProjectID = p.ID
WHERE
        sf.ID = @SfID
;
