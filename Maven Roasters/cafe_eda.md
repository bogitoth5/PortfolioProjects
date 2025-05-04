# **Maven Roasters - Exploratory Data Analysis in MySQL**

## 📈 **Sales Trend Analysis: January to June 2023 – Maven Roasters**

🔍 Objective

To understand how sales at Maven Roasters have evolved over time, customer transaction data from January to June 2023 was analyzed. The key focus areas include customer volume, total income, and profit trends.

📈 How Have Maven Roasters’ Sales Trended Over Time?

The goal is to understand how sales have changed from January to June 2023 at Maven Roasters. The key focus areas include:

- How many customers came each month

- How much income the cafe made

- How much profit they earned


🧍‍♂️🧍‍♀️ Number of Customers Over Time

The number of customers visiting the cafe each month was counted based on the time of their transactions. The number of customers increased steadily from January to June with June being the busiest month with the highest number of unique transactions — almost twice as many as January. This shows the café was getting more and more popular over time.

⚠️ Note: </br>
Due to data structure, a single transaction involving multiple item types may be recorded with multiple entries sharing the same timestamp, but different transaction ID. To address this, a DISTINCT count of transaction_time had to be used to estimate customer count. This is a known data granularity challenge.

```
SELECT month(transaction_date) as month, COUNT(distinct transaction_time) as total_customers
FROM coffeeshop
GROUP BY month(transaction_date);

```

💰 Sales Revenue Trends

 Monthly income was calculated based on unit price and quantity sold. Results showed consistent growth over the period:

Total income increased month over month, with June generating the highest revenue.

```
SELECT month(transaction_date) as month, ROUND(SUM((unit_price*transaction_qty)),2) as total_income
FROM coffeeshop
GROUP BY month(transaction_date);
```


📊 Monthly Profit
To calculate profit, the sales data (coffeeshop) was joined with product cost data (coffeeshop_cost). Profit is the difference between sale price and cost per unit, multiplied by quantity sold.
Just like income and customer count, June was the most profitable month, with profit nearly doubling compared to January.


📌 Key Insights
- Sales, customer count, and profit all show a clear upward trend from January to June.

- June was the peak month in terms of both revenue and profitability.

