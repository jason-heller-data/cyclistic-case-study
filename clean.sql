BEGIN TRANSACTION;

DROP TABLE IF EXISTS tripdata_2023_clean;

CREATE TABLE tripdata_2023_clean AS SELECT ride_id, 
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    --start_station_id,     not relevant to the case study
    end_station_name,
    --end_station_id,     not relevant to the case study
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual,
    (strftime('%s', ended_at) - strftime('%s', started_at)) AS ride_length,
    (CASE strftime('%w', started_at)
        WHEN '0' THEN 'SUN'
        WHEN '1' THEN 'MON'
        WHEN '2' THEN 'TUES'
        WHEN '3' THEN 'WED'
        WHEN '4' THEN 'THURS'
        WHEN '5' THEN 'FRI'
        WHEN '6' THEN 'SAT'    
    END) AS day,
    (CASE strftime('%m', started_at)
        WHEN '1' THEN 'JAN'
        WHEN '2' THEN 'FEB'
        WHEN '3' THEN 'MAR'
        WHEN '4' THEN 'APR'
        WHEN '5' THEN 'MAY'
        WHEN '6' THEN 'JUN'
        WHEN '7' THEN 'JUL'
        WHEN '8' THEN 'AUG'
        WHEN '9' THEN 'SEP'
        WHEN '10' THEN 'OCT'
        WHEN '11' THEN 'NOV'
        WHEN '12' THEN 'DEC'   
    END) AS month
FROM tripdata_2023 WHERE LENGTH(ride_id) = 16 AND ride_length >= 60 AND ride_length <= 86400;

-- Verify the erroneous 12 entries are cleaned
SELECT member_casual, COUNT(member_casual) AS num_trips
FROM tripdata_2023_clean
GROUP BY member_casual;

SELECT rideable_type, COUNT(rideable_type) AS num_types
FROM tripdata_2023_clean
GROUP BY rideable_type;

SELECT LENGTH(ride_id) AS len_ride_id, COUNT(ride_id) AS num_rows
FROM tripdata_2023_clean
GROUP BY len_ride_id;

SELECT COUNT(ride_id) AS num_rows_old
FROM tripdata_2023;

SELECT COUNT(ride_id) AS num_rows_new
FROM tripdata_2023_clean;
-- 5719889 - 5563844 = 156,045 entries deleted

COMMIT;