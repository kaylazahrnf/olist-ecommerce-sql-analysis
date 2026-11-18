# Dataset instructions

This project uses the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), provided by Olist on Kaggle. The dataset page lists **CC BY-NC-SA 4.0**. Original CSVs are not redistributed in this portfolio; please obtain them from the source.

Download the dataset and extract these six source CSVs into a **local** folder `data/raw/`:

1. `olist_customers_dataset.csv` → `customers`
2. `olist_orders_dataset.csv` → `orders`
3. `olist_order_items_dataset.csv` → `order_items`
4. `olist_order_payments_dataset.csv` → `payments`
5. `olist_products_dataset.csv` → `products`
6. `product_category_name_translation.csv` → `product_categories`

Then see the import instructions in the root `README.md` and `sql/load_data.sql`. The imported product columns `product_name_length` and `product_description_length` correct the spelling (`lenght`) found in the CSV headers via position-based mapping.

Never upload local database credentials or confidential company data. This project uses only the publicly available Olist dataset.
