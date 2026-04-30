-- Add county column to combinedHospitalInfo
ALTER TABLE combinedHospitalInfo ADD COLUMN COUNTY TEXT;

-- Moves county data from combined_2010_to_2023_hospital_data to combinedHospitalInfo
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