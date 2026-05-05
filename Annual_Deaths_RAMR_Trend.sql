SELECT YEAR,
    AVG(CAST("# of Deaths" AS REAL)) as avg_deaths,
    AVG(CAST("Risk Adjusted Mortality Rate" AS REAL)) as avg_ramr,
    SUM(CAST("# of Deaths" AS INTEGER)) as total_deaths,
    SUM(CAST("# of Cases" AS INTEGER)) as total_cases,
    ROUND(SUM(CAST("# of Deaths" AS REAL)) / SUM(CAST("# of Cases" AS REAL)) * 100, 2) as crude_mortality_pct
FROM combined_2010_to_2023_hospital_data
WHERE "# of Deaths" IS NOT NULL 
AND "Risk Adjusted Mortality Rate" IS NOT NULL
AND OSHPDID IS NOT NULL
GROUP BY YEAR
ORDER BY YEAR;