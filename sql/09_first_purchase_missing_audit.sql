-- 1. Item Feature 결측 주문의 상태

SELECT
    o.order_status,
    count(*) AS customer_count

FROM first_purchase_feature_base AS f

JOIN order_base AS o
    ON f.first_order_id
        = o.order_id

WHERE
    f.first_item_count IS NULL

GROUP BY
    o.order_status

ORDER BY
    customer_count DESC;


-- 2. 실제 order_items가 없는 주문인지 확인

SELECT
    count(*) AS missing_item_order_count

FROM first_purchase_feature_base AS f

WHERE
    f.first_item_count IS NULL

    AND NOT EXISTS (

        SELECT
            1

        FROM order_items AS oi

        WHERE
            oi.order_id
                = f.first_order_id
    );


-- 3. Payment Feature 결측 고객

SELECT
    f.customer_unique_id,
    f.first_order_id,
    o.order_status

FROM first_purchase_feature_base AS f

JOIN order_base AS o
    ON f.first_order_id
        = o.order_id

WHERE
    f.primary_payment_type IS NULL;


-- 4. 실제 payment record가 없는지 확인

SELECT
    count(*) AS missing_payment_order_count

FROM first_purchase_feature_base AS f

WHERE
    f.primary_payment_type IS NULL

    AND NOT EXISTS (

        SELECT
            1

        FROM order_payments AS p

        WHERE
            p.order_id
                = f.first_order_id
    );


-- 5. Category 결측 원인 분해

SELECT
    CASE

        WHEN first_item_count IS NULL
            THEN 'missing_items'

        WHEN first_item_count IS NOT NULL
            AND primary_category IS NULL
            THEN 'missing_category'

        ELSE 'observed'

    END AS category_missing_type,

    count(*) AS customer_count

FROM first_purchase_feature_base

GROUP BY
    category_missing_type;