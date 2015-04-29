@echo off 
echo=    SELECT DISTINCT 
echo=            s.ID, s.Name 
echo=    FROM 
echo=            Supplier s 
echo=    INNER JOIN 
echo=            SupplyForm sf1 
echo=                    ON sf1.SupplierID = s.ID 
echo=    INNER JOIN 
echo=            SupplyForm sf2 
echo=                    ON sf2.SupplierID = s.ID 
echo=    WHERE 
echo=            sf1.ProjectID = 
echo=                    (SELECT ID FROM Project WHERE Name = '%1') 
echo=            AND 
echo=            sf2.ProjectID = 
echo=                    (SELECT ID FROM Project WHERE Name = '%2') 
