
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 02_sales_performance.sql
-- PURPOSE : Analyze monthly sales performance and AOV
-- ============================================================

USE olist_ecommerce_analysis;


-- ============================================================
-- ANALYSIS 1: MONTHLY SALES PERFORMANCE
--
-- Business Question:
-- How does sales performance change over time?
--
-- Metrics:
-- 1. Total orders
-- 2. Total order items
-- 3. Product sales value
-- 4. Freight value
--
-- Scope:
-- Only delivered orders are included.
-- ============================================================

SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS sales_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(*) AS total_order_items,

    ROUND(SUM(oi.price), 2) AS product_sales_value,

    ROUND(SUM(oi.freight_value), 2) AS freight_value

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'

GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)

ORDER BY sales_month;


-- ============================================================
-- ANALYSIS 2: AVERAGE ORDER VALUE (AOV)
--
-- Business Question:
-- How much do customers spend on average per order?
--
-- Formula:
-- AOV = Total Product Sales / Total Unique Orders
--
-- Scope:
-- Only delivered orders are included.
-- Freight value is excluded from AOV.
-- ============================================================

SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS sales_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(SUM(oi.price), 2) AS product_sales_value,

    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'

GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)

ORDER BY sales_month;


-- ============================================================
-- END OF SALES PERFORMANCE ANALYSIS
-- ============================================================
