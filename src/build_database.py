from pathlib import Path
import sqlite3

import pandas as pd

project_root = Path(__file__).resolve().parents[1]

raw_data_dir = (
    project_root
    / "data"
    / "raw"
)

database_path = (
    project_root
    / "data"
    / "processed"
    / "olist.db"
)

database_path.parent.mkdir(
    parents = True,
    exist_ok = True
)

datasets = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "order_payments": "olist_order_payments_dataset.csv",
    "products": "olist_products_dataset.csv",
    "category_translation": "product_category_name_translation.csv"
}

with sqlite3.connect(database_path) as conn:

    for table_name, file_name in datasets.items():

        df = pd.read_csv(
            raw_data_dir / file_name
        )

        df.to_sql(
            table_name,
            conn,
            if_exists = "replace",
            index = False
        )

        print(
            table_name,
            df.shape
        )
