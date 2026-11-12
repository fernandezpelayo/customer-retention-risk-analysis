-- Description: Create customer segmentation based on RFM scores

USE retail_customer_intelligence;
DROP TABLE IF EXISTS rfm_segments;
CREATE TABLE rfm_segments AS
SELECT *,
    CASE 
        WHEN r_score = 3 AND f_score = 3 AND m_score = 3 THEN 'VIP'
        WHEN r_score >= 2 AND f_score >= 2 THEN 'Loyal'
        WHEN r_score = 3 AND f_score = 1 THEN 'New'
        WHEN r_score = 1 THEN 'At Risk'
        ELSE 'Regular'
    END AS segment
FROM (
    SELECT 
        customer_unique_id,
        recency,
        frequency,
        monetary,

        CASE 
            WHEN recency <= 100 THEN 3
            WHEN recency <= 200 THEN 2
            ELSE 1
        END AS r_score,

        CASE 
            WHEN frequency >= 3 THEN 3
            WHEN frequency = 2 THEN 2
            ELSE 1
        END AS f_score,

        CASE 
            WHEN monetary >= 500 THEN 3
            WHEN monetary >= 200 THEN 2
            ELSE 1
        END AS m_score

    FROM rfm_table
) t;
