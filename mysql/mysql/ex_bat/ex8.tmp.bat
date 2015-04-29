@echo off 
echo=    SELECT 
echo=            s.ID, s.Name, s.Tel 
echo=    FROM 
echo=            Supplier s 
echo=    INNER JOIN 
echo=            SupplyForm sf 
echo=                    ON sf.SupplierID = s.ID 
echo=    INNER JOIN 
echo=            Project p 
echo=                    ON p.ID = sf.ProjectID 
echo=    WHERE 
echo=            Year( sf.Time ) = %1 
echo=    GROUP BY 
echo=            s.ID 
echo=    HAVING 
echo=            Sum( p.Charge ) ^> %2 
