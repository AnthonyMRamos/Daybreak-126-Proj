-- Data_load.sql
-- Data cleaning and loading steps

-- 1: Fix column header misspelling
-- "Risk Adjuested" → "Risk Adjusted"

CREATE TABLE combined_2010_to_2023_hospital_data_rename AS 
SELECT
	YEAR,
	COUNTY,
	HOSPITAL,
	OSHPDID,
	"Procedure/Condition",
	"Risk Adjuested Mortality Rate" AS "Risk Adjusted Mortality Rate",
	"# of Deaths",
	"# of Cases",
	"Hospital Ratings",
	LONGITUDE,
	LATITUDE
FROM combined_2010_to_2023_hospital_data;

DROP TABLE combined_2010_to_2023_hospital_data;
ALTER TABLE combined_2010_to_2023_hospital_data_rename RENAME TO combined_2010_to_2023_hospital_data;

-- 2: Fix character encoding issues in HOSPITAL names
-- Replaces broken characters with hyphens and apostrophes

-- Fix separators (hyphens)
UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, ' � ', ' - ')
WHERE HOSPITAL LIKE '% �%';

UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, ' ? ', ' - ')
WHERE HOSPITAL LIKE '% ? %';

-- Fix the apostrophes
UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, '�', '''')
WHERE HOSPITAL LIKE '%�%';

UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, '?', '''')
WHERE HOSPITAL LIKE '%?%';

-- 3: Replaces 'None' placeholders with proper NULL

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

-- 4: Replace '.' placeholder strings with proper NULL
-- Also remove full null ROWS

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

-- 5: Remove duplicate rows from combined_2010_to_2023_hospital_data
-- Keeps the first occurrence of each

DELETE FROM combined_2010_to_2023_hospital_data
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM combined_2010_to_2023_hospital_data
    GROUP BY
        YEAR,
        COUNTY,
        HOSPITAL,
        OSHPDID,
        "Procedure/Condition",
        "Risk Adjusted Mortality Rate",
        "# of Deaths",
        "# of Cases",
        "Hospital Ratings",
        LONGITUDE,
        LATITUDE
);

-- 6: Remove duplicate rows from combinedHospitalInfo

DELETE FROM combinedHospitalInfo
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM combinedHospitalInfo
    GROUP BY
        HOSPITAL,
        OSHPDID,
        LONGITUDE,
        LATITUDE
		COUNTY
);

-- 7: Standardize the HOSPITAL names wihin combinedHospitalInfo
-- Each OSHPDID gets the earliest recorded hospital name

UPDATE combinedHospitalInfo
SET HOSPITAL = (
    SELECT HOSPITAL
    FROM combinedHospitalInfo AS sub
    WHERE sub.OSHPDID = combinedHospitalInfo.OSHPDID
    ORDER BY sub.rowid ASC
    LIMIT 1
);

-- 8: Standardize the LONGITUDE and LATITUDE wihin combinedHospitalInfo
-- Each OSHPDID gets the earliest recorded cordinates

UPDATE combinedHospitalInfo
SET 
    LONGITUDE = (
        SELECT LONGITUDE
        FROM combinedHospitalInfo AS sub
        WHERE sub.OSHPDID = combinedHospitalInfo.OSHPDID
        ORDER BY sub.rowid ASC
        LIMIT 1
    ),
    LATITUDE = (
        SELECT LATITUDE
        FROM combinedHospitalInfo AS sub
        WHERE sub.OSHPDID = combinedHospitalInfo.OSHPDID
        ORDER BY sub.rowid ASC
        LIMIT 1
    );



