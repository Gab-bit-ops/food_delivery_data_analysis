CREATE DATABASE food_delivery;

USE food_delivery;

CREATE TABLE food_delivery (
    ID                   VARCHAR(20) PRIMARY KEY,
    Delivery_person_ID          VARCHAR(30),
    Delivery_person_Age     TINYINT UNSIGNED,
    Delivery_person_Ratings   DECIMAL(2,1),
    Restaurant_latitude       DECIMAL(9,6),
    Restaurant_longitude      DECIMAL(9,6),
    Delivery_location_latitude  DECIMAL(9,6),
    Delivery_location_longitude DECIMAL(9,6),
    Order_Date           DATE,
    Time_Ordered      TIME,
    Time_Order_picked       TIME,
    Weather_conditions      VARCHAR(30),
    Road_traffic_density      VARCHAR(20),
    Vehicle_condition  TINYINT UNSIGNED,
    Type_of_order            VARCHAR(20),
    Type_of_vehicle          VARCHAR(30),
    multiple_deliver TINYINT UNSIGNED,
    Festival          VARCHAR(10),
    City          VARCHAR(30),
    Time_taken_min       SMALLINT UNSIGNED
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Food_delivery_Dataset.csv'
INTO TABLE food_delivery
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID, Delivery_person_ID, @age, @rating,
 Restaurant_latitude, Restaurant_longitude,
 Delivery_location_latitude, Delivery_location_longitude,
 @odate, @tord, @tpick, @weather, @traffic,
 Vehicle_condition, Type_of_order, Type_of_vehicle,
 @multi, @festival, @city, Time_taken_min)
SET
 Delivery_person_Age     = NULLIF(TRIM(@age), 'NaN'),
 Delivery_person_Ratings = NULLIF(TRIM(@rating), 'NaN'),
 Order_Date              = STR_TO_DATE(TRIM(@odate), '%d-%m-%Y'),
 Time_Ordered = CASE
     WHEN TRIM(@tord) = 'NaN' THEN NULL
     WHEN TRIM(@tord) REGEXP '^[0-9]{2}:[0-9]{2}(:[0-9]{2})?$' THEN CAST(TRIM(@tord) AS TIME)
     WHEN TRIM(@tord) REGEXP '^[0-9]+([.][0-9]+)?$' THEN SEC_TO_TIME(ROUND(CAST(TRIM(@tord) AS DECIMAL(12,9)) * 86400))
 END,
 Time_Order_picked = CASE
     WHEN TRIM(@tpick) = 'NaN' THEN NULL
     WHEN TRIM(@tpick) REGEXP '^[0-9]{2}:[0-9]{2}(:[0-9]{2})?$' THEN CAST(TRIM(@tpick) AS TIME)
     WHEN TRIM(@tpick) REGEXP '^[0-9]+([.][0-9]+)?$' THEN SEC_TO_TIME(ROUND(CAST(TRIM(@tpick) AS DECIMAL(12,9)) * 86400))
 END,
 Weather_conditions   = NULLIF(TRIM(@weather), 'NaN'),
 Road_traffic_density = NULLIF(TRIM(@traffic), 'NaN'),
 multiple_deliveries  = NULLIF(TRIM(@multi), 'NaN'),
 Festival             = NULLIF(TRIM(@festival), 'NaN'),
 City                 = NULLIF(TRIM(@city), 'NaN');
 
 SELECT COUNT(*) as total_count FROM food_delivery;
 
 Select * from food_delivery;
 
--  DATA CLEANING SECTION 
-- Creating a Duplicate table for data cleaning and analysing 
 
Create table food_delivery_2
like food_delivery;

insert food_delivery_2
select * from food_delivery;

Select * from food_delivery_2;

-- 1. UNDERSTANDING THE DATASET
-- head()
Select * from food_delivery_2 Limit 10;

-- rough tail()
Select * from food_delivery_2
Order by ID Desc limit 10;

-- shape (rows)
SELECT COUNT(*) AS total_rows FROM food_delivery_2;  

-- columns and types
Describe food_delivery_2;

-- Does one row = one delivery order?
  Select COUNT(*) AS total_rows,
       COUNT(DISTINCT ID) AS distinct_ids
from food_delivery_2; 

-- Result: Based on the query above it does

-- 2. PERFORM DATA- QUALITY CHECKS
-- Calculating the missing-value counts and percentages for every column.
SELECT 'ID' AS column_name, SUM(COALESCE(TRIM(ID),'') IN ('','NaN')) AS missing_count,
       ROUND(100*SUM(COALESCE(TRIM(ID),'') IN ('','NaN'))/COUNT(*),2) AS missing_pct FROM food_delivery_2
UNION ALL SELECT 'Delivery_person_ID', SUM(COALESCE(TRIM(Delivery_person_ID),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Delivery_person_ID),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Delivery_person_Age', SUM(COALESCE(TRIM(Delivery_person_Age),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Delivery_person_Age),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Delivery_person_Ratings', SUM(COALESCE(TRIM(Delivery_person_Ratings),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Delivery_person_Ratings),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Restaurant_latitude', SUM(COALESCE(TRIM(Restaurant_latitude),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Restaurant_latitude),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Restaurant_longitude', SUM(COALESCE(TRIM(Restaurant_longitude),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Restaurant_longitude),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Delivery_location_latitude', SUM(COALESCE(TRIM(Delivery_location_latitude),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Delivery_location_latitude),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Delivery_location_longitude', SUM(COALESCE(TRIM(Delivery_location_longitude),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Delivery_location_longitude),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Order_Date', SUM(COALESCE(TRIM(Order_Date),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Order_Date),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Time_Ordered', SUM(COALESCE(TRIM(Time_Ordered),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Time_Ordered),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Time_Order_picked', SUM(COALESCE(TRIM(Time_Order_picked),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Time_Order_picked),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Weather_conditions', SUM(COALESCE(TRIM(Weather_conditions),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Weather_conditions),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Road_traffic_density', SUM(COALESCE(TRIM(Road_traffic_density),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Road_traffic_density),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Vehicle_condition', SUM(COALESCE(TRIM(Vehicle_condition),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Vehicle_condition),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Type_of_order', SUM(COALESCE(TRIM(Type_of_order),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Type_of_order),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Type_of_vehicle', SUM(COALESCE(TRIM(Type_of_vehicle),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Type_of_vehicle),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'multiple_deliveries', SUM(COALESCE(TRIM(multiple_deliveries),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(multiple_deliveries),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Festival', SUM(COALESCE(TRIM(Festival),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Festival),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'City', SUM(COALESCE(TRIM(City),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(City),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2
UNION ALL SELECT 'Time_taken_min', SUM(COALESCE(TRIM(Time_taken_min),'') IN ('','NaN')), ROUND(100*SUM(COALESCE(TRIM(Time_taken_min),'') IN ('','NaN'))/COUNT(*),2) FROM food_delivery_2;  


-- Count duplicate rows and check duplicate IDs if an ID column exists.
SELECT ID, COUNT(*) AS duplicate_row
FROM food_delivery_2
GROUP BY ID
HAVING COUNT(*) > 1;

SELECT COUNT(*) - (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM food_delivery_2) as Dup) AS exact_duplicate_rows
FROM food_delivery_2;

-- Result: No Duplicate found within the ID

-- Identify inconsistent categoy labels, such as extra spaces, capitalization differences, or spelling variations.
Select Distinct Weather_conditions from food_delivery_2;
Select Distinct Road_traffic_density from food_delivery_2;
Select Distinct Type_of_order from food_delivery_2;
Select Distinct Festival from food_delivery_2;
Select Distinct City from food_delivery_2;
Select Distinct Type_of_vehicle from food_delivery_2;

  SELECT 'Weather_conditions' AS column_name, COUNT(*) AS rows_with_extra_spaces FROM food_delivery_2 WHERE CHAR_LENGTH(Weather_conditions) <> CHAR_LENGTH(TRIM(Weather_conditions))
UNION ALL SELECT 'Road_traffic_density', COUNT(*) FROM food_delivery_2 WHERE CHAR_LENGTH(Road_traffic_density) <> CHAR_LENGTH(TRIM(Road_traffic_density))
UNION ALL SELECT 'Type_of_order', COUNT(*) FROM food_delivery_2 WHERE CHAR_LENGTH(Type_of_order) <> CHAR_LENGTH(TRIM(Type_of_order))
UNION ALL SELECT 'Type_of_vehicle', COUNT(*) FROM food_delivery_2 WHERE CHAR_LENGTH(Type_of_vehicle) <> CHAR_LENGTH(TRIM(Type_of_vehicle))
UNION ALL SELECT 'Festival', COUNT(*) FROM food_delivery_2 WHERE CHAR_LENGTH(Festival) <> CHAR_LENGTH(TRIM(Festival))
UNION ALL SELECT 'City', COUNT(*) FROM food_delivery_2 WHERE CHAR_LENGTH(City) <> CHAR_LENGTH(TRIM(City)); 

-- Result: No Extra Space and its properly capitalized

-- Inspect numeric values for negative values, unexpected ranges, and potential Outliers.
SELECT 'Delivery_person_Age' AS column_name, Delivery_person_Age AS bad_value, COUNT(*) AS total_count
FROM food_delivery_2
WHERE TRIM(Delivery_person_Age) NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' GROUP BY Delivery_person_Age
UNION ALL
SELECT 'Delivery_person_Ratings', Delivery_person_Ratings, COUNT(*)
FROM food_delivery_2
WHERE TRIM(Delivery_person_Ratings) NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' GROUP BY Delivery_person_Ratings
UNION ALL
SELECT 'Time_taken_min', Time_taken_min, COUNT(*)
FROM food_delivery_2
WHERE TRIM(Time_taken_min) NOT REGEXP '^[0-9]+$' GROUP BY Time_taken_min
UNION ALL
SELECT 'multiple_deliveries', multiple_deliveries, COUNT(*)
FROM food_delivery_2
WHERE TRIM(multiple_deliveries) NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' GROUP BY multiple_deliveries;

-- Result: No numeric values for negative values, unexpected ranges, and potential Outliers

----- Check date/time fields and measurement units where applicable.

-- Date range
SELECT MIN(Order_Date) as Start_date, MAX(Order_Date) as End_date FROM food_delivery_2;

-- Ranges for every numeric column
SELECT MIN(Delivery_person_Age) AS min_age, MAX(Delivery_person_Age) AS max_age,
       MIN(Delivery_person_Ratings) AS min_rating, MAX(Delivery_person_Ratings) AS max_rating,
       MIN(Vehicle_condition) AS min_vc, MAX(Vehicle_condition) AS max_vc,
       MIN(multiple_deliveries) AS min_md, MAX(multiple_deliveries) AS max_md,
       MIN(Time_taken_min) AS min_time, MAX(Time_taken_min) AS max_time,
       ROUND(AVG(Time_taken_min),1) AS avg_time
FROM food_delivery_2;

Select distinct Festival FROM food_delivery_2;
Describe  food_delivery_2;

--  Replacing null values within non numeric columns
Update food_delivery_2
 Set Weather_conditions = 'No Records'
 where Weather_conditions is NULL;
 
 Update food_delivery_2
 Set Road_traffic_density = 'No Records'
 where Road_traffic_density is NULL;
 
 Update food_delivery_2
 Set Festival = 'No Records'
 where Festival is NULL;
 
 Update food_delivery_2
 Set City = 'No Records'
 where City is NULL;

-- 3. CLEAN AND DOCUMENT THE DATA
-- I discovered that some of the numeric columns like Delivery person age, Delivery_person_Ratings, Time_Ordered, Road_traffic_density, multiple_deliveries have blank cell which left it
-- Missing values were the main issue, found in Delivery_person_Age, Delivery_person_Ratings, Time_Ordered, Road_traffic_density and multiple_deliveries, Restaurant_latitude, Restaurant_longitude, Delivery_location_latitude, Delivery_location_longitude, Order_Date. So i left it NULL rather than imputing, because the true values can’t be recovered from the data and filling them in would mean inventing values.
-- I replaced the empty/null  non numeric columns with 'No Records' because the true values can’t be recovered from the data 
   
  -- 4. VERIFY THE CLEANED DATASET
  Select * from  food_delivery;  -- (Raw Data)
  Select * from  food_delivery_2; -- (Clean Data)