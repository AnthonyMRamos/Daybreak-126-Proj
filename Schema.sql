-- Schema.sql 
-- Table stucture, normalization, and constraints

-- 1: Split combinedHospitalInfo out of combined_2010_to_2023_hospital_data
-- Creates hospital lookup table

CREATE TABLE combinedHospitalInfo(
HOSPITAL TEXT,
OSHPDID TEXT,
LONGITUDE TEXT,
LATITUDE TEXT
);

INSERT INTO combinedHospitalInfo 
SELECT HOSPITAL, OSHPDID, LONGITUDE, LATITUDE
FROM combined_2010_to_2023_hospital_data;

ALTER TABLE combined_2010_to_2023_hospital_data DROP COLUMN HOSPITAL;
ALTER TABLE combined_2010_to_2023_hospital_data DROP COLUMN LONGITUDE;
ALTER TABLE combined_2010_to_2023_hospital_data DROP COLUMN LATITUDE;

-- 2: Move COUNTY to combinedHospitalInfo
-- COUNTY only depends on OSHPDID

ALTER TABLE combinedHospitalInfo ADD COLUMN COUNTY TEXT;

UPDATE combinedHospitalInfo
SET COUNTY = (
    SELECT COUNTY
    FROM combined_2010_to_2023_hospital_data
    WHERE combined_2010_to_2023_hospital_data.OSHPDID = combinedHospitalInfo.OSHPDID
    LIMIT 1
);

ALTER TABLE combined_2010_to_2023_hospital_data DROP COLUMN COUNTY;

-- Delete all NULL row 
DELETE FROM combinedHospitalInfo WHERE OSHPDID IS NULL;

-- 3: Create Procedure Table
-- Assigns IDs to unique procedures

CREATE TABLE Procedure (
    ProcedureID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProcedureName TEXT UNIQUE
);

INSERT INTO Procedure (ProcedureName)
SELECT DISTINCT "Procedure/Condition" 
FROM combined_2010_to_2023_hospital_data;

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

UPDATE Procedure SET ProcedureName = 'Esophageal Resection' WHERE ProcedureName = 'Espophageal Resection';

-- 4: Create statewide_averages table
-- Separates state-level rows without OSHPDID from hospital rows

CREATE TABLE statewide_averages (
    YEAR                           INT     NOT NULL CHECK(YEAR >= 2010 AND YEAR <= 2023),
    ProcedureID                    INTEGER NOT NULL,
    "Risk Adjusted Mortality Rate" TEXT,
    "# of Deaths"                  TEXT,
    "# of Cases"                   TEXT,
    FOREIGN KEY (ProcedureID) REFERENCES Procedure(ProcedureID)
);

INSERT INTO statewide_averages
SELECT YEAR, ProcedureID, "Risk Adjusted Mortality Rate", "# of Deaths", "# of Cases"
FROM combined_2010_to_2023_hospital_data
WHERE OSHPDID IS NULL;

-- Then delete them from the main table
DELETE FROM combined_2010_to_2023_hospital_data
WHERE OSHPDID IS NULL;

-- 5: Add PRIMARY KEY to combinedHospitalInfo
-- Builds table with OSHPDID as primary KEY

CREATE TABLE combinedHospitalInfo_new (
    OSHPDID  TEXT        NOT NULL PRIMARY KEY,
    HOSPITAL TEXT        NOT NULL,
    COUNTY   TEXT,
    LONGITUDE TEXT,
    LATITUDE  TEXT
);
INSERT INTO combinedHospitalInfo_new SELECT OSHPDID, HOSPITAL, COUNTY, LONGITUDE, LATITUDE FROM combinedHospitalInfo;
DROP TABLE combinedHospitalInfo;
ALTER TABLE combinedHospitalInfo_new RENAME TO combinedHospitalInfo;

-- 6: Add FOREIGN KEYS to combined_2010_to_2023_hospital_data

CREATE TABLE combined_2010_to_2023_hospital_data_new (
    YEAR                        INT     NOT NULL CHECK(YEAR >= 2010 AND YEAR <= 2023),
    OSHPDID                     TEXT    NOT NULL,
    ProcedureID                 INTEGER NOT NULL,
    "Risk Adjusted Mortality Rate" TEXT,
    "# of Deaths"               TEXT,
    "# of Cases"                TEXT,
    "Hospital Ratings"          TEXT,
    FOREIGN KEY (OSHPDID)      REFERENCES combinedHospitalInfo(OSHPDID),
    FOREIGN KEY (ProcedureID)  REFERENCES Procedure(ProcedureID)
);
INSERT INTO combined_2010_to_2023_hospital_data_new 
    SELECT YEAR, OSHPDID, ProcedureID, "Risk Adjusted Mortality Rate", "# of Deaths", "# of Cases", "Hospital Ratings"
    FROM combined_2010_to_2023_hospital_data;
DROP TABLE combined_2010_to_2023_hospital_data;
ALTER TABLE combined_2010_to_2023_hospital_data_new RENAME TO combined_2010_to_2023_hospital_data;

