 --CREATING A TABLE TO COMBINE ALL MONTHLY TABLES INTO ONE USING 'UNION'

 Drop Table If exists Unified_Year_Bike_Tripdata
 Create Table Unified_Year_Bike_Tripdata
 (Ride_Id nvarchar(255),
 Rideable_Type nvarchar(255),
 Started_At datetime,
 Ended_At datetime,
 Start_Station_Name nvarchar(255),
 Start_Station_Id float,
 End_Station_Name nvarchar(255),
 End_Station_Id nvarchar(255),
 Start_Lat float,
 Start_Lng float,
 End_Lat float,
 End_Lng float,
 Member_Casual nvarchar(255),
 )
 ---INSERTING ALL THE MONTHLY DATA INTO ONE TABLE FOR EASE OF QUERYING 

 ----Inserting April to June Data into created table
Insert Into  [dbo].[Unified_Year_Bike_Tripdata]
(ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual)
Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202101-divvy-tripdata$']
UNION
 Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202102-divvy-tripdata$']

UNION
 Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['March 2021-divvy-tripdata$']


----Inserting April to June Data into created table

Insert Into  [dbo].[Unified_Year_Bike_Tripdata]
(ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual)
 Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202004-divvy-tripdata$']
UNION
 Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['May 2020$']

UNION
 Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202006-divvy-tripdata$']


---Inserting July to September Data into created table

Insert Into  [dbo].[Unified_Year_Bike_Tripdata]
(ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual)
Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202007-divvy-tripdata$']
UNION
Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].[August_divvy_tripdata]

UNION
Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202009-divvy-tripdata$']

---Inserting October to December Data into created table

Insert Into  [dbo].[Unified_Year_Bike_Tripdata]
(ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual)
 Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202010-divvy-tripdata$']
UNION
Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202011-divvy-tripdata$']

UNION
Select ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
FROM
[dbo].['202012-divvy-tripdata$']

--Calculating Ride Length and Converting the starting date to know the exact weekday

With checkin as
(
Select *,DATEDIFF(SECOND, started_at, ended_at)
 AS Ride_Duration,DATENAME(WEEKDAY,[started_at]) Weekday
 From [dbo].[Unified_Year_Bike_Tripdata])

 Select *
 From checkin
 where ride_duration<0
 Order By Ride_Duration DESC



 
Select [rideable_type], Count ([rideable_type]) As Bike_Count
From [dbo].[Unified_Year_Bike_Tripdata]
Group by [rideable_type]


--Calculate Mean, Median and Mode (Using CTE)

WITH Bike_Data_CTE AS 
(
    SELECT
        [start_station_name],
        [end_station_name],
        [rideable_type],
        DATEDIFF(MINUTE, started_at, ended_at) AS Ride_Duration
    FROM
       [dbo].[Unified_Year_Bike_Tripdata]
)

SELECT
    AVG(Ride_Duration) AS Mean_Ride_Length,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Ride_Duration) OVER() AS Median
FROM
    Bike_Data_CTE
	Group By Ride_Duration

--Select [started_at],
--DATENAME(WEEKDAY,[started_at]) Weekday
--From [dbo].[August_divvy_tripdata]







