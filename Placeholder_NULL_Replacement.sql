-- Fix improper placeholders
-- Replaces (.) placeholders with proper NULL
UPDATE combined_2010_to_2023_hospital_data
SET "Risk Adjusted Mortality Rate" = NULL
WHERE "Risk Adjusted Mortality Rate" = '.';

UPDATE combined_2010_to_2023_hospital_data
SET "# of Deaths" = NULL
WHERE "# of Deaths" = '.';

UPDATE combined_2010_to_2023_hospital_data
SET "# of Cases" = NULL
WHERE "# of Cases" = '.';

UPDATE combined_2010_to_2023_hospital_data
SET "LONGITUDE" = NULL
WHERE "LONGITUDE" = '.';

UPDATE combined_2010_to_2023_hospital_data
SET "LATITUDE" = NULL
WHERE "LATITUDE" = '.';

UPDATE combined_2010_to_2023_hospital_data
SET "OSHPDID" = NULL
WHERE "OSHPDID" = '.';

-- Remove NULL filled ROW
DELETE
FROM combined_2010_to_2023_hospital_data
WHERE YEAR IS NULL;