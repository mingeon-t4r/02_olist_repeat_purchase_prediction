DROP VIEW IF EXISTS order_base;

CREATE VIEW order_base AS

WITH item_summary AS (
	SELECT
		order_id,
		
		count(*) AS item_count,
		
		count(
			DISTINCT product_id
		) AS distinct_product_count,
		
		count(
			DISTINCT seller_id
		) AS seller_count,
		
		round(
			sum(price),
			2
		) AS item_value,
		
		round(
			sum(freight_value),
			2
		) AS freight_value
		
	FROM order_items
	
	GROUP BY
		order_id
),

payment_summary AS (
	SELECT
		order_id,
		
		count(*) AS payment_record_count,
		
		count(
			DISTINCT payment_type
		) AS payment_type_count,
		
		round(
			sum(payment_value),
			2
		) AS payment_value,
		
		max(
			payment_installments
		) AS max_payment_installments
		
	FROM order_payments
	
	GROUP BY
		order_id
)

SELECT
	o.order_id,
	o.customer_id,
	
	c.customer_unique_id,
	c.customer_state,
	c.customer_city,
	
	o.order_status,
	o.order_purchase_timestamp,
	o.order_approved_at,
	
	CASE
		WHEN o.order_approved_at IS NOT NULL
			THEN 1
		ELSE 0
	END AS is_approved_order,
	
	i.item_count,
	i.distinct_product_count,
	i.seller_count,
	i.item_value,
	i.freight_value,
	
	p.payment_record_count,
	p.payment_type_count,
	p.payment_value,
	p.max_payment_installments
	
FROM orders AS o

JOIN customers AS c
	ON o.customer_id = c.customer_id
	
LEFT JOIN item_summary AS i
	ON o.order_id = i.order_id
	
LEFT JOIN payment_summary AS p
	ON o.order_id = p.order_id;