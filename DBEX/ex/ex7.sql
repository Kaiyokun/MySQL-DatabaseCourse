CALL sp_Offset( 'SupplyForm', Rand() * CountRows( 'SupplyForm' ), 'ID', @SfID );

SELECT
        p.Name
FROM
        Part p
INNER JOIN
        SupplyForm sf
                ON sf.PartID = p.ID
WHERE
        sf.ID = @SfID
;
