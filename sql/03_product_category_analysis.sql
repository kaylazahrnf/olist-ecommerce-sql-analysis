
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 03_product_category_analysis.sql
-- PURPOSE : Analyze product category performance
-- ============================================================

USE olist_ecommerce_analysis;


-- ============================================================
-- ANALYSIS: TOP 10 PRODUCT CATEGORIES
--
-- Business Question:
-- Which product categories generate the highest sales?
--
-- Metrics:
-- 1. Total orders
-- 2. Total order items
-- 3. Product sales value
--
-- Scope:
-- Only delivered orders are included.
--
-- Category handling:
-- Use English category name when available.
-- Otherwise, use the original category name.
-- Products without category information are labeled
-- as 'uncategorized'.
-- ============================================================

SELECT
    COALESCE(
        pc.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    ) AS product_category,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(*) AS total_order_items,

    ROUND(SUM(oi.price), 2) AS product_sales_value

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

INNER JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN product_categories pc
    ON p.product_category_name =
       pc.product_category_name

WHERE o.order_status = 'delivered'

GROUP BY
    COALESCE(
        pc.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    )

ORDER BY product_sales_value DESC

LIMIT 10;


-- ============================================================
-- END OF PRODUCT CATEGORY ANALYSIS
-- ============================================================
