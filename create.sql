DROP TABLE IF EXISTS tripdata_202301;
DROP TABLE IF EXISTS tripdata_202302;
DROP TABLE IF EXISTS tripdata_202303;
DROP TABLE IF EXISTS tripdata_202304;
DROP TABLE IF EXISTS tripdata_202305;
DROP TABLE IF EXISTS tripdata_202306;
DROP TABLE IF EXISTS tripdata_202307;
DROP TABLE IF EXISTS tripdata_202308;
DROP TABLE IF EXISTS tripdata_202309;
DROP TABLE IF EXISTS tripdata_202310;
DROP TABLE IF EXISTS tripdata_202311;
DROP TABLE IF EXISTS tripdata_202312;

CREATE TABLE tripdata_202301 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at VARCHAR(50),
    ended_at VARCHAR(50),
    start_station_name VARCHAR(50),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(50),
    end_station_id VARCHAR(50),
    start_lat DECIMAL(9, 6),
    start_lng DECIMAL(9, 6),
    end_lat DECIMAL(9, 6),
    end_lng DECIMAL(9, 6),
    member_casual VARCHAR(50)
);

CREATE TABLE tripdata_202302 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202303 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202304 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202305 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202306 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202307 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202308 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202309 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202310 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202311 AS SELECT * FROM tripdata_202301 WHERE 1=0;
CREATE TABLE tripdata_202312 AS SELECT * FROM tripdata_202301 WHERE 1=0;