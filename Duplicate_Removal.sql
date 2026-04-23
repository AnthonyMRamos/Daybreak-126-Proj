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