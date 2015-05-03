    SELECT 
            s.ID, s.Name, s.Tel 
    FROM 
            Supplier s 
    INNER JOIN 
            SupplyForm sf 
                    ON sf.SupplierID = s.ID 
    INNER JOIN 
            Project p 
                    ON p.ID = sf.ProjectID 
    WHERE 
            Year( sf.Time ) = 2008 
    GROUP BY 
            s.ID 
    HAVING 
            Sum( p.Charge ) > 1000 