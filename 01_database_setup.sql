 -- CREATE DATABASE ecommerce_sales;
/*
CREATE TABLE ecommerce_raw_data(
customer_id VARCHAR(100),
purchase_date VARCHAR(100),
product_category VARCHAR(100),
product_price VARCHAR(100),
quantity VARCHAR(100),
total_purchase_amount VARCHAR(100),
payment_method VARCHAR(100),
customer_age VARCHAR(100),
returns_of VARCHAR(100),
customer_name VARCHAR(255),
age VARCHAR(100),
gender VARCHAR(50),
churn VARCHAR(50)
);
*/
/*
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_customer_ratios.csv'
INTO TABLE ecommerce_raw_data
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id,
 purchase_date,
 product_category,
 product_price,
 quantity,
 total_purchase_amount,
 payment_method,
 customer_age,
 returns_of,
 customer_name,
 age,
 gender,
 churn);
*/
-- SELECT COUNT(*) FROM ecommerce_raw_data;
/*
CREATE TABLE ecommerce_raw_data_2 (
    customer_id VARCHAR(100),
    purchase_date VARCHAR(100),
    product_category VARCHAR(100),
    product_price VARCHAR(100),
    quantity VARCHAR(100),
    total_purchase_amount VARCHAR(100),
    payment_method VARCHAR(100),
    customer_age VARCHAR(100),
    returns_of VARCHAR(100),
    customer_name VARCHAR(255),
    age VARCHAR(100),
    gender VARCHAR(50),
    churn VARCHAR(50)
);
*/
/*
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_customer_data_large.csv'
INTO TABLE ecommerce_raw_data_2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id,
 purchase_date,
 product_category,
 product_price,
 quantity,
 total_purchase_amount,
 payment_method,
 customer_age,
 returns_of,
 customer_name,
 age,
 gender,
 churn);
 */
 
 
 -- Create a combined staging table
 /*
CREATE TABLE ecommerce_combined_raw (
    customer_id VARCHAR(100),
    purchase_date VARCHAR(100),
    product_category VARCHAR(100),
    product_price VARCHAR(100),
    quantity VARCHAR(100),
    total_purchase_amount VARCHAR(100),
    payment_method VARCHAR(100),
    customer_age VARCHAR(100),
    returns_of VARCHAR(100),
    customer_name VARCHAR(255),
    age VARCHAR(100),
    gender VARCHAR(50),
    churn VARCHAR(50)
);
*/

-- Insert data from Table 1
/*
INSERT INTO ecommerce_combined_raw
SELECT * FROM ecommerce_raw_data;

-- Insert data from Table 2
INSERT INTO ecommerce_combined_raw
SELECT * FROM ecommerce_raw_data_2;
*/
-- Verify the combined data
-- SELECT COUNT(*) as total_rows FROM ecommerce_combined_raw;
/*
SELECT 'Table 1' as source, COUNT(*) as total_rows FROM ecommerce_raw_data
UNION ALL
SELECT 'Table 2', COUNT(*) FROM ecommerce_raw_data_2
UNION ALL
SELECT 'Combined', COUNT(*) FROM ecommerce_combined_raw;
*/

-- DROP TABLE IF EXISTS customers;
/*
-- Create customers table  
CREATE TABLE customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    customer_name VARCHAR(255),
    age VARCHAR(100),
    gender VARCHAR(50),
    churn VARCHAR(50)
); */
/*
-- Insert customers - taking first occurrence for each customer_id
INSERT INTO customers (customer_id, customer_name, age, gender, churn)
SELECT 
    customer_id,
    MAX(customer_name) as customer_name,  -- Take one value
    MAX(age) as age,
    MAX(gender) as gender,
    MAX(churn) as churn
FROM ecommerce_combined_raw
GROUP BY customer_id;
*/

-- Verify
-- SELECT COUNT(*) as total_unique_customers FROM customers;
-- SELECT * FROM customers LIMIT 10;
-- customers table --

/*
-- Create products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_category VARCHAR(100),
    product_price VARCHAR(100)
); */
/*
-- Insert distinct products
INSERT INTO products (product_category, product_price)
SELECT DISTINCT
    product_category,
    product_price
FROM ecommerce_combined_raw;
*/
-- Verify
-- SELECT COUNT(*) as total_unique_products FROM products;
 -- SELECT * FROM products LIMIT 10;
 -- products done --
 
 /*
 -- Create orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(100),
    product_id INT,
    purchase_date VARCHAR(100),
    quantity VARCHAR(100),
    total_purchase_amount VARCHAR(100),
    payment_method VARCHAR(100),
    returns VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
); */
/*
-- Insert orders with product_id lookup
INSERT INTO orders (customer_id, product_id, purchase_date, quantity, total_purchase_amount, payment_method, returns)
SELECT 
    r.customer_id,
    p.product_id,
    r.purchase_date,
    r.quantity,
    r.total_purchase_amount,
    r.payment_method,
    r.returns_of
FROM ecommerce_combined_raw r
JOIN products p 
    ON r.product_category = p.product_category 
    AND r.product_price = p.product_price;
*/
-- Verify
-- SELECT COUNT(*) as total_orders FROM orders;
-- SELECT * FROM orders LIMIT 10;
-- joining done --

/*
-- Test 1: Simple JOIN - Orders with Customer Names
SELECT 
    o.order_id,
    c.customer_name,
    c.age,
    o.purchase_date,
    o.total_purchase_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 10;
*/
/*
-- Test 2: Three-table JOIN - Complete Order Details
SELECT 
    o.order_id,
    c.customer_name,
    p.product_category,
    p.product_price,
    o.quantity,
    o.total_purchase_amount,
    o.payment_method
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
LIMIT 10;
*/
/*
-- Test 3: Count check - all orders should have matches
SELECT COUNT(*) FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;
*/