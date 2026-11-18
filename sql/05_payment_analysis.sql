
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 05_payment_analysis.sql
-- PURPOSE : Analyze payment methods and payment value
-- ============================================================

USE olist_ecommerce_analysis;


-- ============================================================
-- ANALYSIS: PAYMENT METHOD PERFORMANCE
--
-- Business Question:
-- Which payment methods are most frequently used,
-- and which methods contribute the most to total
-- payment value?
--
-- Metrics:
-- 1. Total payment records
-- 2. Total unique orders
-- 3. Total payment value
-- 4. Average payment value per payment record
-- 5. Payment value percentage
--
-- Formula:
-- Payment Value Percentage =
-- (Payment Method Value / Total Payment Value) * 100
-- ============================================================

SELECT
    payment_type,

    COUNT(*) AS total_payment_records,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(payment_value), 2) AS total_payment_value,

    ROUND(AVG(payment_value), 2) AS average_payment_value,

    ROUND(
        SUM(payment_value) * 100.0 /
        (SELECT SUM(payment_value) FROM payments),
        2
    ) AS payment_value_percentage

FROM payments

GROUP BY payment_type

ORDER BY total_payment_value DESC;


-- ============================================================
-- END OF PAYMENT ANALYSIS
-- ============================================================
