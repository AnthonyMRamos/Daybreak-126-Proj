DELETE FROM combinedHospitalInfo
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM combinedHospitalInfo
    GROUP BY
        HOSPITAL,
        OSHPDID,
        LONGITUDE,
        LATITUDE
);