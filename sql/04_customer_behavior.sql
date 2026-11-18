
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 04_customer_behavior.sql
-- PURPOSE : Analyze customer purchasing behavior
-- ============================================================

USE olist_ecommerce_analysis;


-- ============================================================
-- ANALYSIS: REPEAT CUSTOMER ANALYSIS
--
-- Business Question:
-- How many customers make repeat purchases?
--
-- Metrics:
-- 1. Customers with delivered orders
-- 2. One-time customers
-- 3. Repeat customers
-- 4. Repeat customer rate
--
-- Customer identification:
-- customer_unique_id is used to identify individual customers
-- across multiple orders.
--
-- Scope:
-- Only delivered orders are included.
--
-- Formula:
-- Repeat Customer Rate =
-- (Repeat Customers / Total Customers) * 100
-- ============================================================

SELECT
    COUNT(*) AS customers_with_delivered_orders,

    SUM(
        CASE
            WHEN total_orders = 1 THEN 1
            ELSE 0
        END
    ) AS one_time_customers,

    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_rate

FROM (
    SELECT
        c.customer_unique_id,

        COUNT(DISTINCT o.order_id) AS total_orders

    FROM customers c

    INNER JOIN orders o
        ON c.customer_id = o.customer_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_unique_id

) AS customer_order_summary;


-- ============================================================
-- END OF CUSTOMER BEHAVIOR ANALYSIS
-- ============================================================
