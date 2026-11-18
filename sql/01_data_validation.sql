
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 01_data_validation.sql
-- PURPOSE : Validate data quality and table relationships
-- ============================================================

USE olist_ecommerce_analysis;


-- ============================================================
-- 1. ROW COUNT CHECK
-- Check the total number of records in each table
-- ============================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_rows
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'product_categories', COUNT(*)
FROM product_categories;


-- ============================================================
-- 2. CUSTOMER IDENTIFIER CHECK
-- Compare customer IDs and unique customer IDs
-- ============================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(DISTINCT customer_id) AS unique_customer_ids,

    COUNT(DISTINCT customer_unique_id) AS unique_customers

FROM customers;


-- ============================================================
-- 3. ORDER STATUS DISTRIBUTION
-- Check the distribution of order statuses
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS total_orders

FROM orders

GROUP BY order_status

ORDER BY total_orders DESC;


-- ============================================================
-- 4. ORDERS WITHOUT CUSTOMERS
-- Check whether every order has a matching customer
-- ============================================================

SELECT
    COUNT(*) AS orders_without_customer

FROM orders o

LEFT JOIN customers c
    ON o.customer_id = c.customer_id

WHERE c.customer_id IS NULL;


-- ============================================================
-- 5. ORDER ITEMS WITHOUT ORDERS
-- Check whether every order item has a matching order
-- ============================================================

SELECT
    COUNT(*) AS items_without_order

FROM order_items oi

LEFT JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_id IS NULL;


-- ============================================================
-- 6. ORDER ITEMS WITHOUT PRODUCTS
-- Check whether every order item has a matching product
-- ============================================================

SELECT
    COUNT(*) AS items_without_product

FROM order_items oi

LEFT JOIN products p
    ON oi.product_id = p.product_id

WHERE p.product_id IS NULL;


-- ============================================================
-- 7. ORDERS WITHOUT PAYMENT RECORDS
-- Identify orders that do not have a matching payment record
-- ============================================================

SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp

FROM orders o

LEFT JOIN payments p
    ON o.order_id = p.order_id

WHERE p.order_id IS NULL;


-- ============================================================
-- 8. PRODUCTS WITHOUT CATEGORY
-- Count products with missing category information
-- ============================================================

SELECT
    COUNT(*) AS products_without_category

FROM products

WHERE product_category_name IS NULL;


-- ============================================================
-- 9. UNMATCHED PRODUCT CATEGORIES
-- Identify categories without an English translation
-- ============================================================

SELECT
    p.product_category_name,
    COUNT(*) AS total_products

FROM products p

LEFT JOIN product_categories pc
    ON p.product_category_name =
       pc.product_category_name

WHERE p.product_category_name IS NOT NULL
  AND pc.product_category_name IS NULL

GROUP BY p.product_category_name;


-- ============================================================
-- 10. DELIVERED ORDERS WITH MISSING DATES
-- Check whether delivered orders have complete date information
-- ============================================================

SELECT
    COUNT(*) AS delivered_orders_with_missing_dates

FROM orders

WHERE order_status = 'delivered'

  AND (
      order_purchase_timestamp IS NULL
      OR order_delivered_customer_date IS NULL
      OR order_estimated_delivery_date IS NULL
  );


-- ============================================================
-- END OF DATA VALIDATION
-- ============================================================
