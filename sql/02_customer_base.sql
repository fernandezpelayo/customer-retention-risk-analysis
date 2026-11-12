-- Description: Create order-level dataset by aggregating payments

-- Step 1: Aggregate payments to avoid duplicated orders


USE retail_customer_intelligence;
DROP TABLE IF EXISTS customer_orders_base;
DROP TABLE IF EXISTS order_payments_agg;
CREATE TABLE order_payments_agg AS
SELECT 
    order_id,
    SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY order_id;

-- Step 2: Create base table at order level
CREATE TABLE customer_orders_base AS
SELECT 
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp,
    p.total_payment AS payment_value
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_payments_agg p 
    ON o.order_id = p.order_id;

