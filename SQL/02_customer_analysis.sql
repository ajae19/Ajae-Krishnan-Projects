-- Business Question: Who are the top 10 customers by revenue?

SELECT
    c.customer_unique_id,
    ROUND(SUM(p.payment_value), 2) AS total_spent
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN payments p 
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- Business Question: How concentrated is revenue among high-value customers?

WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS total_spent
    FROM orders o
    JOIN customers c 
        ON o.customer_id = c.customer_id
    JOIN payments p 
        ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
),
ranked_customers AS (
    SELECT
        customer_unique_id,
        total_spent,
        NTILE(10) OVER (ORDER BY total_spent DESC) AS decile
    FROM customer_revenue
)
SELECT
    decile,
    ROUND(SUM(total_spent), 2) AS revenue_by_decile
FROM ranked_customers
GROUP BY decile
ORDER BY decile;
-- Business Question: What percentage of customers are repeat customers?

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c 
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 
    / COUNT(*) AS repeat_customer_percentage
FROM customer_orders;
