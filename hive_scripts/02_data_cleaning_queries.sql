-- ============================================================
-- File: 02_data_cleaning_queries.sql
-- Project: Business Data Analysis for Customer, Product, and Market Decision-Making
-- Dataset: Online Retail II UCI
-- Purpose: Check data quality issues and create a cleaned Hive table
-- ============================================================

USE final_report;

-- 1. Check header row
SELECT *
FROM online_retail_raw
WHERE invoice = 'invoice‘
LIMIT 5;

-- 2. Check missing customer_id
SELECT COUNT(*)
FROM online_retail_raw
WHERE customer_id IS NULL
   OR customer_id = ''
   OR customer_id = 'Customer ID';

-- 3. Check missing description
SELECT COUNT(*)
FROM online_retail_raw
WHERE description IS NULL
   OR description = ''
   OR description = 'Description';

-- 4. Check cancelled orders
SELECT COUNT(*)
FROM online_retail_raw
WHERE invoice LIKE 'C%';

-- 5. Check invalid quantity
SELECT COUNT(*)
FROM online_retail_raw
WHERE invoice <> 'invoice'
  AND CAST(quantity AS INT) <= 0;

-- 6. Check invalid price
SELECT COUNT(*)
FROM online_retail_raw
WHERE invoice <> 'invoice'
  AND CAST(price AS DOUBLE) <= 0;

-- 7. Check total raw rows
SELECT COUNT(*)
FROM online_retail_raw;

-- 8. Check distinct rows
SELECT COUNT(*)
FROM (
    SELECT DISTINCT
        invoice,
        stock_code,
        description,
        quantity,
        invoice_date,
        price,
        customer_id,
        country
    FROM online_retail_raw
) t;

-- 9. Create cleaned table
DROP TABLE IF EXISTS online_retail_cleaned;

CREATE TABLE online_retail_cleaned AS
SELECT DISTINCT
    invoice,
    stock_code,
    description,
    CAST(quantity AS INT) AS quantity,
    invoice_date,
    CAST(price AS DOUBLE) AS price,
    customer_id,
    country,
    CAST(quantity AS INT) * CAST(price AS DOUBLE) AS sales_amount,
    SUBSTR(invoice_date, 1, 4) AS order_year,
    SUBSTR(invoice_date, 6, 2) AS order_month
FROM online_retail_raw
WHERE invoice <> 'invoice'
  AND customer_id IS NOT NULL
  AND customer_id <> ''
  AND description IS NOT NULL
  AND description <> ''
  AND invoice NOT LIKE 'C%'
  AND CAST(quantity AS INT) > 0
  AND CAST(price AS DOUBLE) > 0;

-- 10. Check cleaned table row count
SELECT COUNT(*)
FROM online_retail_cleaned;

-- 11. Preview cleaned table
SELECT *
FROM online_retail_cleaned
LIMIT 5;