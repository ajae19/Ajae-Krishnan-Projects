-- Business Question: What is total revenue?

SELECT 
    SUM(payment_value) AS total_revenue
FROM payments;

-- Business Question: How does revenue trend over time (monthly)?

SELECT
    substr(order_purchase_timestamp, 1, 7) AS month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM orders o
JOIN payments p 
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- Business Question: What is the month-over-month revenue growth rate?

WITH monthly_revenue AS (
    SELECT
        substr(order_purchase_timestamp, 1, 7) AS month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments p 
        ON o.order_id = p.order_id
    GROUP BY month
),
growth AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(
        (revenue - previous_month_revenue) * 100.0 
        / previous_month_revenue, 
        2
    ) AS revenue_growth_percent
FROM growth
WHERE previous_month_revenue IS NOT NULL;
