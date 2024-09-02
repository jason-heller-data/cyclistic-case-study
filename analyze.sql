BEGIN TRANSACTION;

-- Usage by membership
SELECT member_casual, rideable_type, COUNT(*) AS num_trips
FROM tripdata_2023_clean
GROUP BY member_casual, rideable_type
ORDER BY member_casual, num_trips;

-- Start locations
SELECT start_station_name, member_casual,
  AVG(start_lat) AS start_lat, AVG(start_lng) AS start_lng,
  COUNT(ride_id) AS total_trips
FROM tripdata_2023_clean
GROUP BY start_station_name, member_casual;

-- End locations
SELECT end_station_name, member_casual,
  AVG(end_lat) AS end_lat, AVG(end_lng) AS end_lng,
  COUNT(ride_id) AS total_trips
FROM tripdata_2023_clean
GROUP BY end_station_name, member_casual;

-- # trips
SELECT month, member_casual, COUNT(ride_id) AS num_trips_month
FROM tripdata_2023_clean
GROUP BY month, member_casual;

SELECT day, member_casual, COUNT(ride_id) AS num_trips_day
FROM tripdata_2023_clean
GROUP BY day, member_casual;

-- Ride length
SELECT month, member_casual, AVG(ride_length) AS avg_ride_length_month
FROM tripdata_2023_clean
GROUP BY month, member_casual;

SELECT day, member_casual, AVG(ride_length) AS avg_ride_length_day
FROM tripdata_2023_clean
GROUP BY day, member_casual;

COMMIT;