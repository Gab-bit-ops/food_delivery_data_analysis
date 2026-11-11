# Food Delivery Data Analysis
## Week 1: Dataset Understanding & Cleaning | Kagnus Data Analytics Internship, Project 1
Author: Samuel Gabriel Ojodale 
________________________________________

# Project Objective
I'm working as a junior data analyst supporting a food-delivery operations team. The goal of Week 1 is simple: understand the dataset, find its data-quality issues, clean what needs cleaning (and explain why), and leave behind a reliable dataset that the later weeks can build on.
This week is only about understanding and cleaning. Exploratory analysis, charts, business findings and the final report belong to the later project weeks.
Dataset Source: https://drive.google.com/file/d/1O9WYS92iJPZoC6skyYlpcdP8Kre7eW6z/view?usp=sharing

•	Dataset: Food Delivery Dataset (Food_delivery_Dataset.csv)
•	Source: 
•	Size: 45,584 rows and 20 columns
•	One row = one delivery order. Every ID is unique, so no order appears twice.
•	Coverage: orders placed between 11 Feb 2022 and 6 Apr 2022
•	Raw file: the original CSV is kept unchanged. It is only included in data/raw/ if its license allows redistribution; otherwise, see data/raw/README.md for access instructions.
Columns at a glance
•	ID, Delivery_person_ID: order and delivery-person identifiers
•	Delivery_person_Age, Delivery_person_Ratings: details about the delivery person
•	Restaurant_latitude, Restaurant_longitude, Delivery_location_latitude, Delivery_location_longitude: pickup and drop-off coordinates
•	Order_Date, Time_Orderd, Time_Order_picked: when the order was placed and picked up
•	Weather_conditions, Road_traffic_density, Festival, City: conditions around the delivery
•	Vehicle_condition, Type_of_vehicle, Type_of_order: vehicle and order details
•	multiple_deliveries: number of other deliveries being handled alongside the order
•	Time_taken (min): delivery time in minutes (renamed Time_taken_min in the database)

# Tools Used
•	MySQL 8.0 for all data loading, checking and cleaning
•	MySQL Workbench as the SQL client and for exporting the cleaned table to CSV
•	GitHub for version control and submission
No Python packages are needed to run this project, since the whole workflow is in SQL (approved by my mentor).

# What each file does
•	sql/Food_Delivery_Datacleaning.sql: the main deliverable. It creates the database and table, loads the CSV, makes a working copy, runs the data-quality checks, and applies the cleaning rules. Comments inside the script explain what each section checks and what I found.
•	data/processed/cleaned_food_delivery.csv: the cleaned table exported from MySQL.
•	data/raw/README.md: documents the raw dataset's source and access instructions.
•	requirements.txt: states that no external Python packages are used.

# How to Run the SQL
1.	Install MySQL 8.0 and MySQL Workbench, and connect to your local server.
2.	Copy Food_delivery_Dataset.csv into the folder MySQL allows file loading from. To find it, run SHOW VARIABLES LIKE 'secure_file_priv';. On my machine it was C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\.
3.	Open sql/Food_Delivery_Datacleaning.sql in Workbench.
4.	If your folder is different, edit the file path in the LOAD DATA INFILE statement. Use forward slashes (/) in the path.
5.	Run the script from top to bottom, section by section, reading the comments as you go.
6.	Check that SELECT COUNT(*) FROM food_delivery; returns 45584.
7.	To export the cleaned data: right-click food_delivery_2 in Workbench, choose Table Data Export Wizard, pick CSV, and save it as cleaned_food_delivery.csv.
8.	To verify the export, import the CSV into a test table and confirm the row count matches.
   
# How the tables are organised
•	food_delivery: the data as loaded from the CSV (text NaN converted to NULL, proper data types applied). I never edit this table.
•	food_delivery_2: a copy of the loaded table where the cleaning happens.

# Week 1 Summary
What I checked
•	Row and column counts, data types, and whether each ID is unique
•	Missing values for every column (counts and percentages)
•	Duplicate rows and duplicate IDs
•	Category labels for extra spaces, capitalization and spelling variations
•	Numeric ranges, date range, and time fields

# What I found
•	No duplicates. All 45,584 IDs are unique and there are no fully duplicated rows.
•	Category labels are consistent. No extra spaces or capitalization problems.
•	Missing values were the main issue. The raw file stores them as the text NaN: 
o	Delivery_person_Age: 1,854 rows
o	Delivery_person_Ratings: 1,908 rows
o	Time_Orderd: 1,731 rows
o	multiple_deliveries: 993 rows
o	Weather_conditions: 616 rows
o	Road_traffic_density: 601 rows
o	Festival: 228 rows
o	City: 1,200 rows
•	Time columns were not in one format. Some order and pickup times are stored as fractions of a day (for example 0.833333333, which is 20:00:00) and some pickup times run past midnight (like 24:05:00). The load script converts them to proper TIME values.
•	Possible outliers. Ages run from 15 to 50, with 38 rows under 18, and ratings run from 1.0 to 6.0, with 53 rows above 5. These are kept and flagged for review, not removed.

# What I did
•	Converted NaN text to NULL while loading, and applied proper data types (DATE, TIME, DECIMAL and integer types).
•	Left missing numeric values (Delivery_person_Age, Delivery_person_Ratings, Time_Ordered, multiple_deliveries) as NULL and did not impute them.
•	Replaced missing values in the category columns (Weather_conditions, Road_traffic_density, Festival, City) with the label No Records.
•	Removed no rows. The before and after row counts are both 45,584.

# Assumptions
•	A row represents one delivery order, based on the unique ID column.
•	Dates are in DD-MM-YYYY format in the raw file.
•	Day-fraction values in the time columns are fractions of 24 hours.
•	Time_taken_min is in minutes.

# Limitations
•	Missing values were not imputed. The true values can't be recovered from the data (for example, the same Delivery_person_ID shows different ages across orders, so the ID can't be used to fill gaps). Filling them with averages would mean inventing data. This leaves gaps that later analysis has to handle, although SQL functions like AVG() and COUNT() skip NULLs automatically.
•	No Records is a label, not a real value. It keeps rows with missing categories visible, but it counts as its own category in any grouping, so it should be reported separately.
•	Outliers are flagged, not corrected. Ratings above 5 and ages under 18 need to be investigated before the analysis weeks, and I don't know the cause yet.
•	Times past 24:00:00 are kept as they appear. They likely represent orders picked up just after midnight, but this is an assumption.
•	Source spelling is preserved. The City value Metropolitian (sic) is used consistently in the raw data, so I left it as is.
•	The workflow is SQL-only, so there is no Jupyter notebook for this week.


