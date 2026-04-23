-- Create new table with corrected column spelling
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

-- Delete old table 
DROP TABLE combined_2010_to_2023_hospital_data;

-- Rename new table to original 
ALTER TABLE combined_2010_to_2023_hospital_data_rename RENAME TO combined_2010_to_2023_hospital_data;