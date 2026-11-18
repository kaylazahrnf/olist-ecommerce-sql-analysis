
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 06_delivery_performance.sql
-- PURPOSE : Analyze delivery performance
-- ============================================================

USE olist_ecommerce_analysis;


-- ============================================================
-- ANALYSIS: DELIVERY PERFORMANCE
--
-- Business Question:
-- How well does the company perform in delivering
-- orders on time, and how long does delivery usually take?
--
-- Metrics:
-- 1. Total delivered orders with complete dates
-- 2. On-time deliveries
-- 3. Late deliveries
-- 4. On-time delivery rate
-- 5. Average delivery duration in days
--
-- Delivery classification:
-- On-time:
-- Actual delivery date <= Estimated delivery date
--
-- Late:
-- Actual delivery date > Estimated delivery date
--
-- Scope:
-- Delivered orders with complete date information.
-- ============================================================

SELECT
    COUNT(*) AS total_delivered_orders,

    SUM(
        CASE
            WHEN DATE(order_delivered_customer_date)
                 <= DATE(order_estimated_delivery_date)
            THEN 1
            ELSE 0
        END
    ) AS on_time_deliveries,

    SUM(
        CASE
            WHEN DATE(order_delivered_customer_date)
                 > DATE(order_estimated_delivery_date)
            THEN 1
            ELSE 0
        END
    ) AS late_deliveries,

    ROUND(
        SUM(
            CASE
                WHEN DATE(order_delivered_customer_date)
                     <= DATE(order_estimated_delivery_date)
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS on_time_delivery_rate,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_purchase_timestamp,
                order_delivered_customer_date
            ) / 24.0
        ),
        2
    ) AS average_delivery_days

FROM orders

WHERE order_status = 'delivered'

  AND order_purchase_timestamp IS NOT NULL

  AND order_delivered_customer_date IS NOT NULL

  AND order_estimated_delivery_date IS NOT NULL;


-- ============================================================
-- END OF DELIVERY PERFORMANCE ANALYSIS
-- ============================================================
