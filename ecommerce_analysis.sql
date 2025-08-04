-- 📊 PROJECT: E-commerce Sales Data Analysis using PostgreSQL

-- 🎯 OBJECTIVE:
-- Analyze sales transactions to generate insights about product, region, customer, and time-based performance.

-- 🛠️ TOOLS USED:
-- PostgreSQL, pgAdmin, Excel (for import), SQL

-- 📁 TABLE USED: ecommerce_sales

-- 🔍 COLUMNS:
-- order_id, order_date, ship_date, ship_mode, customer_id, customer_name,
-- segment, country, city, state, postal_code, region, product_id,
-- category, sub_category, product_name, sales, quantity, discount, profit
CREATE DATABASE ecommerce_analysis;

DROP TABLE IF EXISTS ecommerce_sales;

CREATE TABLE ecommerce_sales
             (
              order_id VARCHAR(20),
			  order_date DATE,
			  order_ship DATE,
			  ship_mode VARCHAR(50),
			  customer_id VARCHAR(20),
			  customer_name VARCHAR(100),
			  segment VARCHAR(50),
			  country VARCHAR(50),
			  city VARCHAR(50),
			  state VARCHAR(50),
			  postal_code VARCHAR(20),
			  region VARCHAR(50),
			  product_id VARCHAR(20),
			  category VARCHAR(50),
			  sub_category VARCHAR(50),
			  product_name VARCHAR(50),
			  sales NUMERIC,
			  quantity INT,
			  discount NUMERIC,
			  profit NUMERIC 
			 );
----changing data type fro specific column
ALTER TABLE ecommerce_sales
ALTER COLUMN product_name TYPE TEXT;

SELECT * FROM ecommerce_sales;

----column name and type
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'ecommerce_sales';


----preview of first 10 rows
SELECT * FROM ecommerce_sales LIMIT 10;

----count of rows
SELECT COUNT(*) FROM ecommerce_sales;

----check null values
SELECT * FROM ecommerce_sales
WHERE 
     order_id IS NULL OR 
	 order_date IS NULL OR 
	 order_ship IS NULL OR
	 ship_mode IS NULL OR
	 customer_id IS NULL OR
	 customer_name IS NULL OR
	 segment IS NULL OR
	 country IS NULL OR
	 city IS NULL OR
	 state IS NULL OR
	 postal_code IS NULL OR
	 region IS NULL OR
	 product_id IS NULL OR
	 category IS NULL OR
	 sub_category IS NULL OR
	 product_name IS NULL OR
	 sales IS NULL OR
	 quantity IS NULL OR
	 discount IS NULL OR
	 profit IS NULL ;

----delete null is any 
DELETE FROM ecommerce_sales
WHERE 
     order_id IS NULL OR 
	 order_date IS NULL OR 
	 order_ship IS NULL OR
	 ship_mode IS NULL OR
	 customer_id IS NULL OR
	 customer_name IS NULL OR
	 segment IS NULL OR
	 country IS NULL OR
	 city IS NULL OR
	 state IS NULL OR
	 postal_code IS NULL OR
	 region IS NULL OR
	 product_id IS NULL OR
	 category IS NULL OR
	 sub_category IS NULL OR
	 product_name IS NULL OR
	 sales IS NULL OR
	 quantity IS NULL OR
	 discount IS NULL OR
	 profit IS NULL ;


-- 🔸 Q1. Total Sales and Total Profit by Category
SELECT 
  category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 🔸 Q2. Total Sales and Profit by Region
SELECT 
  region,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY region
ORDER BY total_sales DESC;

-- 🔸 Q3. Top 5 Most Profitable Customers
SELECT 
  customer_name,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 5;

-- 🔸 Q4. Monthly Sales Trend
SELECT 
  DATE_TRUNC('month', order_date) AS month,
  ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

-- 🔸 Q5. Best-Selling Month Each Year
SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        TO_CHAR(order_date, 'Month') AS month_name,
        ROUND(SUM(sales), 2) AS total_sales,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY SUM(sales) DESC) AS month_rank
    FROM ecommerce_sales
    GROUP BY year, month_name
) AS monthly_sales
WHERE month_rank = 1;

-- 🔸 Q6. Top 5 Products by Sales
SELECT 
  product_name,
  ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

-- 🔸 Q7. Shift-wise Orders (Morning, Afternoon, Evening)
WITH shift_data AS (
  SELECT *,
    CASE
      WHEN EXTRACT(HOUR FROM order_date::timestamp) < 12 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM order_date::timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
  FROM ecommerce_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM shift_data
GROUP BY shift;

-- ✅ END OF PROJECT

