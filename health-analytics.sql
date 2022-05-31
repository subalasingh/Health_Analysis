------------------------------
--Health Analysis Case study--
------------------------------

--Author: Subala singh
--Date: 31/05/2022 
--Tool used: Postgre SQL Server

------------------------
--CASE STUDY QUESTIONS--
------------------------

-- 1. How many unique users exist in the logs dataset?
SELECT COUNT (DISTINCT id)
FROM health.user_logs;

-- Result:
+──────────+
|count     |
+──────────+
|554       |
+──────────+

-- For question 2-8, I created a temporary table:
  -- > Step 1: Firstly, I ran a DROP TABLE IF EXISTS statement to clear out any previously created tables:
  DROP TABLE IF EXISTS user_measure_count;
  
  -- > Step 2: Next, I created a new temporary table using the results of the query below:
  
  CREATE TEMP TABLE user_measure_count AS
  SELECT 
    id,
    COUNT(*) AS measure_count,
    COUNT (DISTINCT measure) AS unique_measures
  FROM health.user_logs
  GROUP BY 1;


-- 2. How many total measurements do we have per user on average?
SELECT
  ROUND (AVG(measure_count), 2) AS mean_value
FROM user_measure_count;

--Result:
+────────────+
|mean_value  |
+────────────+
|79.23       |
+────────────+

-- 3. What about the median number of measurements per user?
SELECT 
   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_count) AS median_value 
FROM user_measure_count;

--Result:
+─────────────+
|median_value |
+─────────────+
|2            |
+─────────────+

-- 4. How many users have 3 or more measurements?
SELECT COUNT(*)
FROM user_measure_count
WHERE measure_count >= 3;

--Result:
+────────+
|count   |
+────────+
|209     |
+────────+

-- 5. How many users have 1,000 or more measurements?
SELECT COUNT(*)
FROM user_measure_count
WHERE measure_count >= 1000;

--Result:
+───────+
|count  |
+───────+
|5      |
+───────+

-- 6. Have logged blood glucose measurements?
SELECT 
  COUNT(DISTINCT id)
FROM health.user_logs
WHERE measure = 'blood_glucose';

--Result:
+───────+
|count  |
+───────+
|325    |
+───────+
