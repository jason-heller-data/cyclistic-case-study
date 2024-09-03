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

```
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
```

All results are 0, showing we have no null values.

Next we search for duplicate columns.

```
SELECT ride_id, COUNT(*) as count
FROM tripdata_2023
GROUP BY ride_id
HAVING count > 1;
```

We find 12 duplicate columns. We will see this number appear in our later queries.

Next, we ensure our primary key has a consistent format. We do this by checking the length of each entry in the ride_id column.

```
SELECT LENGTH(ride_id) AS len_ride_id, COUNT(ride_id) AS num_rows
FROM tripdata_2023
GROUP BY len_ride_id;
```

This shows us that of the 5,719,889 rows, 12 have a length of seven while the rest have a length of sixteen. We can discern that these 12 are erroneous.

Next, we check the membership data.

```
SELECT DISTINCT rideable_type, COUNT(rideable_type) AS num_types
FROM tripdata_2023
GROUP BY rideable_type;
```

We see the expected 'casual' and 'member' types, but also an erroneous 'member_casual' type-- likely related to the repeated errors we see occuring in volumes of 12.

Lastly, we will look for trips of excessively long and short lengths.

```
SELECT COUNT(*) AS num_too_long
FROM tripdata_2023
WHERE strftime('%s', ended_at) - strftime('%s', started_at) >= 86400;

SELECT COUNT(*) AS num_too_short
FROM tripdata_2023
WHERE strftime('%s', ended_at) - strftime('%s', started_at) < 60;
```

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

![member_percent](https://github.com/user-attachments/assets/23c2315c-1a50-41ab-afb7-98c4364f00a6)

We see that 35.96% of all riders do not hold a membership. 



![mode_transport](https://github.com/user-attachments/assets/ea2fb14d-98f8-4ec2-ac68-533bdeb9cd4b)
![mode_by_type](https://github.com/user-attachments/assets/caf3e2f9-3a23-48a6-9323-2916e910d854)

Out of the three modes of transport, the electric bike is the most popular, slightly more so than the classic bike. The least used are the docked bikes, which are only used by casual riders.

Next, we examing the volume of ridership over time:

![rider_volume](https://github.com/user-attachments/assets/3993f8e9-10b1-47bc-939f-fc18b62f1cb9)

**Weekly:** Here, we see membership is highest in the weekdays, and casual members ride more often on the weekends. 

**Monthly:** Over an annual timespan, we can see that casual ridership volume is roughly half of the membership volume. Additionally, total ridership peaks in the summer months, namely July and August.

Another metric researched is ride length.

![rider_dist](https://github.com/user-attachments/assets/7bbc692d-9d2c-4f60-a3d6-aca752d6c3dd)

**Weekly:** Notably, casual riders ride duration spikes on weekends, and membership ride length is more stable, but increases on weekdays. This suggests members ride for routine trips such as commuting to work or school, whereas casual riders engage in trips more geared towards leisurely activities.

**Monthly:** For both groups, ridership length spikes in the summer months. One speculation for the cause could simply be that better weather is more conducive to bike trips.


Lastly, we examine the GPS data to see where each membership type is heading towards and leaving from.

![ride_start](https://github.com/user-attachments/assets/018d8c11-b5c6-448c-bebf-c6e638f4f85c)


Membership riders are more grouped around the metropolitan area of Chicago and start their trips there, which differs from casual riders which generally start their trip near attractions such as parks. Similar trends follow for the terminus of their trips:


![ride_end](https://github.com/user-attachments/assets/6aeef621-b1a0-4625-840e-230dad4f0f1d)


This lends credulence to the idea that membership riders use the service for their commutes, whereas casual riders use it for leisure.

### Share

Overall, here are the conclusions we can draw:


**Casual Riders:**
1) Ride more often on weekends.
2) Ride twice as long as members.
3) Tend to head towards/from attractions such as parks.

**Member Riders:**
1) Ride more often and ride the most on weekdays
2) Ride consistent, shorter distances compared to casual riders
3) Use their trips for commuting

Ridership peaks in the summer for both groups.

### Act

Having identified the behaviorial differences between the two groups, we can draw some conclusions on the best way to convert more riders to joining the membership.

1) Adjust the membership to accomodate riders who wish to use the service for weekend trips.
2) Incentivize the membership by offering discounts to behaviors exhibited by the casual group, specifically for longer rides or to specific locations such as parks.
3) Target advertising in the summer months, when ridership is at its highest.

