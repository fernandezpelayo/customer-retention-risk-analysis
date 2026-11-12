-- Description: Create RFM metrics at customer level

USE retail_customer_intelligence;
DROP TABLE IF EXISTS rfm_table;
CREATE TABLE rfm_table AS
SELECT 
    customer_unique_id,

    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp) FROM customer_orders_base),
        MAX(order_purchase_timestamp)
    ) AS recency,

    COUNT(DISTINCT order_id) AS frequency,

    SUM(payment_value) AS monetary

FROM customer_orders_base
GROUP BY customer_unique_id;