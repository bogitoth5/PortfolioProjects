**☕ Introduction: Exploring Sales Trends at Maven Roasters**

In this exploratory data analysis (EDA), I examine sales data from Maven Roasters, a fictional café business, over a 6-month period (January–June 2023). The goal is to uncover patterns and insights that can inform business decisions and help optimize performance.

This analysis focuses on three key business questions:

**1. Sales Trends Over Time**<br/>
How have sales evolved month to month? Are there seasonal or growth patterns that stand out?

**2. Weekly Sales Patterns**<br/>
Which days of the week consistently attract the most customers and generate the highest sales and revenue? What patterns emerge in customer behavior?

**3. Product Performance & Revenue Drivers**<br/>
Which products are the most and least popular? Which ones contribute most significantly to revenue, and what does that suggest for inventory and marketing strategy?

By answering these questions, the analysis helps paint a clear picture of how the café is performing, where its strengths lie, and where there are opportunities for growth or optimization.



**📈 Sales Trend Analysis (Jan–Jun 2023)**

• To explore how Maven Roasters' sales have trended over time, transactional data from January to June 2023 was analyzed . The results show a steady upward trend in sales, with June as the best performing month.<br/>
• Customer count nearly doubled from January to June, indicating strong growth in foot traffic and engagement.<br/>
• The total number of transactions (used to count customer visits) also rose significantly.<br/>
• It’s important to note that transactions are counted at the item level — meaning that a single customer purchasing multiple items in one visit results in multiple rows with the same timestamp. This required using DISTINCT counts to accurately reflect the number of unique transactions or customers.<br/>
• The store achieved its highest profit in June, effectively doubling its profit compared to January — showing improved efficiency or higher-value sales alongside increased traffic.


number of customers:
```
SELECT month(transaction_date) as month,
  COUNT(distinct transaction_time) as total_customers
FROM coffeeshop
GROUP BY month(transaction_date)
;
```

monthly revenue:
-- similarly, the income gradually increased since january, june being the best selling month in terms of the income
```
SELECT month(transaction_date) as month, ROUND(SUM((unit_price*transaction_qty)),2) as total_income
FROM coffeeshop
GROUP BY month(transaction_date)
;
```

-- monthly profit
-- the store made the most profit in june, doubling the profit compared to january

```
SELECT month(transaction_date) as month, ROUND(SUM((unit_price*transaction_qty)),2) as total_revenue, ROUND(SUM((cs.unit_price-cc.cost)*cs.transaction_qty),1) as profit
FROM coffeeshop cs
	JOIN coffeeshop_cost cc ON cs.product_detail = cc.item
GROUP BY month(transaction_date)
;
```



**📊 Busiest Days of the Week & Customer Behavior**

To identify which days are the busiest for Maven Roasters and understand why, the following metrics were analyzed:<br/>

• Total number of sales<br/>
• Total revenue<br/>
• Average order value (AOV)<br/>
• Peak transaction hours<br/>
• Product category performance<br/>

The analysis revealed that Monday, Thursday, and Friday consistently attract the highest number of customers, and these same days also generate the most sales. This pattern suggests that customer traffic may be influenced by workweek routines, where people are more likely to grab coffee at the start and end of the workweek.

Further investigation into order values and product preferences by day helps provide additional context for these peaks.


 -- Transactions per day - monday, thursday and friday has the most customers
```
SELECT day, count(distinct transaction_time) as total_customers
FROM coffeeshop
GROUP BY Day
ORDER BY FIELD(day, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');
```

-- Sales per day - monday, thursday and friday has the most sold items
```
SELECT day, sum(transaction_qty) as total_sold 
FROM coffeeshop
GROUP BY Day
ORDER BY FIELD(day, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');
```

-- Average Order Value (AOV) Per Day
	-- Tells whether some days have fewer but larger orders
    -- The values are very close, no significant increase or drop
    -- suggesting a consistent customer spending behavior, regardless of the day
    -- A small increase on Tuesday might indicate a slightly higher spend per order (Customers buying more expensive items, midweek promotions?)
    -- Thursday and Saturday have the lowest AOV - buying cheaper or fewer items

```
SELECT 
    DAYNAME(transaction_date) AS day_of_week, 
    CONCAT(ROUND(SUM(transaction_qty * unit_price) / COUNT(DISTINCT transaction_time),2),'$') AS avg_order_value_$
FROM coffeeshop
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');
```

**🛍️ Product Performance & Revenue Contribution**

To determine which products are driving performance for Maven Roasters, I analyzed:

•Total units sold per product<br/>
•Revenue contribution per product<br/>
•Sales distribution across product categories<br/>

This analysis highlights which products are top performers, contributing a significant percentage of overall sales and revenue. For example, certain products account for a large majority (e.g., 80–90%) of total transactions, indicating strong customer preference.

On the other hand, low-performing products —those with consistently low sales and minimal revenue impact— were also identified. These insights allow for data-driven recommendations, such as:

• Doubling down on bestsellers through promotions or bundling<br/>
• Re-evaluating underperforming products, possibly through repositioning, limited-time offers, or replacement

This product-level visibility helps align inventory and marketing strategy with customer demand.

 -- the best selling categories are coffee, tea, drinking chocolate and bakery, least selling items are packaged chocolate and loose tea

best selling
```
SELECT cs.product_category, sum(transaction_qty) as total_sold, 
	ROUND(SUM((unit_price*transaction_qty)),2) as total_revenue, 
	ROUND(SUM(cs.transaction_qty *cc.cost),1) as cost, 
    ROUND(SUM((cs.unit_price-cc.cost)*cs.transaction_qty),1) as profit
FROM coffeeshop cs
	JOIN coffeeshop_cost cc ON cs.product_detail = cc.item
GROUP BY cs.product_category
ORDER BY profit desc;
```

least selling
```
SELECT cs.product_category, cs.product_detail, sum(transaction_qty) as total_sold, 
	ROUND(SUM((unit_price*transaction_qty)),2) as total_income, 
	ROUND(SUM(cs.transaction_qty *cc.cost),1) as cost, 
    ROUND(SUM((cs.unit_price-cc.cost)*cs.transaction_qty),1) as profit
FROM coffeeshop cs
	JOIN coffeeshop_cost cc ON cs.product_detail = cc.item
GROUP BY cs.product_category, cs.product_detail
ORDER BY profit
LIMIT 10;
```

Profit distribution per Category:
```
WITH CategoryProfit AS (
    SELECT 
        cs.product_category,
        SUM((cs.transaction_qty * cs.unit_price) - (cs.transaction_qty * cc.cost)) AS category_profit
    FROM coffeeshop cs
    JOIN coffeeshop_cost cc ON cs.product_detail = cc.item
    GROUP BY cs.product_category
),
TotalProfit AS (
    SELECT SUM(category_profit) AS total_profit FROM CategoryProfit
)
SELECT 
    cp.product_category,
    cp.category_profit,
    ROUND((cp.category_profit / tp.total_profit) * 100, 2) AS profit_percentage
FROM CategoryProfit cp
JOIN TotalProfit tp
ORDER BY profit_percentage DESC;
```


**📌 Summary & Recommendations**

**Steady Growth in Performance**<br/>
The café showed a consistent upward trend in both sales volume and profit from January to June 2023, with June being the peak month. This growth may be attributed to increased customer interest or effective business strategies such as promotions or seasonal offerings. It is recommended to investigate what factors contributed to this growth to replicate success in future months.

**Key Days for Sales**<br/>
Monday, Thursday, and Friday emerged as the busiest days in terms of customer volume and total sales. These high-traffic days present an opportunity to further maximize revenue through targeted campaigns, such as limited-time offers, loyalty perks, or product bundles to encourage larger basket sizes.

**Top & Underperforming Product Categories**<br/>
The best-performing product categories are coffee, tea, drinking chocolate, and bakery items, which are the main revenue drivers. On the other hand, packaged chocolate and loose tea consistently underperform. To improve performance, the business could experiment with cross-selling strategies (e.g., pairing underperforming items with popular products), or explore seasonal packaging and promotions to boost visibility and appeal.
