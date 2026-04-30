SELECT 
    combinedHospitalInfo.OSHPDID,
    combinedHospitalInfo.HOSPITAL AS current_name,
    sub.HOSPITAL AS will_become
FROM combinedHospitalInfo
JOIN (
    SELECT OSHPDID, HOSPITAL
    FROM combinedHospitalInfo AS sub
    GROUP BY OSHPDID
    HAVING rowid = MIN(rowid)
) sub ON sub.OSHPDID = combinedHospitalInfo.OSHPDID
WHERE combinedHospitalInfo.HOSPITAL != sub.HOSPITAL;

UPDATE combinedHospitalInfo
SET HOSPITAL = (
    SELECT HOSPITAL
    FROM combinedHospitalInfo AS sub
    WHERE sub.OSHPDID = combinedHospitalInfo.OSHPDID
    ORDER BY sub.rowid ASC
    LIMIT 1
);