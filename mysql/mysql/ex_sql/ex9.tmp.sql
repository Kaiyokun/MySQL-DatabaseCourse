    SELECT 
            p.* 
    FROM 
            Part p 
    INNER JOIN 
            SupplyForm sf 
                    ON sf.PartID = p.ID 
    INNER JOIN 
            Project proj 
                    ON proj.ID = sf.ProjectID 
    WHERE 
            proj.Name = '2014_89ºÅ' AND sf.Time > '2007-01-01' 
