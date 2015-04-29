    SELECT 
            s.Name, s.City, s.Tel 
    FROM 
            Supplier s 
    INNER JOIN 
            SupplyForm sf 
                    ON sf.SupplierID = s.ID 
    INNER JOIN 
            Part p 
                    ON p.ID = sf.PartID 
    WHERE 
            p.Name = 'P901' 
