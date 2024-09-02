-- Find nulls

SELECT
    SUM(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS null_ride_id,
    SUM(CASE WHEN rideable_type IS NULL THEN 1 ELSE 0 END) AS null_rideable_type,
    SUM(CASE WHEN started_at IS NULL THEN 1 ELSE 0 END) AS null_started_at,
    SUM(CASE WHEN ended_at IS NULL THEN 1 ELSE 0 END) AS null_ended_at,
    SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS null_start_station_name,
    SUM(CASE WHEN start_station_id IS NULL THEN 1 ELSE 0 END) AS null_start_station_id,
    SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS end_station_name,
    SUM(CASE WHEN end_station_id IS NULL THEN 1 ELSE 0 END) AS null_end_station_id,
    SUM(CASE WHEN start_lat IS NULL THEN 1 ELSE 0 END) AS null_start_lat,
    SUM(CASE WHEN start_lng IS NULL THEN 1 ELSE 0 END) AS null_start_lng,
    SUM(CASE WHEN end_lat IS NULL THEN 1 ELSE 0 END) AS null_end_lat,
    SUM(CASE WHEN end_lng IS NULL THEN 1 ELSE 0 END) AS null_end_lng,
    SUM(CASE WHEN member_casual IS NULL THEN 1 ELSE 0 END) AS null_member_casual
FROM tripdata_2023;

-- 0,0,0,0,0,0,0,0,0,0,0,0,0
---- no nulls

-- Find duplicate columns

SELECT ride_id, COUNT(*) as count
FROM tripdata_2023
GROUP BY ride_id
HAVING count > 1;

-- ride_id,12
---- 12 duplicates

-- Ensure primary key is standardized

SELECT LENGTH(ride_id) AS len_ride_id, COUNT(ride_id) AS num_rows
FROM tripdata_2023
GROUP BY len_ride_id;

-- 7,12
-- 16,5719877
---- 7 have incorrect IDs

-- See how clean the station data is
SELECT COUNT(ride_id) AS num_null_station_info
FROM tripdata_2023
WHERE start_station_name IS NULL OR start_station_id IS NULL;

SELECT COUNT(ride_id) AS num_null_station_info
FROM tripdata_2023
WHERE end_station_id IS NULL OR end_station_id IS NULL;

SELECT COUNT(ride_id) AS num_null_start_location
FROM tripdata_2023
WHERE start_lat IS NULL OR start_lng IS NULL;

SELECT COUNT(ride_id) AS num_null_end_location
FROM tripdata_2023
WHERE end_lat IS NULL OR end_lng IS NULL;

-- 0
-- 0
-- 0
-- 0
---- none missing

-- Total types of riders

SELECT DISTINCT rideable_type, COUNT(rideable_type) AS num_types
FROM tripdata_2023
GROUP BY rideable_type;

--classic_bike,2696011
--docked_bike,78287
--electric_bike,2945579
--rideable_type,12
---- 4 types, 1 erroneous

-- Membership types

SELECT DISTINCT member_casual, COUNT(member_casual) AS num_trips
FROM tripdata_2023
GROUP BY member_casual;

--casual,2059179
--member,3660698
--member_casual,12
---- 3 types, 1 erroneous

-- Find # trips of unreasonable length.

SELECT COUNT(*) AS num_too_long
FROM tripdata_2023
WHERE strftime('%s', ended_at) - strftime('%s', started_at) >= 86400;

---- 6418 too long

SELECT COUNT(*) AS num_too_short
FROM tripdata_2023
WHERE strftime('%s', ended_at) - strftime('%s', started_at) < 60;

---- 149615 too short