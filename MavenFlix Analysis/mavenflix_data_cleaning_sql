MavenFlix - Data Cleaning in SQL

QUERIES USED: UPDATE, ALTER, Window function (Row number)

STEPS:
1. Cahnged blanks to NULL
2. Modified data types to the correct type
3. Search for and removed duplicates
4. Deleted lines where created date was in 2023 September, since I only wanted to analyze the data until 8/31/2023.
5. To accurately reflect the dataset's status as of 2023-08-31, the canceled_date field was set to NULL for all users who canceled after this date.

--------------------------------------------------------------------------------------------------------------------------

ALTER TABLE mavenflix RENAME COLUMN `ď»żcustomer_id` TO `customer_ID`;

UPDATE mavenflix
set canceled_date = null
where canceled_date = '';

SELECT * 
FROM mavenflix
where canceled_date = '';

ALTER TABLE mavenflix 
MODIFY `canceled_date` date;

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

DELETE FROM mavenflix
WHERE (YEAR(created_date) = 2023 AND MONTH(created_date) = 9);

UPDATE mavenflix
set canceled_date = null
where canceled_date >= '2023-09-01';
