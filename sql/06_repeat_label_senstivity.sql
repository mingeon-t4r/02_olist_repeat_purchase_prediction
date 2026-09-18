WITH sensitivity_base AS (

    SELECT
        c.customer_unique_id,
        c.first_approved_at,

        min(
            CASE
                WHEN o.order_approved_at
                    > datetime(
                        c.first_approved_at,
                        '+1 hour'
                    )

                AND o.order_approved_at
                    <= datetime(
                        c.first_approved_at,
                        '+90 day'
                    )

                    THEN o.order_approved_at
            END
        ) AS repeat_after_1h,

        min(
            CASE
                WHEN o.order_approved_at
                    > datetime(
                        c.first_approved_at,
                        '+1 day'
                    )

                AND o.order_approved_at
                    <= datetime(
                        c.first_approved_at,
                        '+90 day'
                    )

                    THEN o.order_approved_at
            END
        ) AS repeat_after_24h

    FROM customer_repeat_90d_base AS c

    LEFT JOIN order_base AS o
        ON c.customer_unique_id
            = o.customer_unique_id

        AND o.is_approved_order = 1

    WHERE
        c.is_eligible_90d = 1

    GROUP BY
        c.customer_unique_id,
        c.first_approved_at
)


SELECT
    count(*) AS eligible_customer_count,

    sum(
        CASE
            WHEN repeat_after_1h IS NOT NULL
                THEN 1
            ELSE 0
        END
    ) AS repeat_after_1h_count,

    round(
        avg(
            CASE
                WHEN repeat_after_1h IS NOT NULL
                    THEN 1.0
                ELSE 0.0
            END
        ) * 100,
        2
    ) AS repeat_after_1h_rate,

    sum(
        CASE
            WHEN repeat_after_24h IS NOT NULL
                THEN 1
            ELSE 0
        END
    ) AS repeat_after_24h_count,

    round(
        avg(
            CASE
                WHEN repeat_after_24h IS NOT NULL
                    THEN 1.0
                ELSE 0.0
            END
        ) * 100,
        2
    ) AS repeat_after_24h_rate

FROM sensitivity_base;