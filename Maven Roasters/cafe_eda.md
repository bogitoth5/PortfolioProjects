# **Maven Roasters - Exploratory Data Analysis in MySQL**

### 📖 Table of Contents
- [Sales Trend](#-sales-trend-analysis-january-to-june-2023)
- [Customer Analysis](#-number-of-customers-over-time)
- [Sales Trend](#-sales-revenue-trends)
- [Monthly Profit](#-monthly-profit)
- [DAily Sales](#-daily-sales-analysis)
- [Business REcommendations](#-business-implications)

## 📈 **Sales Trend Analysis: January to June 2023**

🔍 **Objective**

To understand how sales at Maven Roasters have evolved over time, customer transaction data from January to June 2023 was analyzed. The key focus areas include customer volume, total income, and profit trends.


### 📈 **How Have Maven Roasters’ Sales Trended Over Time?**

The goal is to understand how sales have changed from January to June 2023 at Maven Roasters. The key focus areas include:

- How many customers came each month

- How much income the cafe made

- How much profit they earned



### 🧍‍♂️🧍‍♀️ **Number of Customers Over Time**

The number of customers visiting the cafe each month was counted based on the time of their transactions. The number of customers increased steadily from January to June with June being the busiest month with the highest number of unique transactions — almost twice as many as January. This shows the café was getting more and more popular over time.

```
SELECT month(transaction_date) as month, COUNT(distinct transaction_time) as total_customers
FROM coffeeshop
GROUP BY month(transaction_date);
```

<p align="center">
  <img width="140" height="123" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/customer_count.PNG">
</p>

⚠️ **Note:** </br>
Due to data structure, a single transaction involving multiple item types may be recorded with multiple entries sharing the same timestamp, but different transaction ID. To address this, a DISTINCT count of transaction_time had to be used to estimate customer count. This is a known data granularity challenge.

### 💰 **Sales Revenue Trends**

Monthly income was calculated based on unit price and quantity sold. Results showed consistent growth over the period:

Total income increased month over month, with June generating the highest revenue.

```
SELECT month(transaction_date) as month, ROUND(SUM((unit_price*transaction_qty)),2) as total_income
FROM coffeeshop
GROUP BY month(transaction_date);
```

<p align="center">
  <img width="125" height="124" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/total%20income.PNG">
</p>

### 📊 **Monthly Profit**
To calculate profit, the sales data (coffeeshop) was joined with product cost data (coffeeshop_cost). Profit is the difference between sale price and cost per unit, multiplied by quantity sold.
Just like income and customer count, June was the most profitable month, with profit nearly doubling compared to January.

```
SELECT month(transaction_date) as month, ROUND(SUM((unit_price*transaction_qty)),2) as total_income, ROUND(SUM((cs.unit_price-cc.cost)*cs.transaction_qty),1) as profit
FROM coffeeshop cs
	JOIN coffeeshop_cost cc ON cs.product_detail = cc.item
GROUP BY month(transaction_date);
```

<p align="center">
  <img width="191" height="123" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/total%20profit.PNG">
</p>



### 📌 **Key Insights**
- Sales, customer count, and profit all show a clear upward trend from January to June.

- June was the peak month in terms of both revenue and profitability.




# **📊 Daily Sales Analysis**

✅ **Goal**
The aim of this analysis was to identify which days bring in the most customers and revenue for Maven Roasters and uncover why that might be the case.

### 🧮 **Data Used**

To answer this, I analyzed the following metrics from the sales data:

- Total number of customers per day

- Total sales volume (items sold)

- Total revenue and profit per day

- Average Order Value (AOV) per day

- Best- and worst-selling products and product categories by day

- Product category contributions to AOV

### 📈 **Key Insights**

**Busiest Days:**
Monday, Thursday, and Friday had the highest customer count and the most items sold. These were also the days with the highest revenue and profit.

```
SELECT day, count(distinct transaction_time) as total_customers
FROM coffeeshop
GROUP BY Day
ORDER BY FIELD(day, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');

-- Sales per day - monday, thursday and friday has the most sold items
SELECT day, sum(transaction_qty) as total_sold 
FROM coffeeshop
GROUP BY Day
ORDER BY FIELD(day, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');
```

<p align="center">
  <img width="205" height="143" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/customers%20per%20day.PNG">
</p>

**Customer Spending Patterns:**
The Average Order Value (AOV) was fairly consistent throughout the week. Tuesday had a small increase in AOV, suggesting customers might buy slightly more expensive items or more items overall. Thursday and Saturday had the lowest AOV, likely due to fewer high-value purchases.

**Product Performance by Day:**

Top-selling items were almost always drinks like coffee, tea or drinking chocolate. Coffee beans and branded products, while not best-sellers in quantity, contributed significantly to higher AOV when purchased. These high-value items sold best on Tuesdays, which may explain the AOV increase that day. On Thursdays and Saturdays, fewer premium items were sold, leading to a dip in AOV.

```
WITH RankedSales AS (
    SELECT 
        day, 
        product_detail, product_category, 
        SUM(transaction_qty) AS total_sold,
        RANK() OVER (PARTITION BY day ORDER BY SUM(transaction_qty) DESC) AS rank_position
    FROM coffeeshop
    GROUP BY day, product_detail, product_category
)
SELECT *
FROM RankedSales
WHERE rank_position <= 2
ORDER BY FIELD(day, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'), rank_position;
```

<p align="center">
  <img width="519 height="276" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/ranked%20sales.PNG">
</p>

### 💡 **Business Implications**

Weekday Strategy: The start and end of the workweek are peak business days. Staff and stock planning should reflect this.

Revenue Boost Opportunity:

Promote high-value items like coffee beans and branded goods on slower days like Thursday and Saturday.
Example: “Weekend Special: Buy Beans, Get 10% Off a Drink”

Offer Tuesday loyalty perks to reward and encourage bigger purchases.
Example: “Buy a Large Drink, Get a Free Add-On”
