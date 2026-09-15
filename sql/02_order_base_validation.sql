-- grain 검증

SELECT
	(
		SELECT count(*)
		FROM orders
	) AS source_order_count,
	
	count(*) AS order_base_count,
	
	count(
		DISTINCT order_id
	) AS distinct_order_count
	
FROM order_base;

-- Item 집계 검산

SELECT
	(
		SELECT
			round(
				sum(price),
				2
			)
		FROM order_items
	) AS source_item_value,
	
	(
		SELECT
			round(
				sum(item_value),
				2
			)
		FROM order_base
	) AS base_item_value,
	
	(
		SELECT
			round(
				sum(freight_value),
				2
			)
		FROM order_items
	) AS source_freight_value,
	
	(
		SELECT
			round(
				sum(freight_value),
				2
			)
		FROM order_base
	) AS base_freight_value;
	
-- Payment 집계 검산

SELECT

    (
        SELECT
            round(
                sum(payment_value),
                2
            )
        FROM order_payments
    ) AS source_payment_value,

    (
        SELECT
            round(
                sum(payment_value),
                2
            )
        FROM order_base
    ) AS base_payment_value;
	
-- 승인 주문 검증

SELECT
    count(*) AS approved_order_count,

    min(
        order_approved_at
    ) AS first_approved_at,

    max(
        order_approved_at
    ) AS last_approved_at

FROM order_base

WHERE
    is_approved_order = 1;
	
-- 승인된 주문의 최종 상태

SELECT
    order_status,
    count(*) AS order_count

FROM order_base

WHERE
    is_approved_order = 1

GROUP BY
    order_status

ORDER BY
    order_count DESC;
	
-- Observation Window 검증

SELECT
    max(
        order_approved_at
    ) AS observation_end,

    datetime(
        max(order_approved_at),
        '-90 day'
    ) AS eligible_first_purchase_cutoff

FROM order_base

WHERE
    is_approved_order = 1;