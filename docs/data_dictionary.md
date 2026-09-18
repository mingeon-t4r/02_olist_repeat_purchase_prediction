# Data Dictionary

## Dataset Level

| Dataset | Grain | Candidate Key | Join Key | Project Role |
|---|---|---|---|---|
| customers | customer_id record | customer_id | customer_id | customer identity |
| orders | one order | order_id | customer_id | order lifecycle and time |
| order_items | item within order | order_id + order_item_id | order_id | product and price |
| order_payments | payment record within order | order_id + payment_sequential | order_id | payment attributes |
| products | one product | product_id | product_id | product attributes |
| category_translation | one category mapping | product_category_name | product_category_name | category translation |

## Customer Analysis Grain

Analysis Key:
customer_unique_id

Grain:
one row per customer

## Analytical Order Base

Grain:
one row per order_id

Source:
orders
+ customers
+ aggregated order_items
+ aggregated order_payments

Primary Key:
order_id

Customer Key:
customer_unique_id

Primary Event:
order_approved_at

Important Fields:

| Field | Meaning |
|---|---|
| order_id | order identifier |
| customer_unique_id | customer-level analysis key |
| order_approved_at | prediction event timestamp |
| is_approved_order | primary purchase-event flag |
| item_count | number of item rows in order |
| distinct_product_count | distinct products in order |
| seller_count | distinct sellers in order |
| item_value | sum of item prices |
| freight_value | sum of freight charges |
| payment_value | sum of payment records |
| max_payment_installments | maximum installments used |

## Customer 90-Day Outcome Base

Grain:
one row per customer_unique_id

Source:
order_base

Primary Key:
customer_unique_id

| Field | Meaning |
|---|---|
| customer_unique_id | customer analysis key |
| first_order_id | first approved order |
| first_approved_at | prediction snapshot |
| first_purchase_month | cohort month |
| observation_end | last observed approval timestamp |
| eligibility_cutoff | latest first purchase eligible for 90-day outcome |
| is_eligible_90d | whether full 90-day outcome is observable |
| second_approved_at | earliest repeat approval within 90 days |
| repeat_90d | 90-day repeat-purchase label |