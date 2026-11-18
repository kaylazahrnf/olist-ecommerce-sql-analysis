# Key findings — Olist E-Commerce SQL Analysis

Results below were obtained from the local MariaDB database built using the public Olist dataset. Amounts are in Brazilian reais (BRL).

## 1. Monthly product sales and AOV (delivered orders)

- November 2017: **7,289 orders**, **8,475 item rows**, **BRL 987,765.37** product sales. It led the 23 monthly groups returned by the query.
- October 2017: 4,478 orders, BRL 648,247.65 product sales, AOV BRL 144.76.
- November 2017: AOV BRL 135.51. Sales rose while AOV fell compared with October. More orders—not greater average basket value—explained the aggregate increase.
- April 2018: 6,798 orders, BRL 973,534.09 product sales, AOV BRL 143.21.
- May 2018: 6,749 orders, BRL 977,544.69 product sales, AOV BRL 144.84. Product sales increased despite a slightly lower number of orders.

**Business follow-up:** Explore order mix, category demand, discount/campaign metadata (if obtainable), and price distributions before making causal claims.

## 2. Category performance (delivered orders)

| Product category | Orders containing category | Item rows | Product sales (BRL) |
|---|---:|---:|---:|
| health_beauty | 8,647 | 9,465 | 1,233,131.72 |
| watches_gifts | 5,495 | 5,859 | 1,166,176.98 |
| bed_bath_table | 9,272 | 10,953 | 1,023,434.76 |

`bed_bath_table` appears in more orders than `health_beauty`, yet has less product sales value. Orders can appear in multiple category counts.

**Business follow-up:** Consider average item price, shipping costs, profit margins, and seasonal patterns; product sales is not profit.

## 3. Repeat purchases (delivered orders)

- **93,358** distinct customers had at least one delivered order.
- **90,557** had exactly one delivered order.
- **2,801** had two or more delivered orders: **3.00%** of the analyzed population.

**Important:** This is a repeat-purchase proportion, not a formal cohort retention rate. The dataset has a finite observation window.

**Business follow-up:** Study acquisition cohorts, observation windows, and product categories before designing retention campaigns.

## 4. Payments (all order statuses)

- **103,886** payment records represent **99,440** unique orders with payments.
- Total recorded payment value: **BRL 16,008,872.12**.
- `credit_card`: **BRL 12,542,084.19**, or **78.34%** of recorded value.
- `boleto`: **BRL 2,869,361.27**, or **17.92%** of recorded value.
- Voucher records: **5,775**, associated with **3,866** distinct orders; an order can have multiple payment records.

**Important:** The payment table is not filtered to delivered orders; do not equate its sum with delivered-order product sales.

## 5. Delivery performance (delivered orders with complete dates)

- **96,470** eligible orders: **89,936** on or before the estimated delivery calendar date and **6,534** after it.
- On-time rate: **93.23%**; late rate: **6.77%**.
- Average elapsed time from purchase to customer receipt: **12.54 days**.

**Business follow-up:** Investigate lateness by state, seller, and purchase month. An aggregate KPI cannot establish the reason for delays.

## Data-quality observations

| Finding | Count / detail |
|---|---|
| Orders without a matching customer | 0 |
| Item rows without a matching order | 0 |
| Item rows without a matching product | 0 |
| Products with missing category | 610 |
| Categories missing an English mapping | 2 names (13 products in the products table) |
| Delivered order without payment record | 1 (`bfbd0f9bdef84302105ad712db648a6c`, 3 items, BRL 134.97 item value) |
| Delivered orders without one or more required delivery dates | 8 |

The source does not establish whether the missing payment record reflects a genuine operational event or dataset incompleteness. We preserve the source data without inventing replacement values.
