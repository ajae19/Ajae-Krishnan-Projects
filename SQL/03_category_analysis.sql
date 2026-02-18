-- Business Question: Which product categories generate the most revenue?

SELECT
    ct.product_category_name_english AS category,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM order_items oi
JOIN products pr 
    ON oi.product_id = pr.product_id
JOIN category_translation ct
    ON pr.product_category_name = ct.product_category_name
JOIN payments p 
    ON oi.order_id = p.order_id
GROUP BY category
ORDER BY revenue DESC;

-- Business Question: What is the average order value (AOV)?

WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(p.payment_value) AS order_total
    FROM orders o
    JOIN payments p 
        ON o.order_id = p.order_id
    GROUP BY o.order_id
)
SELECT 
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM order_totals;
