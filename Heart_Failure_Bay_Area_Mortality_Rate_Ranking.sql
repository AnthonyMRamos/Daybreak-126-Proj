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