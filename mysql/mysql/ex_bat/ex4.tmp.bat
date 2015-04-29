@echo off 
echo=    SELECT 
echo=            Manager, Name, Charge 
echo=    FROM 
echo=            Project 
echo=    WHERE 
echo=            Charge ^> %1 
echo=    ORDER BY 
echo=            Charge DESC 
