-- Queries.sql
-- Analytical queries

-- 1: Annual Deaths and Risk-Adjusted Mortality Rate Trend

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

-- 2: Procedure Lethality Ranking - Statewide 

SELECT  p.ProcedureName,
        ROUND(AVG(CAST(s."Risk Adjusted Mortality Rate" AS REAL)), 2) AS avg_mortality,
        ROUND(MIN(CAST(s."Risk Adjusted Mortality Rate" AS REAL)), 2) AS best_year,
        ROUND(MAX(CAST(s."Risk Adjusted Mortality Rate" AS REAL)), 2) AS worst_year,
        ROUND(AVG(CAST(s."# of Deaths" AS REAL)), 0)                    AS avg_annual_deaths
FROM    statewide_averages s
JOIN    Procedure p ON s.ProcedureID = p.ProcedureID
WHERE   s."Risk Adjusted Mortality Rate" IS NOT NULL
GROUP BY p.ProcedureName
ORDER BY avg_mortality DESC;

-- 3: Heart Failure Bay Area - Mortality Rate Ranking by County

SELECT 
    h.COUNTY,
    SUM(CAST(d.`# of Cases` AS INTEGER)) AS Total_Heart_Failure_Cases,
    SUM(CAST(d.`# of Deaths` AS INTEGER)) AS Total_Heart_Failure_Deaths,
    ROUND(
        (CAST(SUM(CAST(d.`# of Deaths` AS INTEGER)) AS FLOAT) 
        / SUM(CAST(d.`# of Cases` AS INTEGER))) * 100, 2
    ) AS Raw_Fatality_Percentage
FROM combined_2010_to_2023_hospital_data d
JOIN combinedHospitalInfo h 
    ON d.OSHPDID = h.OSHPDID
JOIN Procedure p 
    ON d.ProcedureID = p.ProcedureID
WHERE p.ProcedureName = 'Heart Failure'
  AND h.COUNTY IN (
      'Alameda', 'Contra Costa', 'Marin', 'Napa', 'San Francisco', 
      'San Mateo', 'Santa Clara', 'Solano', 'Sonoma'
  )
  AND d.`# of Cases` NOT LIKE '%-%' -- Filters out suppressed data rows
  AND d.`# of Deaths` NOT LIKE '%-%'
GROUP BY h.COUNTY
ORDER BY Raw_Fatality_Percentage ASC;

-- 4: Heart Failure Bay Area - Hospital Ratings by COUNTY

SELECT 
    h.COUNTY,
    COUNT(d.`Hospital Ratings`) AS Total_Ratings_Over_Time,
    SUM(CASE WHEN d.`Hospital Ratings` LIKE '%Better%' THEN 1 ELSE 0 END) AS Count_Better,
    SUM(CASE WHEN d.`Hospital Ratings` LIKE '%Worse%' THEN 1 ELSE 0 END) AS Count_Worse,
    ROUND(
        CAST(SUM(CASE WHEN d.`Hospital Ratings` LIKE '%Better%' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(d.`Hospital Ratings`) * 100, 2
    ) AS Percent_Better_Ratings,
    ROUND(
        CAST(SUM(CASE WHEN d.`Hospital Ratings` LIKE '%Worse%' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(d.`Hospital Ratings`) * 100, 2
    ) AS Percent_Worse_Ratings
FROM combined_2010_to_2023_hospital_data d
JOIN combinedHospitalInfo h 
    ON d.OSHPDID = h.OSHPDID
JOIN Procedure p 
    ON d.ProcedureID = p.ProcedureID
WHERE p.ProcedureName = 'Heart Failure'
  AND h.COUNTY IN (
      'Alameda', 'Contra Costa', 'Marin', 'Napa', 'San Francisco', 
      'San Mateo', 'Santa Clara', 'Solano', 'Sonoma'
  )
GROUP BY h.COUNTY
ORDER BY Percent_Better_Ratings DESC;

-- 5: Hospitals by Stroke Cases and Mortality

SELECT  h.HOSPITAL, h.COUNTY,
        SUM(CAST(d."# of Cases" AS INTEGER))                        AS total_stroke_cases,
        ROUND(AVG(CAST(d."Risk Adjusted Mortality Rate" AS REAL)), 2) AS avg_mortality,
        COUNT(DISTINCT d.YEAR)                                        AS years_reported
FROM    combined_2010_to_2023_hospital_data d
JOIN    combinedHospitalInfo h ON d.OSHPDID   = h.OSHPDID
JOIN    Procedure p           ON d.ProcedureID = p.ProcedureID
WHERE   p.ProcedureName IN ('Acute Stroke','Acute Stroke Ischemic',
                             'Acute Stroke Hemorrhagic','Acute Stroke Subarachnoid')
  AND   d."Risk Adjusted Mortality Rate" IS NOT NULL
  AND   d."# of Cases" IS NOT NULL
  AND   d.OSHPDID IN (                       -- subquery: only hospitals with 10+ years of data
          SELECT OSHPDID FROM combined_2010_to_2023_hospital_data
          WHERE  ProcedureID IN (SELECT ProcedureID FROM Procedure
                                  WHERE  ProcedureName LIKE 'Acute Stroke%')
          GROUP BY OSHPDID HAVING COUNT(DISTINCT YEAR) >= 10
        )
GROUP BY  h.HOSPITAL, h.COUNTY
ORDER BY  total_stroke_cases DESC;
