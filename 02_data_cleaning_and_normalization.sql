-- cleaning --
-- Create cleaned customers table
/*CREATE TABLE customers_clean (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    age INT,
    gender VARCHAR(50),
    churn INT
); */
/*
-- Insert cleaned data
INSERT INTO customers_clean (customer_id, customer_name, age, gender, churn)
SELECT 
    CAST(customer_id AS UNSIGNED) as customer_id,
    customer_name,
    CAST(age AS UNSIGNED) as age,
    gender,
    CAST(churn AS UNSIGNED) as churn
FROM customers;
*/
-- Verify
-- SELECT COUNT(*) FROM customers_clean;
-- SELECT * FROM customers_clean LIMIT 10;

/*
-- Create cleaned products table
CREATE TABLE products_clean (
    product_id INT PRIMARY KEY,
    product_category VARCHAR(100),
    product_price DECIMAL(10,2)
);*/
/*
-- Insert cleaned data
INSERT INTO products_clean (product_id, product_category, product_price)
SELECT 
    product_id,
    product_category,
    CAST(product_price AS DECIMAL(10,2)) as product_price
FROM products;
*/

-- Verify
-- SELECT COUNT(*) FROM products_clean;
-- SELECT * FROM products_clean LIMIT 10;

/*
-- Create cleaned orders table
CREATE TABLE orders_clean (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    purchase_date DATETIME,
    quantity INT,
    total_purchase_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    returns INT,
    FOREIGN KEY (customer_id) REFERENCES customers_clean(customer_id),
    FOREIGN KEY (product_id) REFERENCES products_clean(product_id)
); */
/*
-- Insert cleaned data with date conversion
INSERT INTO orders_clean (order_id, customer_id, product_id, purchase_date, quantity, total_purchase_amount, payment_method, returns)
SELECT 
    order_id,
    CAST(c.customer_id AS UNSIGNED) as customer_id,
    product_id,
    STR_TO_DATE(purchase_date, '%m/%d/%Y %H:%i') as purchase_date,
    CAST(quantity AS UNSIGNED) as quantity,
    CAST(total_purchase_amount AS DECIMAL(10,2)) as total_purchase_amount,
    payment_method,
    CAST(returns AS UNSIGNED) as returns
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id; 
/*
-- Verify
SELECT COUNT(*) FROM orders_clean;
SELECT * FROM orders_clean LIMIT 10;

-- Check date conversion worked
SELECT 
    MIN(purchase_date) as earliest_purchase,
    MAX(purchase_date) as latest_purchase
FROM orders_clean;
*/ -- till this couldn't excecute it threw an error
/*
-- Check what the date format looks like
SELECT DISTINCT purchase_date 
FROM orders 
LIMIT 20; */
/*
-- First, let's check if there are any problematic dates
SELECT purchase_date
FROM orders
WHERE STR_TO_DATE(purchase_date, '%m/%d/%Y %H:%i') IS NULL
LIMIT 10; */

-- Clear the table first
-- TRUNCATE TABLE orders_clean;
/*
-- Check for different date formats
SELECT 
    purchase_date,
    CASE 
        WHEN purchase_date LIKE '%-%' THEN 'YYYY-MM-DD format'
        WHEN purchase_date LIKE '%/%' THEN 'M/D/Y format'
        ELSE 'Unknown format'
    END as date_format,
    COUNT(*) as count
FROM orders
GROUP BY purchase_date, date_format
LIMIT 20;
*/

-- Clear the table
-- TRUNCATE TABLE orders_clean;
/*
-- Insert with date conversion (all dates are M/D/Y format)
INSERT INTO orders_clean (order_id, customer_id, product_id, purchase_date, quantity, total_purchase_amount, payment_method, returns)
SELECT 
    o.order_id,
    CAST(c.customer_id AS UNSIGNED) as customer_id,
    o.product_id,
    STR_TO_DATE(o.purchase_date, '%m/%d/%Y %H:%i') as purchase_date,
    CAST(o.quantity AS UNSIGNED) as quantity,
    CAST(o.total_purchase_amount AS DECIMAL(10,2)) as total_purchase_amount,
    o.payment_method,
    CAST(o.returns AS UNSIGNED) as returns
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Verify
SELECT COUNT(*) FROM orders_clean;
SELECT * FROM orders_clean LIMIT 10;
*/ -- did not execute again error
/*
-- Find the problematic record
SELECT * FROM orders 
WHERE purchase_date LIKE '%2023-07-19%'
LIMIT 5; */


-- Clear the table
-- TRUNCATE TABLE orders_clean;
/*
-- Simpler insert WITHOUT customer join (we'll use the VARCHAR customer_id directly for now)
ALTER TABLE orders_clean MODIFY customer_id VARCHAR(100);
ALTER TABLE orders_clean DROP FOREIGN KEY orders_clean_ibfk_1;
*/
/*
-- Now insert with just the date conversion
INSERT INTO orders_clean (order_id, customer_id, product_id, purchase_date, quantity, total_purchase_amount, payment_method, returns)
SELECT 
    order_id,
    customer_id,
    product_id,
    STR_TO_DATE(purchase_date, '%m/%d/%Y %H:%i') as purchase_date,
    CAST(quantity AS UNSIGNED) as quantity,
    CAST(total_purchase_amount AS DECIMAL(10,2)) as total_purchase_amount,
    payment_method,
    CAST(returns AS UNSIGNED) as returns
FROM orders;

-- Verify
SELECT COUNT(*) FROM orders_clean;
SELECT * FROM orders_clean LIMIT 10; */ -- no use error

/*
-- Find records that have dashes (YYYY-MM-DD format)
SELECT purchase_date, COUNT(*) as count
FROM orders
WHERE purchase_date REGEXP '[0-9]{4}-[0-9]{2}-[0-9]{2}'
GROUP BY purchase_date
LIMIT 20;

-- Also count how many total have this format
SELECT 
    SUM(CASE WHEN purchase_date REGEXP '[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN 1 ELSE 0 END) as dash_format,
    SUM(CASE WHEN purchase_date LIKE '%/%' THEN 1 ELSE 0 END) as slash_format,
    COUNT(*) as total
FROM orders;
*/
/*
-- Check the actual raw purchase_date from the combined raw table
SELECT purchase_date 
FROM ecommerce_combined_raw 
LIMIT 10;

-- Compare with orders table
SELECT purchase_date 
FROM orders 
LIMIT 10;
*/

/*
-- Check for dates that start with single digits
SELECT purchase_date 
FROM orders
WHERE purchase_date LIKE '1/%' OR purchase_date LIKE '2/%' OR purchase_date LIKE '3/%'
   OR purchase_date LIKE '4/%' OR purchase_date LIKE '5/%' OR purchase_date LIKE '6/%'
   OR purchase_date LIKE '7/%' OR purchase_date LIKE '8/%' OR purchase_date LIKE '9/%'
LIMIT 10;
*/
/*
-- Clear the table
TRUNCATE TABLE orders_clean;

-- Insert with standard date format
INSERT INTO orders_clean (order_id, customer_id, product_id, purchase_date, quantity, total_purchase_amount, payment_method, returns)
SELECT 
    order_id,
    customer_id,
    product_id,
    STR_TO_DATE(purchase_date, '%m/%d/%Y %H:%i') as purchase_date,
    CAST(quantity AS UNSIGNED) as quantity,
    CAST(total_purchase_amount AS DECIMAL(10,2)) as total_purchase_amount,
    payment_method,
    CAST(returns AS UNSIGNED) as returns
FROM orders;

-- Verify
SELECT COUNT(*) FROM orders_clean;
SELECT * FROM orders_clean LIMIT 10;
*/

-- Check the actual data type of purchase_date in orders table
-- DESCRIBE orders;
/*
-- Check if there are any hidden characters or extra data
SELECT 
    purchase_date,
    LENGTH(purchase_date) as char_length,
    HEX(purchase_date) as hex_value
FROM orders
WHERE purchase_date LIKE '9/8/2020%'
LIMIT 5;
*/
/*
-- Find any record with 9/8/2020 in it
SELECT * 
FROM orders
WHERE purchase_date LIKE '9/8/2020%'
LIMIT 5;
*/

-- Check if orders table has any data at all
-- SELECT COUNT(*) FROM orders;

-- Check first 10 rows
-- SELECT * FROM orders LIMIT 10;
/*
-- Check if purchase_date column has any non-null values
SELECT COUNT(*) as total_rows,
       COUNT(purchase_date) as non_null_dates,
       SUM(CASE WHEN purchase_date IS NULL THEN 1 ELSE 0 END) as null_dates
FROM orders;
*/

/*
-- Check for problematic values in the orders table
SELECT 
    quantity,
    total_purchase_amount,
    returns,
    LENGTH(quantity) as q_len,
    LENGTH(total_purchase_amount) as amt_len,
    LENGTH(returns) as ret_len
FROM orders
WHERE quantity = '0' OR total_purchase_amount = '0' OR returns = '0'
LIMIT 10;
*/

-- Drop and recreate with ALL VARCHAR (we'll handle data types in Power BI)
-- DROP TABLE IF EXISTS orders_clean;
/*
CREATE TABLE orders_clean (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(100),
    product_id INT,
    purchase_date VARCHAR(100),
    quantity VARCHAR(100),
    total_purchase_amount VARCHAR(100),
    payment_method VARCHAR(50),
    returns VARCHAR(100)
);
*/
/*
-- Simple insert - NO casting, NO conversions
INSERT INTO orders_clean (customer_id, product_id, purchase_date, quantity, total_purchase_amount, payment_method, returns)
SELECT 
    r.customer_id,
    p.product_id,
    r.purchase_date,
    r.quantity,
    r.total_purchase_amount,
    r.payment_method,
    r.returns_of
FROM ecommerce_combined_raw r
JOIN products_clean p 
    ON r.product_category = p.product_category 
    AND r.product_price = p.product_price;

-- Verify
SELECT COUNT(*) FROM orders_clean;
SELECT * FROM orders_clean LIMIT 10;
*/
/*
-- Check all your tables and row counts
SELECT 'customers_clean' as table_name, COUNT(*) as row_count FROM customers_clean
UNION ALL
SELECT 'products_clean', COUNT(*) FROM products_clean
UNION ALL
SELECT 'orders_clean', COUNT(*) FROM orders_clean;

-- Test a complete 3-table JOIN
SELECT 
    c.customer_name,
    c.age,
    c.gender,
    p.product_category,
    p.product_price,
    o.quantity,
    o.total_purchase_amount,
    o.payment_method,
    o.purchase_date
FROM orders_clean o
JOIN customers_clean c ON o.customer_id = c.customer_id
JOIN products_clean p ON o.product_id = p.product_id
LIMIT 20;
*/