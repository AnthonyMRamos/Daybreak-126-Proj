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
ORDER BY  total_stroke_cases DESC
LIMIT 25;