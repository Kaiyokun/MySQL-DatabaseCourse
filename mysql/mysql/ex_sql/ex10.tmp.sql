    SELECT DISTINCT 
            s.ID, s.Name 
    FROM 
            Supplier s 
    INNER JOIN 
            SupplyForm sf1 
                    ON sf1.SupplierID = s.ID 
    INNER JOIN 
            SupplyForm sf2 
                    ON sf2.SupplierID = s.ID 
    WHERE 
            sf1.ProjectID = 
                    (SELECT ID FROM Project WHERE Name = '2001_45��') 
            AND 
            sf2.ProjectID = 
                    (SELECT ID FROM Project WHERE Name = 'HJ_VEIC') 
