Questions:
-- How have Maven Roasters sales trended over time?

-- Which days of the week tend to be busiest, and why do you think that's the case?

-- Which products are sold most and least often? Which drive the most revenue for the business?


-- How have Maven Roasters sales trended over time?
    -- telling the story of what happened from 2023 January to 2023 June in Maven Roasters
    -- sales increased gradually from january to june, june being the best selling month in terms of number of transactions which is equal to the total number of customers
    -- the number of customers almost doubled in june compared to january
    -- we should consider that if customer purchased various items in a transaction, that is counted more than one transaction with the same time label - DICTINCT count - this is a data challenge



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


-- Which days of the week tend to be busiest, and why do you think that's the case?

	-- data to analyze:
		-- Total Sales Per Day of the Week
        -- Total Revenue Per Day of the Week
        -- Average Order Value (AOV) Per Day
        -- Peak Hours on Busy Days
        -- Product Category Performance by Day
	-- monday, thursday and friday has the most customers and the same days has the most sales


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

-- Which products are sold most and least often? Which drive the most revenue for the business?
	-- which product makes up x% of sales. which product if responsible for eg 90% of the sales?
	-- Measuring how each product is performing, and give recommendations of what to do with them

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

ADDITIONAL QUERIES:
total profit:

```
SELECT 
   ROUND(SUM((cs.transaction_qty * cs.unit_price) - (cs.transaction_qty * cc.cost)),1) AS total_profit
FROM coffeeshop cs
	JOIN coffeeshop_cost cc ON cs.product_detail = cc.item;
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

