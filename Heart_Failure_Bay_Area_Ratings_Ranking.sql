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