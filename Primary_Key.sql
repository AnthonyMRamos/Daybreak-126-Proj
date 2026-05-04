CREATE TABLE combinedHospitalInfo_new (
    OSHPDID  TEXT        NOT NULL PRIMARY KEY,
    HOSPITAL TEXT        NOT NULL,
    COUNTY   TEXT,
    LONGITUDE TEXT,
    LATITUDE  TEXT
);
INSERT INTO combinedHospitalInfo_new SELECT OSHPDID, HOSPITAL, COUNTY, LONGITUDE, LATITUDE FROM combinedHospitalInfo;
DROP TABLE combinedHospitalInfo;
ALTER TABLE combinedHospitalInfo_new RENAME TO combinedHospitalInfo;