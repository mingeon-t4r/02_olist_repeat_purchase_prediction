-- =========================================================
-- 1. 전체 First-Purchase Feature Base
--    Item Feature 결측 규모
-- =========================================================

SELECT
    count(*) AS missing_item_customer_count

FROM first_purchase_feature_base

WHERE
    first_item_count IS NULL;


-- =========================================================
-- 2. 전체 Item Feature 결측 주문의 상태 분포
-- =========================================================

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


-- =========================================================
-- 3. 전체 Item Feature 결측 주문에
--    실제 order_items 레코드가 없는지 확인
-- =========================================================

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


-- =========================================================
-- 4. Primary Modeling Population
--    Item Feature 결측 규모
-- =========================================================

SELECT
    count(*) AS eligible_missing_item_customer_count

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

WHERE
    c.is_eligible_90d = 1

    AND f.first_item_count IS NULL;


-- =========================================================
-- 5. Primary Modeling Population
--    Item Feature 결측 주문의 상태 분포
-- =========================================================

SELECT
    o.order_status,
    count(*) AS customer_count

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

JOIN order_base AS o
    ON f.first_order_id
        = o.order_id

WHERE
    c.is_eligible_90d = 1

    AND f.first_item_count IS NULL

GROUP BY
    o.order_status

ORDER BY
    customer_count DESC;


-- =========================================================
-- 6. Primary Modeling Population의 Item 결측 주문에
--    실제 order_items 레코드가 없는지 확인
-- =========================================================

SELECT
    count(*) AS eligible_missing_item_order_count

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

WHERE
    c.is_eligible_90d = 1

    AND f.first_item_count IS NULL

    AND NOT EXISTS (

        SELECT
            1

        FROM order_items AS oi

        WHERE
            oi.order_id
                = f.first_order_id
    );


-- =========================================================
-- 7. Primary Modeling Population
--    Payment Feature 결측 고객
-- =========================================================

SELECT
    f.customer_unique_id,
    f.first_order_id,
    o.order_status

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

JOIN order_base AS o
    ON f.first_order_id
        = o.order_id

WHERE
    c.is_eligible_90d = 1

    AND f.primary_payment_type IS NULL;


-- =========================================================
-- 8. Primary Modeling Population의 Payment 결측 주문에
--    실제 payment record가 없는지 확인
-- =========================================================

SELECT
    count(*) AS eligible_missing_payment_order_count

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

WHERE
    c.is_eligible_90d = 1

    AND f.primary_payment_type IS NULL

    AND NOT EXISTS (

        SELECT
            1

        FROM order_payments AS p

        WHERE
            p.order_id
                = f.first_order_id
    );


-- =========================================================
-- 9. Primary Modeling Population
--    Category 결측 원인 분해
-- =========================================================

SELECT
    CASE

        WHEN f.first_item_count IS NULL
            THEN 'missing_items'

        WHEN f.first_item_count IS NOT NULL
            AND f.primary_category IS NULL
            THEN 'missing_category'

        ELSE 'observed'

    END AS category_missing_type,

    count(*) AS customer_count

FROM first_purchase_feature_base AS f

JOIN customer_repeat_90d_base AS c
    ON f.customer_unique_id
        = c.customer_unique_id

WHERE
    c.is_eligible_90d = 1

GROUP BY
    category_missing_type

ORDER BY
    customer_count DESC;