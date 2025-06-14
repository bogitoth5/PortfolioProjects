# ☕ Maven Roasters Sales Analysis (SQL · Excel · Power BI)

### 🔍 Explore the Analysis:
[📗 Excel Analysis](https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/excel_EDA.md)

[🔍 SQL EDA](https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/maven_rosters_sql.md) 

[📊 Power BI Dashboard](https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/maven_roasters_bi.md)

### 📌 About the project:<br/>
Transaction records for Maven Roasters, a fictitious coffee shop selling hot beverage and baked goods. Dataset includes the transaction date and timestamp along with product-level details, including unit price. Additional table was created with unit cost, in order to do profit calculations.

<ins>Key Requirements:</ins><br/>
•  Display a summary of Maven Roasters sales trend per month<br/>
•  Identify the days pf the week with the highest sales and customer number<br/>
•  Identify best and least selling products, find the product with the most revenue<br/>

<ins>Sales Trends:</ins><br/>
• Show total profit per months<br/>
• Show changes in profit each month<br/>

### 📂 About the data:

The dataset includes six months of sales data between January 2023 and June 2023, with almost 15,000 rows. Each row represents a transaction or purchasing an item from the cafe, including the quantity of purchased products, the price per unit, date and time of the transaction. To enable profit analysis, an additional table was created containing the selling price and cost of each item.

<p align="center">
  <img src="images_cafe/maven_cafe_fields1.PNG" alt="Data Types1" width="200"/><br/>
  <img src="images_cafe/maven_cafe_fields2.PNG" alt="Data Types2" width="200"/>
</p>

### 🛠 Tools & Techniques Used:

- Excel (basic analysis, pivot tables, charts)
- MySQL (data cleaning, EDA, aggregations, CTEs)
- PowerBI (interactive dashboards, DAX, measures, slicers)

### ⛔ Dataset limitations & Challenges:

• The dataset only spans January to June 2023, limiting the ability to perform a full-year or comprehensive seasonal analysis.<br/>
• Each product purchased is recorded as a separate transaction, making it challenging to accurately assess the total number of customers and their corresponding spending per visit.<br/>

### 🔍 Summary & Recommendations

**<ins>Sales Trend (Jan-Jun 2023)</ins>**

Maven Roasters showed steady growth in both sales and profit between January and June, with June being the strongest month. The cafe underperformed in the first quarter, but saw a noticeable increase starting in April. The top revenue drivers were coffee, tea, and drinking chocolate, with coffee alone contributing around 40% of the total profit. Identifying the drivers behind this upward trend could help replicate and sustain growth in the future.

<p align="center">
  <img width="1249" height="550" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/cafe2.png">
</p>
<p align="center">
Sales & KPI Dashboard - showing revenue, profit, and performance
</p>

**<ins>Customer Behavior and Product Performance</ins>**

Although overall customer traffic is relatively balanced throughout the week, Mondays, Thursdays, and Fridays stand out with the highest number of customers and total sales. Most activity happens between 8 AM and 12 PM. Sales and foot traffic gradually decline throughout the day, reaching their lowest around 8–9 PM. Based on this trend, promotions during peak hours could further boost revenue, while end-of-day deals might help increase late-hour sales. Coffee, tea, bakery items, and drinking chocolate consistently perform the best, especially during peak hours. Coffee alone contributes around 40% of the cafe’s total profit, making it a key revenue driver. However items like loose tea and branded merchandise have lower sales. A deeper analysis of their profitability can help decide whether to promote, bundle or remove these items.

<p align="center">
  <img width="1249" height="550" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/Maven%20Roasters/images_cafe/cafe1.png">
</p>
<p align="center">
Customer Behavior Dashboard - analyzing sales per days of the week and product categories
</p>
