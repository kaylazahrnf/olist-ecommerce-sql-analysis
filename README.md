# Olist E-Commerce Sales, Customer & Delivery Analysis Using SQL

SQL portfolio project analyzing historical Brazilian marketplace transactions to answer practical business questions about sales performance, product categories, repeat purchasing, payment methods, and delivery operations.

> **Portfolio context:** This is an independent educational analysis using the public Olist dataset, **not Shopee data** and not an analysis conducted for Olist as an employee.

## Project overview

**Objective:** Transform relational e-commerce data into descriptive business metrics, identify noteworthy patterns and data-quality issues, and propose follow-up questions for business teams.

**Tools:** MariaDB 10.4.32 (XAMPP), phpMyAdmin, SQL, Visual Studio Code. The SQL uses MySQL/MariaDB-style syntax.

**Methods:** relational joins, conditional aggregation (`CASE WHEN`), `GROUP BY`, `COUNT(DISTINCT)`, subqueries, `COALESCE`, `DATE_FORMAT`, and `TIMESTAMPDIFF`.

## Dataset and attribution

- **Source:** [Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Dataset provider:** Olist
- **Period represented:** Historical Brazilian marketplace orders from 2016–2018
- **License listed on Kaggle:** CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
- **Data handling:** Original CSV files are downloaded from Kaggle and are *not* redistributed in this repository. See [data/README.md](data/README.md).

Six source files were used and loaded into six relational tables:

| Database table | Rows | Purpose |
| --- | ---: | --- |
| `customers` | 99,441 | Customer records and persistent customer identifiers |
| `orders` | 99,441 | Order status, purchase and delivery timestamps |
| `order_items` | 112,650 | Purchased items, product prices and freight |
| `products` | 32,951 | Product attributes and original categories |
| `payments` | 103,886 | Payment method and payment value per record |
| `product_categories` | 72 | English translations of category names |

### Relational model

- `customers.customer_id` → `orders.customer_id`
- `orders.order_id` → `order_items.order_id`
- `orders.order_id` → `payments.order_id`
- `products.product_id` → `order_items.product_id`
- `products.product_category_name` → `product_categories.product_category_name`

These are **logical relationships**, verified by SQL checks; this implementation does **not** define physical foreign-key constraints. `orders`–`order_items` and `orders`–`payments` are one-to-many relationships, so joining both detail tables at once without pre-aggregation can double-count values.

## Business questions and findings

The following findings come from queries in this project. Monetary figures are expressed in Brazilian reais (BRL), as represented by the source data.

| Area | Finding |
| --- | --- |
| Monthly sales | November 2017 generated the highest **delivered-order product sales** in the monthly results: **BRL 987,765.37** across **7,289 orders**. |
| Average order value | AOV decreased from **BRL 144.76** (October 2017) to **BRL 135.51** (November 2017), even while monthly order volume increased. |
| Category performance | `health_beauty` led delivered-order product sales at **BRL 1,233,131.72**. `bed_bath_table` had more category-containing orders but less product sales value. |
| Repeat purchasing | **2,801 of 93,358** customers with at least one delivered order had more than one delivered order (**3.00%**). |
| Payment mix | Credit cards accounted for **78.34%** of payment value (**BRL 12,542,084.19**), across **all** payment records, regardless of order status. |
| Delivery performance | **89,936 of 96,470** delivered orders with complete dates arrived by their estimated calendar date (**93.23%**); mean purchase-to-delivery time was **12.54 days**. |

### Interpretation and potential follow-up actions

1. **Volume and basket value:** The November 2017 sales peak was accompanied by higher order volume but lower AOV. Investigate campaign mix, category shifts, and order composition before attributing the change to promotions.
2. **Category strategy:** Compare category performance with margin, fulfillment costs, and repeat purchasing before making assortment or promotion decisions. Revenue is not profit.
3. **Repeat purchasing:** Explore customer cohorts and follow-up purchasing windows before evaluating retention initiatives; the observed **3.00%** is *not* a cohort-based retention metric.
4. **Logistics:** Segment delayed deliveries by geography, seller, and month to locate where further operational investigation may be useful.

For more detail, see [result/key_findings.md](result/key_findings.md).

## Metric definitions and limitations

- **Monthly product sales value:** `SUM(order_items.price)` for orders where `order_status = 'delivered'`, grouped by *purchase month*. Freight is reported separately. This is neither net profit nor recognized accounting revenue.
- **AOV:** Product sales value divided by `COUNT(DISTINCT order_id)` for delivered orders with order items. It **excludes freight**.
- **Category order count:** Number of distinct orders containing an item in the category. One order may count in multiple categories.
- **Repeat customer rate:** Customers with at least two *delivered* orders divided by customers with at least one delivered order during the observed dataset. End-of-period censoring makes it unsuitable as a direct retention rate.
- **Payment mix:** Computed from the entire `payments` table, **not restricted to delivered orders**. It should not be directly compared with delivered-order product sales.
- **On-time delivery:** `DATE(actual_delivery) <= DATE(estimated_delivery)` for delivered orders with all required dates. The calendar-date comparison is a project choice; purchase-to-delivery duration includes processing and transit time.
- **Time coverage:** Monthly sales output contains 23 observed month groups, including very sparse early months; do not interpret a missing month as necessarily having zero orders of every status.
- **No causal claims:** Results describe associations, not causes of sales changes, non-repeat buying, or delays.

## Data-quality checks

- **0** orders missing a matching customer; **0** order items missing an order; **0** order items missing a product.
- **610** products have a null category.
- **2** category names have no translation mapping (`pc_gamer`: 3 products; `portateis_cozinha_e_preparadores_de_alimentos`: 10 products). Analysis falls back to the original name or `uncategorized`.
- **1** delivered order has no matching payment record. Its 3 items total **BRL 134.97** in item prices. No payment value was fabricated.
- **8** delivered orders lack at least one required date for the delivery KPI and are excluded from that KPI.

## Repository structure

```text
olist-ecommerce-sql-analysis/
├── README.md
├── .gitignore
├── data/
│   ├── README.md
│   └── raw/                 # Local dataset only; not uploaded
├── sql/
│   ├── 00_schema.sql
│   ├── load_data.sql       # Optional reproducible import; edit paths first
│   ├── 01_data_validation.sql
│   ├── 02_sales_performance.sql
│   ├── 03_product_category_analysis.sql
│   ├── 04_customer_behavior.sql
│   ├── 05_payment_analysis.sql
│   └── 06_delivery_performance.sql
└── result/
    └── key_findings.md
```

## How to reproduce

1. Install MariaDB 10.4 or a compatible MySQL/MariaDB version. Open a SQL command-line client with `LOCAL INFILE` enabled (for example, XAMPP Shell and `mysql --local-infile=1 -u root -p`).
2. Download and extract the Olist dataset from the [original Kaggle source](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Keep the six CSV files in `data/raw/` locally.
3. Run `sql/00_schema.sql` to create the database and tables. For example, from the MariaDB client:
   ```sql
   SOURCE D:/Project/olist-ecommerce-sql-analysis/sql/00_schema.sql;
   ```
4. **For a fresh, empty database only:** open `sql/load_data.sql`, replace the six absolute CSV paths with locations on your computer, then execute it using `SOURCE`. **Never run the import script against the already-populated database**, because it attempts to reinsert existing primary keys.
5. Run the validation and analysis SQL files in numeric order using your SQL client. Inspect results in the terminal or phpMyAdmin. Example:
   ```sql
   SOURCE D:/Project/olist-ecommerce-sql-analysis/sql/01_data_validation.sql;
   SOURCE D:/Project/olist-ecommerce-sql-analysis/sql/02_sales_performance.sql;
   ```

The drive/path shown above is an **example from the development environment**; change it on other machines. The SQL source files represent the queries actually used during this project. No dashboard is claimed or included.

## Skills demonstrated

Relational database modeling, CSV ingestion, SQL querying, `INNER JOIN`/`LEFT JOIN`, aggregations, subqueries, business metric definitions, data validation, data interpretation, and concise business reporting.

---

*Educational portfolio analysis. Dataset belongs to its respective provider and is acknowledged above.*
