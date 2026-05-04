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