@echo off 
echo=    SELECT 
echo=            p.* 
echo=    FROM 
echo=            Part p 
echo=    INNER JOIN 
echo=            SupplyForm sf 
echo=                    ON sf.PartID = p.ID 
echo=    INNER JOIN 
echo=            Project proj 
echo=                    ON proj.ID = sf.ProjectID 
echo=    WHERE 
echo=            proj.Name = '%1' AND sf.Time ^> '%2' 
