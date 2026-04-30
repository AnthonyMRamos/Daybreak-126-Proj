SELECT 
    combinedHospitalInfo.OSHPDID,
    combinedHospitalInfo.LONGITUDE AS current_long,
    combinedHospitalInfo.LATITUDE AS current_lat,
    sub.LONGITUDE AS will_become_long,
    sub.LATITUDE AS will_become_lat
FROM combinedHospitalInfo
JOIN (
    SELECT OSHPDID, LONGITUDE, LATITUDE
    FROM combinedHospitalInfo AS sub
    GROUP BY OSHPDID
    HAVING rowid = MIN(rowid)
) sub ON sub.OSHPDID = combinedHospitalInfo.OSHPDID
WHERE combinedHospitalInfo.LONGITUDE != sub.LONGITUDE 
OR combinedHospitalInfo.LATITUDE != sub.LATITUDE;

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