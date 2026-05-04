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