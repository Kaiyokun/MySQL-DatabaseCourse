@echo off 
echo=    SELECT 
echo=            s.Name, s.City, s.Tel 
echo=    FROM 
echo=            Supplier s 
echo=    INNER JOIN 
echo=            SupplyForm sf 
echo=                    ON sf.SupplierID = s.ID 
echo=    INNER JOIN 
echo=            Part p 
echo=                    ON p.ID = sf.PartID 
echo=    WHERE 
echo=            p.Name = '%1' 
