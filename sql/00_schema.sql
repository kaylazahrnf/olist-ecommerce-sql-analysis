
-- ============================================================
-- PROJECT : Olist E-commerce SQL Analysis
-- FILE    : 00_schema.sql
-- PURPOSE : Create database and table structures
-- DBMS    : MariaDB
-- ============================================================


-- 1. Create database
CREATE DATABASE IF NOT EXISTS olist_ecommerce_analysis
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


-- 2. Select database
USE olist_ecommerce_analysis;


-- ============================================================
-- 3. Create customers table
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(32) NOT NULL,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(10) DEFAULT NULL,
    customer_city VARCHAR(100) DEFAULT NULL,
    customer_state CHAR(2) DEFAULT NULL,

    PRIMARY KEY (customer_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 4. Create orders table
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(32) NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(30) DEFAULT NULL,
    order_purchase_timestamp DATETIME DEFAULT NULL,
    order_approved_at DATETIME DEFAULT NULL,
    order_delivered_carrier_date DATETIME DEFAULT NULL,
    order_delivered_customer_date DATETIME DEFAULT NULL,
    order_estimated_delivery_date DATETIME DEFAULT NULL,

    PRIMARY KEY (order_id),

    KEY idx_customer_id (customer_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 5. Create order_items table
-- ============================================================

CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT(11) NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME DEFAULT NULL,
    price DECIMAL(10,2) DEFAULT NULL,
    freight_value DECIMAL(10,2) DEFAULT NULL,

    PRIMARY KEY (order_id, order_item_id),

    KEY idx_order_items_product (product_id),
    KEY idx_order_items_seller (seller_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 6. Create payments table
-- ============================================================

CREATE TABLE IF NOT EXISTS payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT(11) NOT NULL,
    payment_type VARCHAR(30) DEFAULT NULL,
    payment_installments INT(11) DEFAULT NULL,
    payment_value DECIMAL(10,2) DEFAULT NULL,

    PRIMARY KEY (order_id, payment_sequential),

    KEY idx_payment_type (payment_type)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 7. Create products table
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(32) NOT NULL,
    product_category_name VARCHAR(100) DEFAULT NULL,
    product_name_length INT(11) DEFAULT NULL,
    product_description_length INT(11) DEFAULT NULL,
    product_photos_qty INT(11) DEFAULT NULL,
    product_weight_g INT(11) DEFAULT NULL,
    product_length_cm INT(11) DEFAULT NULL,
    product_height_cm INT(11) DEFAULT NULL,
    product_width_cm INT(11) DEFAULT NULL,

    PRIMARY KEY (product_id),

    KEY idx_product_category (product_category_name)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 8. Create product_categories table
-- ============================================================

CREATE TABLE IF NOT EXISTS product_categories (
    product_category_name VARCHAR(100) NOT NULL,
    product_category_name_english VARCHAR(100) DEFAULT NULL,

    PRIMARY KEY (product_category_name)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- END OF SCHEMA
-- ============================================================
