DROP VIEW IF EXISTS customer_repeat_90d_base;


CREATE VIEW customer_repeat_90d_base AS


WITH approved_order AS (

    SELECT
        order_id,
        customer_unique_id,
        order_approved_at

    FROM order_base

    WHERE
        is_approved_order = 1
),


observation_period AS (

    SELECT
        max(
            order_approved_at
        ) AS observation_end,

        datetime(
            max(order_approved_at),
            '-90 day'
        ) AS eligibility_cutoff

    FROM approved_order
),


ranked_orders AS (

    SELECT
        order_id,
        customer_unique_id,
        order_approved_at,

        row_number() OVER(
            PARTITION BY customer_unique_id

            ORDER BY
                order_approved_at,
                order_id
        ) AS purchase_rank

    FROM approved_order
),


first_purchase AS (

    SELECT
        order_id AS first_order_id,
        customer_unique_id,
        order_approved_at AS first_approved_at

    FROM ranked_orders

    WHERE
        purchase_rank = 1
),


repeat_purchase_reference AS (

    SELECT
        f.customer_unique_id,

        min(
            o.order_approved_at
        ) AS second_approved_at

    FROM first_purchase AS f

    LEFT JOIN approved_order AS o
        ON f.customer_unique_id
            = o.customer_unique_id

        AND o.order_approved_at
            > f.first_approved_at

        AND o.order_approved_at
            <= datetime(
                f.first_approved_at,
                '+90 day'
            )

    GROUP BY
        f.customer_unique_id
),


repeat_purchase_after_1h AS (

    SELECT
        f.customer_unique_id,

        min(
            o.order_approved_at
        ) AS second_approved_at_after_1h

    FROM first_purchase AS f

    LEFT JOIN approved_order AS o
        ON f.customer_unique_id
            = o.customer_unique_id

        AND o.order_approved_at
            > datetime(
                f.first_approved_at,
                '+1 hour'
            )

        AND o.order_approved_at
            <= datetime(
                f.first_approved_at,
                '+90 day'
            )

    GROUP BY
        f.customer_unique_id
)


SELECT
    f.customer_unique_id,
    f.first_order_id,
    f.first_approved_at,

    strftime(
        '%Y-%m',
        f.first_approved_at
    ) AS first_purchase_month,

    o.observation_end,
    o.eligibility_cutoff,

    CASE
        WHEN f.first_approved_at
            <= o.eligibility_cutoff
            THEN 1

        ELSE 0
    END AS is_eligible_90d,

    r.second_approved_at,

    CASE
        WHEN f.first_approved_at
            > o.eligibility_cutoff
            THEN NULL

        WHEN r.second_approved_at IS NOT NULL
            THEN 1

        ELSE 0
    END AS repeat_90d,

    r1.second_approved_at_after_1h,

    CASE
        WHEN f.first_approved_at
            > o.eligibility_cutoff
            THEN NULL

        WHEN r1.second_approved_at_after_1h
            IS NOT NULL
            THEN 1

        ELSE 0
    END AS repeat_90d_after_1h

FROM first_purchase AS f

CROSS JOIN observation_period AS o

LEFT JOIN repeat_purchase_reference AS r
    ON f.customer_unique_id
        = r.customer_unique_id

LEFT JOIN repeat_purchase_after_1h AS r1
    ON f.customer_unique_id
        = r1.customer_unique_id;