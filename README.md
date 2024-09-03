# Google Data Analytics Capstone: Cyclistic Case Study

## Introduction



### Data source
[divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html)
[license](https://www.divvybikes.com/data-license-agreement)
Accessed on 09/01/24.

Data provided by Motivate International Inc.

### Tools used

[SQLite](https://www.sqlite.org/) for my database
[Power BI](https://www.microsoft.com/en-us/power-platform/products/power-bi) for visualizations

## Ask

The task is to find marketing strategies to turn casual users of the service into membership holders. There are three questions to answer:

1. How do annual members and casual riders use Cyclistic bikes differently?  
2. Why would casual riders buy Cyclistic annual memberships?  
3. How can Cyclistic use digital media to influence casual riders to become members?  

Our objective is to tackle the first point.

## Prepare

The data provided is partitioned by month into 12 datasets, and is anonymized. That is to say, there is no personally identifiable information (PII) within the data. The timespan covered by this data starts at January of 2023 to December of 2023.

Within the dataset are the following columns:

1) ride_id: Primary identifier of each trip
2) rideable_type: The type of vehicle used in the trip
3) started_at, ended_at: The start/end time of the trip
4) start_station_name, start_station_id: The name and ID key for the docking station the user departed from
5) end_station_name, end_station_id: The name and ID key for the docking station at the destination
6) start_lat, start_lng: lat/long coordinates of the trip's origin
7) end_lat, end_lng: lat/long coordinates of the trip's terminus
8) member_casual: the nature of the rider's membership, that being member or casual

## Process

The first step is to aggregate the 12 datasets into one singular dataset. I add these datasets to my database using [create.sql](https://github.com/jason-heller-data/cyclistic-case-study/blob/main/create.sql) and import the data using SQLite3. It is then aggregated in [aggregate.sql](https://github.com/jason-heller-data/cyclistic-case-study/blob/main/aggregate.sql).

The next step is to clean the data. To find errors in the dataset I run some queries in [explore.sql](https://github.com/jason-heller-data/cyclistic-case-study/blob/main/explore.sql) to understand the state of the database without any further modifications.

### Data exploration

First I check for any null values within the dataset.

[code]
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
[/code]

All results are 0, showing we have no null values.

Next we search for duplicate columns.

[code]
SELECT ride_id, COUNT(*) as count
FROM tripdata_2023
GROUP BY ride_id
HAVING count > 1;
[/code]

We find 12 duplicate columns. We will see this number appear in our later queries.

Next, we ensure our primary key has a consistent format. We do this by checking the length of each entry in the ride_id column.

[code]
SELECT LENGTH(ride_id) AS len_ride_id, COUNT(ride_id) AS num_rows
FROM tripdata_2023
GROUP BY len_ride_id;
[/code]

This shows us that of the 5,719,889 rows, 12 have a length of seven while the rest have a length of sixteen. We can discern that these 12 are erroneous.

Next, we check the membership data.

[code]
SELECT DISTINCT rideable_type, COUNT(rideable_type) AS num_types
FROM tripdata_2023
GROUP BY rideable_type;
[/code]

We see the expected 'casual' and 'member' types, but also an erroneous 'member_casual' type-- likely related to the repeated errors we see occuring in volumes of 12.

Lastly, we will look for trips of excessively long and short lengths.

[code]
SELECT COUNT(*) AS num_too_long
FROM tripdata_2023
WHERE strftime('%s', ended_at) - strftime('%s', started_at) >= 86400;

SELECT COUNT(*) AS num_too_short
FROM tripdata_2023
WHERE strftime('%s', ended_at) - strftime('%s', started_at) < 60;
[/code]

We define a trip longer than or equal to a day as too long and a trip less than a minute to be erroneous trip lengths. From this, we find that 6418 trips were too long and 149,615 were too short.

### Cleaning

Having looked at the data, we can begin cleaning.

This is done within [clean.sql](https://github.com/jason-heller-data/cyclistic-case-study/blob/main/clean.sql).

The following steps are taken:

1) start_station_id and end_station_id are dropped. We only use the station name and lat/long coords in our analysis.
2) ride_length is added as a column, tracking the length of a trip in seconds
3) Rides with lengths shorter than a minute or longer than a day are excluded.
4) Two new columns for the day and month of the trip are added
5) Two datapoints from the lat/long coords are excluded for being erroneous.

## Analyze

The data is now aggregated and cleaned. Using Power BI, I analyzed the dataset and created relevant visualizations to identify trends.

First, let us compare total ridership between memberships.
