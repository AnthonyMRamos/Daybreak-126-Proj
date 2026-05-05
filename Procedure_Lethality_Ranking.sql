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