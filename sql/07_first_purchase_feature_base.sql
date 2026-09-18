DROP VIEW IF EXISTS first_purchase_feature_base;


CREATE VIEW first_purchase_feature_base AS


WITH category_summary AS (

    SELECT
        oi.order_id,

        count(
            DISTINCT p.product_category_name
        ) AS category_count,

        sum(
            CASE
                WHEN p.product_category_name IS NULL
                    THEN 1
                ELSE 0
            END
        ) AS missing_category_item_count

    FROM order_items AS oi

    LEFT JOIN products AS p
        ON oi.product_id
            = p.product_id

    GROUP BY
        oi.order_id
),


category_value AS (

    SELECT
        oi.order_id,
        p.product_category_name,

        sum(
            oi.price
        ) AS category_item_value

    FROM order_items AS oi

    LEFT JOIN products AS p
        ON oi.product_id
            = p.product_id

    GROUP BY
        oi.order_id,
        p.product_category_name
),


category_ranked AS (

    SELECT
        order_id,
        product_category_name,
        category_item_value,

        row_number() OVER(
            PARTITION BY order_id
            ORDER BY
                category_item_value DESC,
                product_category_name
        ) AS category_rank

    FROM category_value
),


payment_value AS (

    SELECT
        order_id,
        payment_type,

        sum(
            payment_value
        ) AS payment_type_value

    FROM order_payments

    GROUP BY
        order_id,
        payment_type
),


payment_ranked AS (

    SELECT
        order_id,
        payment_type,

        row_number() OVER(
            PARTITION BY order_id
            ORDER BY
                payment_type_value DESC,
                payment_type
        ) AS payment_rank

    FROM payment_value
)


SELECT
    c.customer_unique_id,
    c.first_order_id,
    c.first_approved_at,

    o.customer_state,

    cast(
        strftime(
            '%w',
            c.first_approved_at
        ) AS integer
    ) AS purchase_weekday,

    cast(
        strftime(
            '%H',
            c.first_approved_at
        ) AS integer
    ) AS purchase_hour,

    o.item_count
        AS first_item_count,

    o.distinct_product_count
        AS first_distinct_product_count,

    o.seller_count
        AS first_seller_count,

    o.item_value
        AS first_item_value,

    o.freight_value
        AS first_freight_value,

    round(
        o.item_value
        + o.freight_value,
        2
    ) AS first_order_value,

    round(
        o.freight_value
        / NULLIF(
            o.item_value
            + o.freight_value,
            0
        ),
        4
    ) AS first_freight_ratio,

    round(
        o.item_value
        / NULLIF(
            o.item_count,
            0
        ),
        2
    ) AS first_avg_item_price,

    o.payment_record_count
        AS first_payment_record_count,

    o.payment_type_count
        AS first_payment_type_count,

    o.payment_value
        AS first_payment_value,

    o.max_payment_installments
        AS first_max_payment_installments,

    pr.payment_type
        AS primary_payment_type,

    cs.category_count
        AS first_category_count,

    cr.product_category_name
        AS primary_category,

    cs.missing_category_item_count

FROM customer_repeat_90d_base AS c

JOIN order_base AS o
    ON c.first_order_id
        = o.order_id

LEFT JOIN category_summary AS cs
    ON c.first_order_id
        = cs.order_id

LEFT JOIN category_ranked AS cr
    ON c.first_order_id
        = cr.order_id

    AND cr.category_rank = 1

LEFT JOIN payment_ranked AS pr
    ON c.first_order_id
        = pr.order_id

    AND pr.payment_rank = 1;