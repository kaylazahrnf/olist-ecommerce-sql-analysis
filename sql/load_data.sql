-- ==================================================================
-- OLIST: LOAD CSV FILES INTO AN EMPTY DATABASE (MariaDB / MySQL)
-- ==================================================================
-- IMPORTANT:
-- 1) Run sql/00_schema.sql before this script.
-- 2) Edit ALL SIX absolute local paths for your own computer.
-- 3) Use mysql --local-infile=1; LOCAL INFILE must be enabled.
-- 4) ONLY RUN ON EMPTY TABLES. Re-running will conflict with primary keys.
-- 5) This file records the import method; it is not required to re-run
--    the already populated local project database.
-- ==================================================================
USE olist_ecommerce_analysis;

-- English category-name translation (72 records)
LOAD DATA LOCAL INFILE
'D:/Project/olist-ecommerce-sql-analysis/data/raw/product_category_name_translation.csv'
INTO TABLE product_categories CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(product_category_name, @english_category)
SET product_category_name_english = NULLIF(TRIM(TRAILING '\r' FROM @english_category), '');

-- Customers (99,441 records)
LOAD DATA LOCAL INFILE
'D:/Project/olist-ecommerce-sql-analysis/data/raw/olist_customers_dataset.csv'
INTO TABLE customers CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, @customer_state)
SET customer_state = TRIM(TRAILING '\r' FROM @customer_state);

-- Orders (99,441 records)
LOAD DATA LOCAL INFILE
'D:/Project/olist-ecommerce-sql-analysis/data/raw/olist_orders_dataset.csv'
INTO TABLE orders CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, customer_id, order_status,
 @purchase_date, @approved_date, @carrier_date, @delivered_date, @estimated_date)
SET
 order_purchase_timestamp = STR_TO_DATE(NULLIF(@purchase_date, ''), '%Y-%m-%d %H:%i:%s'),
 order_approved_at = STR_TO_DATE(NULLIF(@approved_date, ''), '%Y-%m-%d %H:%i:%s'),
 order_delivered_carrier_date = STR_TO_DATE(NULLIF(@carrier_date, ''), '%Y-%m-%d %H:%i:%s'),
 order_delivered_customer_date = STR_TO_DATE(NULLIF(@delivered_date, ''), '%Y-%m-%d %H:%i:%s'),
 order_estimated_delivery_date = STR_TO_DATE(NULLIF(TRIM(TRAILING '\r' FROM @estimated_date), ''), '%Y-%m-%d %H:%i:%s');

-- Products (32,951 records). CSV headers contain 'lenght' typo;
-- the import maps fields by CSV position to normalized DB column names.
LOAD DATA LOCAL INFILE
'D:/Project/olist-ecommerce-sql-analysis/data/raw/olist_products_dataset.csv'
INTO TABLE products CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(product_id, @category, @name_length, @description_length, @photos_qty,
 @weight, @length, @height, @width)
SET
 product_category_name = NULLIF(TRIM(TRAILING '\r' FROM @category), ''),
 product_name_length = NULLIF(@name_length, ''),
 product_description_length = NULLIF(@description_length, ''),
 product_photos_qty = NULLIF(@photos_qty, ''),
 product_weight_g = NULLIF(@weight, ''),
 product_length_cm = NULLIF(@length, ''),
 product_height_cm = NULLIF(@height, ''),
 product_width_cm = NULLIF(TRIM(TRAILING '\r' FROM @width), '');

-- Items (112,650 records)
LOAD DATA LOCAL INFILE
'D:/Project/olist-ecommerce-sql-analysis/data/raw/olist_order_items_dataset.csv'
INTO TABLE order_items CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, order_item_id, product_id, seller_id, @shipping_date, @price, @freight)
SET
 shipping_limit_date = STR_TO_DATE(NULLIF(TRIM(TRAILING '\r' FROM @shipping_date), ''), '%Y-%m-%d %H:%i:%s'),
 price = NULLIF(@price, ''),
 freight_value = NULLIF(TRIM(TRAILING '\r' FROM @freight), '');

-- Payments (103,886 records)
LOAD DATA LOCAL INFILE
'D:/Project/olist-ecommerce-sql-analysis/data/raw/olist_order_payments_dataset.csv'
INTO TABLE payments CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, payment_sequential, @payment_type, @installments, @payment_value)
SET
 payment_type = NULLIF(TRIM(TRAILING '\r' FROM @payment_type), ''),
 payment_installments = NULLIF(@installments, ''),
 payment_value = NULLIF(TRIM(TRAILING '\r' FROM @payment_value), '');

-- Validate counts with sql/01_data_validation.sql after loading.
