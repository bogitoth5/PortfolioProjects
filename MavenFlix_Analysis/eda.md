# 🎬**MavenFlix – Exploratory Data Analysis in SQL** 
 
## 🧾 **Project Overview**

This project explores user subscription behavior using SQL, based on a fictional dataset from a streaming service, MavenFlix. The primary objectives were:

- Analyze trends in new subscriptions and cancellations

- Measure user retention and identify common churn periods

- Explore reactivation behavior among returning users

- The insights were generated through SQL queries using CTEs, window functions, and date logic.


## ❓ **Main Business Questions**

- How have MavenFlix subscriptions and cancellations changed over time?

- What percentage of users stay subscribed for 5 months or more?


## 🛠 **Tools & Techniques**

SQL Features Used: CTEs, LAG(), ROW_NUMBER(), CASE WHEN, DATEDIFF(), CEILING(), TIMESTAMPDIFF()

Analysis Focus: Trend analysis, churn detection, retention rate, customer behavior segmentation

## 📊 **Subscription Trends Over Time**

**Insight:** New subscriptions peaked in early and mid-2023, with July reaching an all-time high. The lowest subscription numbers were recorded at the end of 2022. A notable decline in subscriptions occurred at the end of 2022 and again in spring 2023, with a sharp drop in August 2023 compared to July.

```SELECT YEAR(created_date), MONTH(created_date), COUNT(created_date), COUNT(created_date)- LAG(COUNT(created_date)) OVER () as difference
FROM mavenflix
WHERE canceled_date IS NOT NULL
GROUP BY YEAR(created_date), MONTH(created_date)
ORDER BY YEAR(created_date), MONTH(created_date);
```


## 📉 **Cancellation Trends**

Insight: Cancellations steadily increased from October 2022 through August 2023. A slight drop occurred in April and July 2023. The lowest cancellation count was in September 2022.

```SELECT YEAR(canceled_date), MONTH(canceled_date), COUNT(canceled_date), COUNT(canceled_date)- LAG(COUNT(canceled_date)) OVER () as difference
FROM mavenflix
WHERE canceled_date IS NOT NULL
GROUP BY YEAR(canceled_date), MONTH(canceled_date)
ORDER BY YEAR(canceled_date), MONTH(canceled_date);
```

## 📌 **Retention – Percentage of Users Who Stayed ≥ 5 Months**

This query calculates the share of users who stayed with MavenFlix for 5 or more months based on their subscription and cancellation dates.

How subscription length is calculated:
- If a user has no cancellation date before September 1, 2023 (the day after the analysis period ends), they are considered active, and the duration is calculated from created_date to September 1, 2023.
- If a user canceled on the same calendar day as their signup (even in a different month), one extra month is added to their subscription length.
- If a user canceled after at least one full billing cycle, the difference between created_date and canceled_date is used.
- If a user canceled within less than a month, their subscription is counted as one month.
- If a user signed up on August 31, 2023, the subscription is counted as one month.

```
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
```

# ➕ **Additional Queries**

## 🔄 **Reactivated Users**

Insight: Reactivations increased from May to August 2023, peaking in August. This may indicate successful promotional efforts or new content releases.

```
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
```

## 🚪 **When Do Users Cancel?**

Insight: Most users cancel within the first 1–4 months. Exploring early-stage user experience and retention strategies could improve long-term engagement.

```
WITH month_count as (
SELECT 
    customer_id, created_date, canceled_date,
    CASE
        WHEN TIMESTAMPDIFF(MONTH, created_date, canceled_date) + 1 = 1 THEN 1
        ELSE TIMESTAMPDIFF(MONTH, created_date, canceled_date) + 1
    END AS counting_months
FROM mavenflix
WHERE canceled_date IS NOT NULL)
SELECT round((counting_months),0) as months_before_cancel, COUNT(*) as canceled_users
FROM month_count
GROUP BY counting_months
ORDER BY months_before_cancel;
```

## 💡 **Next Steps**

Correlate subscription spikes with promotional campaigns or show releases

Segment churned users by content watched or usage pattern

Build a dashboard in Tableau or Power BI to visualize retention trends
