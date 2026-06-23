-- ============================================================
-- File: 03_business_analysis_queries.sql
-- Project: Business Data Analysis for Customer, Product, and Market Decision-Making
-- Dataset: Online Retail II UCI
-- Purpose: Analyze sales trend, market performance, product performance, customer value, and average order value
-- ============================================================

USE final_report；

-- ============================================================
-- 1. Monthly sales trend
-- ============================================================

SELECT
    order_year,
    order_month,
    ROUND(SUM(sales_amount), 2) AS monthly_sales,
    COUNT(DISTINCT invoice) AS number_of_orders,
    COUNT(DISTINCT customer_id) AS number_of_customers
FROM online_retail_cleaned
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- ============================================================
-- 2. Top 10 countries by total sales
-- ============================================================

SELECT
    country,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    COUNT(DISTINCT invoice) AS number_of_orders,
    COUNT(DISTINCT customer_id) AS number_of_customers
FROM online_retail_cleaned
GROUP BY country
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 3. Top 10 products by total sales
-- ============================================================

SELECT
    stock_code,
    description,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    SUM(quantity) AS total_quantity
FROM online_retail_cleaned
GROUP BY stock_code, description
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 4. Top 10 customers by total sales
-- ============================================================

SELECT
    customer_id,
    country,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    COUNT(DISTINCT invoice) AS number_of_orders,
    SUM(quantity) AS total_quantity
FROM online_retail_cleaned
GROUP BY customer_id, country
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 5. Average order value by country
-- Only countries with at least 20 orders are included
-- ============================================================

SELECT
    country,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    COUNT(DISTINCT invoice) AS number_of_orders,
    ROUND(SUM(sales_amount) / COUNT(DISTINCT invoice), 2) AS average_order_value
FROM online_retail_cleaned
GROUP BY country
HAVING COUNT(DISTINCT invoice) >= 20
ORDER BY average_order_value DESC
LIMIT 10;