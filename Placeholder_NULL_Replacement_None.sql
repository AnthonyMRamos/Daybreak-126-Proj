-- Fix improper placeholders
-- Replaces (none) placeholders with proper NULL
UPDATE combined_2010_to_2023_hospital_data
SET "Risk Adjusted Mortality Rate" = NULL
WHERE "Risk Adjusted Mortality Rate" = 'None';

UPDATE combined_2010_to_2023_hospital_data
SET "# of Deaths" = NULL
WHERE "# of Deaths" = 'None';

UPDATE combined_2010_to_2023_hospital_data
SET "# of Cases" = NULL
WHERE "# of Cases" = 'None';

UPDATE combined_2010_to_2023_hospital_data
SET "Hospital Ratings" = NULL
WHERE "Hospital Ratings" = 'None';

UPDATE combined_2010_to_2023_hospital_data
SET "LONGITUDE" = NULL
WHERE "LONGITUDE" = 'None';

UPDATE combined_2010_to_2023_hospital_data
SET "LATITUDE" = NULL
WHERE "LATITUDE" = 'None';

UPDATE combined_2010_to_2023_hospital_data
SET "OSHPDID" = NULL
WHERE "OSHPDID" = 'None';

