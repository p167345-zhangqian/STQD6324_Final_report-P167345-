--
============================================================
-- File: 01_create_database_and_table.sql
-- Project: Business Data Analysis for Customer, Product, and Market Decision-Making
-- Dataset: Online Retail II UCI
-- Purpose: Create Hive database, create raw table, load dataset, and preview raw data
-- ============================================================

-- Create database
CREATE DATABASE IF NOT EXISTS final_report;

-- Use database
USE final_report;

-- Remove old raw table if it already exists
DROP TABLE IF EXISTS online_retail_raw;

-- Create raw table
-- All fields are stored as STRING first because the raw dataset contains
-- missing values, header row, cancelled orders, and invalid numeric values.
CREATE TABLE online_retail_raw (
    invoice STRING,
    stock_code STRING,
    description STRING,
    quantity STRING,
    invoice_date STRING,
    price STRING,
    customer_id STRING,
    country STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- Load tab-delimited dataset from HDFS into Hive table
LOAD DATA INPATH '/user/maria_dev/final_report/raw/dataset_online_retail_ii.tsv'
OVERWRITE INTO TABLE online_retail_raw;

-- Preview raw table
SELECT *
FROM online_retail_raw
LIMIT 5;

-- Count total raw rows
SELECT COUNT(*)
FROM online_retail_raw;