# 🎬**MavenFlix – Exploratory Data Analysis in SQL** 
 
## 🧾 **Project Overview**

This project explores user subscription behavior using SQL, based on a fictional dataset from a streaming service, MavenFlix. The primary objectives were:

Analyze trends in new subscriptions and cancellations

Measure user retention and identify common churn periods

Explore reactivation behavior among returning users

The insights were generated through SQL queries using CTEs, window functions, and date logic.

## ❓ **Main Business Questions**

How have MavenFlix subscriptions and cancellations changed over time?

What percentage of users stay subscribed for 5 months or more?

When do users typically cancel their subscription?

Are users returning to the platform, and if so, when?

## 📊 **Subscription Trends Over Time**

Insight: New subscriptions peaked in early and mid-2023, with July reaching an all-time high. Subscription rates declined sharply in August. The lowest new user counts were in late 2022.

## 📉 **Cancellation Trends**

Insight: Cancellations steadily increased from October 2022 through August 2023. A slight drop occurred in April and July 2023. The lowest cancellation count was in September 2022.

## 📌 **Retention – Percentage of Users Who Stayed ≥ 5 Months**

Insight: This query calculates the share of users who stayed with MavenFlix for 5 or more months based on their subscription and cancellation dates.

## 🔄 **Reactivated Users**

Insight: Reactivations increased from May to August 2023, peaking in August. This may indicate successful promotional efforts or new content releases.

## 🚪 **When Do Users Cancel?**

Insight: Most users cancel within the first 1–4 months. Exploring early-stage user experience and retention strategies could improve long-term engagement.

## 🛠 **Tools & Techniques**

SQL Features Used: CTEs, LAG(), ROW_NUMBER(), CASE WHEN, DATEDIFF(), CEILING(), TIMESTAMPDIFF()

Database: MySQL

Analysis Focus: Trend analysis, churn detection, retention rate, customer behavior segmentation

## 💡 **Next Steps**

Correlate subscription spikes with promotional campaigns or show releases

Segment churned users by content watched or usage pattern

Build a dashboard in Tableau or Power BI to visualize retention trends
