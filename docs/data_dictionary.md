# Data Dictionary

## Dataset Level

| Dataset | Grain | Candidate Key | Join Key | Project Role |
|---|---|---|---|---|
| customers | customer_id record | customer_id | customer_id | customer identity |
| orders | one order | order_id | customer_id | order lifecycle and time |
| order_items | item within order | order_id + order_item_id | order_id | product and price |
| payments | payment record within order | order_id + payment_sequential | order_id | payment attributes |
| products | one product | product_id | product_id | product attributes |
| category_translation | one category mapping | product_category_name | product_category_name | category translation |

## Customer Analysis Grain

Candidate:
customer_unique_id = one customer

Status:
Confirmed