SELECT
        p1.Name, p2.Name
FROM
        SupplyForm sf1
INNER JOIN
        SupplyForm sf2
                ON sf2.SupplierID = sf1.SupplierID
INNER JOIN
        Project p1
                ON p1.ID = sf1.ProjectID
INNER JOIN
        Project p2
                ON p2.ID = sf2.ProjectID
WHERE
        sf1.ProjectID <> sf2.ProjectID
LIMIT
        1
;
