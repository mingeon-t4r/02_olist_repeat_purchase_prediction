# Feature Dictionary

| Feature | Source | Definition | Available at Snapshot | Model Candidate |
|---|---|---|---|---|
| customer_state | customers | customer state | Yes | Yes |
| purchase_weekday | orders | approval weekday | Yes | Yes |
| purchase_hour | orders | approval hour | Yes | Yes |
| first_item_count | order_items | item rows in first order | Yes | Yes |
| first_distinct_product_count | order_items | distinct products | Yes | Yes |
| first_seller_count | order_items | distinct sellers | Yes | Yes |
| first_item_value | order_items | total item price | Yes | Yes |
| first_freight_value | order_items | total freight | Yes | Yes |
| first_freight_ratio | derived | freight / order value | Yes | Yes |
| primary_payment_type | order_payments | largest payment type | Yes | Yes |
| first_max_payment_installments | order_payments | max installments | Yes | Yes |
| primary_category | products | dominant first-order category | Yes | Yes |
| customer_unique_id | customers | customer identifier | Yes | No |
| first_order_id | orders | first order identifier | Yes | No |
| first_order_value | derived | item value + freight | Yes | Yes |
| first_avg_item_price | derived | item value / item count | Yes | Yes |
| first_payment_record_count | order_payments | payment rows | Yes | Yes |
| first_payment_type_count | order_payments | distinct payment types | Yes | Yes |
| first_payment_value | order_payments | total first-order payment | Yes | Yes |
| first_category_count | products | distinct categories | Yes | Yes |
| missing_category_item_count | derived | items without category | Yes | Review |