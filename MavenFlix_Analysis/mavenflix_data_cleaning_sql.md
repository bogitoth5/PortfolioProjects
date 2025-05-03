# 🧼 **MavenFlix – Data Cleaning in SQL**
## 🛠 **Tools & Techniques Used**

- UPDATE, ALTER TABLE, DELETE
- Window Function: ROW_NUMBER()
- Data type conversion
- Duplicate detection and removal
- Data range filtering



## 🧹 **Cleaning Steps Overview**

**1. Replaced Blank Values with NULLs**</br>

Empty strings in the canceled_date field were standardized by converting them to NULL.

```
SELECT * 
FROM mavenflix
where canceled_date = '';

UPDATE mavenflix
set canceled_date = null
where canceled_date = '';
```

**2. Renamed Incorrect Column Encoding**</br>

Resolved encoding issue in the column name.
```
ALTER TABLE mavenflix
RENAME COLUMN `ď»żcustomer_id` TO `customer_ID`;
```

**3. Corrected Data Types**</br>

Ensured the canceled_date column used the correct DATE data type.
```
ALTER TABLE mavenflix 
MODIFY `canceled_date` date;
```

**4. Identified and Removed Duplicate Rows**</br>

Used a ROW_NUMBER() window function to find duplicates based on the same customer_id, created_date, and canceled_date. Then deleted the extras.

```
SELECT *, 
	ROW_NUMBER() OVER (partition by customer_id, created_date, canceled_date) as row_num
FROM mavenflix;


WITH row_check as (
SELECT *, 
	ROW_NUMBER() OVER (partition by customer_id, created_date, canceled_date) as row_num
FROM mavenflix)
SELECT *
FROM row_check
where row_num > 1;


DELETE FROM mavenflix
WHERE customer_id IN (
	SELECT customer_id
    FROM (
	SELECT customer_id, 
	ROW_NUMBER() OVER (partition by customer_id, created_date) as row_num
	FROM mavenflix) AS DUPLICATE
where row_num > 1);
```

**5. Filtered Out Unwanted Date Range**</br>

Removed records created after August 31, 2023, to focus the analysis on data from January to August 2023 only, since data was onlz available until mid/September.

```
DELETE FROM mavenflix
WHERE (YEAR(created_date) = 2023 AND MONTH(created_date) = 9);
```

**6. Adjusted Cancellation Dates for Post-Analysis Period**</br>

Set canceled_date to NULL for users who canceled after the analysis period (after 2023-08-31), to avoid skewing the active/inactive user metrics.

```
UPDATE mavenflix
set canceled_date = null
where canceled_date >= '2023-09-01';
```

✅ **Final Notes**
- These cleaning steps ensured the dataset was:
- Accurate and consistent
- Aligned with the defined analysis period
- Free from duplicate or irrelevant records




