-- Grain

SELECT
    count(*) AS row_count,

    count(
        DISTINCT customer_unique_id
    ) AS unique_customer_count

FROM first_purchase_feature_base;

-- First Order 연결

SELECT
    count(*) AS invalid_first_order_count

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

WHERE
    f.first_order_id
        <> c.first_order_id;
		
-- Feature 결측치

SELECT

    sum(
        CASE
            WHEN customer_state IS NULL
                THEN 1
            ELSE 0
        END
    ) AS missing_state,

    sum(
        CASE
            WHEN first_item_value IS NULL
                THEN 1
            ELSE 0
        END
    ) AS missing_item_value,

    sum(
        CASE
            WHEN primary_payment_type IS NULL
                THEN 1
            ELSE 0
        END
    ) AS missing_payment_type,

    sum(
        CASE
            WHEN primary_category IS NULL
                THEN 1
            ELSE 0
        END
    ) AS missing_primary_category

FROM first_purchase_feature_base;

-- 범위

SELECT
    min(first_item_count),
    max(first_item_count),

    min(first_item_value),
    max(first_item_value),

    min(first_freight_value),
    max(first_freight_value),

    min(first_freight_ratio),
    max(first_freight_ratio),

    min(first_max_payment_installments),
    max(first_max_payment_installments)

FROM first_purchase_feature_base;