-- ANALYSIS --
/*
-- Churn Rate %
CREATE VIEW churn_rate AS
SELECT 
    COUNT(*) as total_customers,
    SUM(churn) as churned_customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) as churn_rate_percent,
    COUNT(*) - SUM(churn) as active_customers,
    ROUND((COUNT(*) - SUM(churn)) * 100.0 / COUNT(*), 2) as active_rate_percent
FROM customers_clean;
*/ -- select*from churn_rate;
/*
-- Revenue comparison: Active vs Churned customers
CREATE VIEW revenue_comparison AS
SELECT 
    CASE WHEN c.churn = 1 THEN 'Churned' ELSE 'Active' END as customer_status,
    COUNT(DISTINCT c.customer_id) as customer_count,
    COUNT(o.order_id) as total_orders,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as total_revenue,
    ROUND(AVG(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as avg_order_value,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))) * 100.0 / 
        SUM(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2)))) OVER(), 2) as revenue_contribution_percent
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY c.churn
ORDER BY c.churn;
*/ -- SELECT * FROM revenue_comparison;

/*
-- Avg Revenue per Customer (Active vs Churned)
CREATE VIEW avg_revenue_per_customer AS
SELECT 
    CASE WHEN c.churn = 1 THEN 'Churned' ELSE 'Active' END as customer_status,
    COUNT(DISTINCT c.customer_id) as customer_count,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))) / 
        COUNT(DISTINCT c.customer_id), 2) as avg_revenue_per_customer,
    ROUND(COUNT(o.order_id) / 
        COUNT(DISTINCT c.customer_id), 2) as avg_orders_per_customer,
    MIN(CAST(o.total_purchase_amount AS DECIMAL(10,2))) as min_order_value,
    MAX(CAST(o.total_purchase_amount AS DECIMAL(10,2))) as max_order_value
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY c.churn
ORDER BY c.churn;
*/  -- SELECT * FROM  avg_revenue_per_customer;

/*
-- Repeat Purchase Rate
SELECT 
    CASE WHEN c.churn = 1 THEN 'Churned' ELSE 'Active' END as customer_status,
    COUNT(DISTINCT c.customer_id) as total_customers,
    SUM(CASE WHEN order_counts.order_count > 1 THEN 1 ELSE 0 END) as repeat_customers,
    SUM(CASE WHEN order_counts.order_count = 1 THEN 1 ELSE 0 END) as one_time_customers,
    ROUND(SUM(CASE WHEN order_counts.order_count > 1 THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as repeat_purchase_rate_percent
FROM customers_clean c
JOIN (
    SELECT 
        customer_id,
        COUNT(order_id) as order_count
    FROM orders_clean
    GROUP BY customer_id
) order_counts ON c.customer_id = order_counts.customer_id
GROUP BY c.churn
ORDER BY c.churn;
*/

/*
-- Return Rate vs Churn
SELECT 
    CASE WHEN c.churn = 1 THEN 'Churned' ELSE 'Active' END as customer_status,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(o.order_id) as total_orders,
    SUM(CAST(o.returns AS UNSIGNED)) as total_returns,
    ROUND(SUM(CAST(o.returns AS UNSIGNED)) * 100.0 / 
        COUNT(o.order_id), 2) as return_rate_percent,
    ROUND(AVG(CAST(o.returns AS UNSIGNED)), 4) as avg_returns_per_order
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY c.churn
ORDER BY c.churn;
*/
/*
-- Product Category vs Churn
SELECT 
    p.product_category,
    COUNT(DISTINCT c.customer_id) as total_customers,
    SUM(CASE WHEN c.churn = 1 THEN 1 ELSE 0 END) as churned_customers,
    SUM(CASE WHEN c.churn = 0 THEN 1 ELSE 0 END) as active_customers,
    ROUND(SUM(CASE WHEN c.churn = 1 THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as total_revenue,
    ROUND(AVG(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as avg_order_value
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
JOIN products_clean p ON o.product_id = p.product_id
GROUP BY p.product_category
ORDER BY churn_rate_percent DESC;
*/

/*
-- Fixed: Product Category vs Churn
SELECT 
    p.product_category,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) as churned_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 0 THEN c.customer_id END) as active_customers,
    ROUND(COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as total_revenue,
    ROUND(AVG(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as avg_order_value,
    SUM(CAST(o.returns AS UNSIGNED)) as total_returns,
    ROUND(SUM(CAST(o.returns AS UNSIGNED)) * 100.0 / 
        COUNT(o.order_id), 2) as return_rate_percent
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
JOIN products_clean p ON o.product_id = p.product_id
GROUP BY p.product_category
ORDER BY churn_rate_percent DESC;
*/

/*
-- Age Group vs Churn
SELECT 
    CASE 
        WHEN c.age < 25 THEN '18-24'
        WHEN c.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END as age_group,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) as churned_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 0 THEN c.customer_id END) as active_customers,
    ROUND(COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))) / 
        COUNT(DISTINCT c.customer_id), 2) as avg_revenue_per_customer,
    COUNT(o.order_id) as total_orders
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY age_group
ORDER BY churn_rate_percent DESC;
*/

/*
-- Gender vs Churn
SELECT 
    c.gender,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) as churned_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 0 THEN c.customer_id END) as active_customers,
    ROUND(COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))) / 
        COUNT(DISTINCT c.customer_id), 2) as avg_revenue_per_customer,
    ROUND(AVG(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as avg_order_value,
    COUNT(o.order_id) as total_orders
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY c.gender
ORDER BY churn_rate_percent DESC;
*/
/*
-- Payment Method vs Churn
SELECT 
    o.payment_method,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) as churned_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 0 THEN c.customer_id END) as active_customers,
    ROUND(COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))) / 
        COUNT(DISTINCT c.customer_id), 2) as avg_revenue_per_customer,
    COUNT(o.order_id) as total_orders
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY o.payment_method
ORDER BY churn_rate_percent DESC;
*/
/*
-- Monthly Churn Trend (Fixed)
SELECT 
    LEFT(o.purchase_date, 7) as yearmonth,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) as churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as monthly_revenue,
    ROUND(SUM(CASE WHEN c.churn = 1 
        THEN CAST(o.total_purchase_amount AS DECIMAL(10,2)) 
        ELSE 0 END), 2) as churned_revenue
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY LEFT(o.purchase_date, 7)
ORDER BY LEFT(o.purchase_date, 7);
*/
/*
-- Monthly Churn Trend
SELECT 
    SUBSTRING(o.purchase_date, 1, 7) as yearmonth,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) as churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN c.churn = 1 THEN c.customer_id END) * 100.0 / 
        COUNT(DISTINCT c.customer_id), 2) as churn_rate_percent,
    ROUND(SUM(CAST(o.total_purchase_amount AS DECIMAL(10,2))), 2) as monthly_revenue,
    SUM(CASE WHEN c.churn = 1 
        THEN CAST(o.total_purchase_amount AS DECIMAL(10,2)) 
        ELSE 0 END) as churned_revenue
FROM customers_clean c
JOIN orders_clean o ON c.customer_id = o.customer_id
GROUP BY yearmonth
ORDER BY yearmonth;*/