SELECT
        s1.City, s2.City, s3.City
FROM
        Supplier s1, Supplier s2, Supplier s3
WHERE
        s1.City <> s2.City
        AND
        s2.City <> s3.City
        AND
        s3.City <> s1.City
LIMIT
        1
;
