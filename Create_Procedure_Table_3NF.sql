-- Create table Procedure, assign IDs to unique procedures
CREATE TABLE Procedure (
    ProcedureID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProcedureName TEXT UNIQUE
);

INSERT INTO Procedure (ProcedureName)
SELECT DISTINCT "Procedure/Condition" 
FROM combined_2010_to_2023_hospital_data;

-- Add ProcedureID to main table
ALTER TABLE combined_2010_to_2023_hospital_data 
ADD COLUMN ProcedureID INTEGER;

UPDATE combined_2010_to_2023_hospital_data
SET ProcedureID = (
    SELECT ProcedureID 
    FROM Procedure 
    WHERE Procedure.ProcedureName = combined_2010_to_2023_hospital_data."Procedure/Condition"
);

-- Delete Procedure column from main table
ALTER TABLE combined_2010_to_2023_hospital_data 
DROP COLUMN "Procedure/Condition";

-- Fix Spelling for Espophagael
UPDATE Procedure SET ProcedureName = 'Esophageal Resection' WHERE ProcedureName = 'Espophageal Resection';