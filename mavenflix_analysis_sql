MavenFlix - Exploratory Data Analysis in SQL

Questions:
-- How have MavenFlix subscriptions trended over time?

-- What percentage of customers have subscribed for 5 months or more?

-----------------------------------------------------------------------------------------------

-- The number of new subscriptions was highest at the beginning of 2023 and during the summer months, with July 2023 reaching the all-time peak.
	- The lowest subscription numbers were recorded at the end of 2022.
	- A notable decline in subscriptions occurred at the end of 2022 and again in spring 2023, with a sharp drop in August 2023 compared to July.
	- Cancellations gradually increased throughout 2023.
  


SELECT YEAR(created_date), MONTH(created_date), COUNT(created_date), COUNT(created_date)- LAG(COUNT(created_date)) OVER () as difference
FROM mavenflix
WHERE canceled_date IS NOT NULL
GROUP BY YEAR(created_date), MONTH(created_date)
ORDER BY YEAR(created_date), MONTH(created_date);

SELECT YEAR(canceled_date), MONTH(canceled_date), COUNT(canceled_date), COUNT(canceled_date)- LAG(COUNT(canceled_date)) OVER () as difference
FROM mavenflix
WHERE canceled_date IS NOT NULL
GROUP BY YEAR(canceled_date), MONTH(canceled_date)
ORDER BY YEAR(canceled_date), MONTH(canceled_date);

-----------------------------------------------------------------------------------------------

-- What percentage of customers have subscribed for 5 months or more?

-- This query determines the subscription duration based on cancellation status and timing, and calculates percentage of users who subscribed to MavenFlix for 5 or more months:
	-If a user has no cancellation date before September 1, 2023 (the day after the analysis period ends), they are considered active, and the difference between the created date and September 1, 2023, is calculated.
	-If a user canceled on the same calendar day as their signup (even in a different month), one month is added to their subscription length.
	-If a user canceled after at least one full billing cycle, the difference between the created and canceled dates is calculated.
	-If a user canceled within less than a month, their subscription length is counted as one month.
	-If a user signed up on August 31, 2023, their subscription is considered to have lasted one month.

 WITH length AS (
 SELECT created_date, canceled_date, 
    CASE 
        WHEN canceled_date IS NULL THEN 
            CEILING(ROUND(DATEDIFF('2023-09-01', created_date)/ 30,2))
        WHEN DAY(created_date) = DAY(canceled_date) THEN 
            CEILING(ROUND(ABS(DATEDIFF(created_date, canceled_date))/ 30, 1))+1
        WHEN canceled_date > LAST_DAY(created_date) THEN 
            CEILING(ROUND(ABS(DATEDIFF(created_date, canceled_date))/ 30, 1))
        WHEN canceled_date <= LAST_DAY(created_date) THEN 1
        WHEN canceled_date IS NULL AND created_date = '2023-08-31' THEN 1
        ELSE 'NA'
    END AS subs_length
FROM mavenflix
)
SELECT 
    COUNT(CASE WHEN subs_length >= 5 THEN 1 END) * 100.0 / COUNT(*) AS percentage_users
FROM length;

-----------------------------------------------------------------------------------------------

Additional Queries:

-- Number of new users
	- The highest number of new users registered in February, May, and July 2023. It may be worth investigating whether promotions or special offers contributed to these spikes.
	- The lowest number of new users was recorded in October–November 2022, which aligns with expected seasonal trends before the holiday season.


SELECT YEAR(created_date) as year, MONTH(created_date) as month, COUNT(created_date) as total_new, COUNT(created_date)- LAG(COUNT(created_date)) OVER () as difference
FROM mavenflix
WHERE NOT (YEAR(created_date) = 2023 AND MONTH(created_date) = 9)
GROUP BY YEAR(created_date), MONTH(created_date);

------------------------------------

-- Number of reactivated users
	- There was an increase in the number of reactivated users from May to August 2023, with August seeing the highest number of returning subscribers.
	- It would be valuable to investigate whether special promotions targeted at former users or the release of highly anticipated content influenced these trends. 


WITH reactivated AS (
SELECT *, 
	ROW_NUMBER() OVER (partition by customer_id) as row_num
FROM mavenflix)
SELECT 
	YEAR(created_date) AS reactivation_year,
    MONTH(created_date) AS reactivation_month,
    COUNT(*) AS reactivated_user_count
FROM reactivated
WHERE row_num > 1
GROUP BY reactivation_year, reactivation_month
ORDER BY reactivation_year, reactivation_month;

------------------------------------

-- Churned Users (Canceled Subscriptions)
	- The number of canceled users has been increasing since October 2022, with the lowest churn rate in September 2022, followed by a steady rise until August 2023. There was a slight decrease in cancellations in April and July 2023.
	- The significant increase in churned users is a concern. It may be helpful to analyze policy changes that occurred between October 2022 and 2023. Since the subscription cost remained unchanged, other factors—such as a shift in content selection—could have influenced cancellations

SELECT YEAR(canceled_date) as year, MONTH(canceled_date) as month, COUNT(canceled_date) total_canceled, COUNT(canceled_date)-LAG(COUNT(canceled_date)) OVER (ORDER BY year(canceled_date), month(canceled_date)) as difference
FROM mavenflix
WHERE NOT (YEAR(canceled_date) = 2023 AND MONTH(canceled_date) = 9)
GROUP BY YEAR(canceled_date), MONTH(canceled_date)
ORDER BY YEAR(canceled_date), MONTH(canceled_date);

------------------------------------

-- Subscription Duration Before Cancellation
	- The majority of users cancel within 1 to 4 months of subscribing.
	- Understanding the reasons behind early cancellations could help improve retention. Offering special rewards or incentives for long-term subscribers might encourage users to stay subscribed for a longer period.

WITH month_count as (
with canceled_users as (
	SELECT *, 
	TIMESTAMPDIFF(MONTH, created_date, canceled_date) 
        + CASE 
            WHEN DAY(canceled_date) >= DAY(created_date) THEN 1 
            ELSE 1 
          END AS months_sub
FROM mavenflix
WHERE canceled_date is not null)
SELECT *, CASE
	WHEN months_sub <= 1 THEN 1
    WHEN months_sub > 1 THEN CEILING(months_sub)
    ELSE months_sub
    END as counting_months
FROM canceled_users)
SELECT round((counting_months),0) as months_before_cancel, COUNT(*) as canceled_users
FROM month_count
GROUP BY counting_months
ORDER BY months_before_cancel;
