DROP VIEW IF EXISTS cohort_90d_summary;


CREATE VIEW cohort_90d_summary AS


WITH observation_bounds AS (

    SELECT
        min(
            order_approved_at
        ) AS observation_start,

        max(
            order_approved_at
        ) AS observation_end,

        datetime(
            max(order_approved_at),
            '-90 day'
        ) AS eligibility_cutoff

    FROM order_base

    WHERE
        is_approved_order = 1
)


SELECT
    c.first_purchase_month,

    count(*) AS eligible_customer_count,

    sum(
        c.repeat_90d
    ) AS repeat_customer_count,

    round(
        avg(c.repeat_90d) * 100,
        2
    ) AS repeat_rate_pct,

    CASE
        WHEN c.first_purchase_month
            > strftime(
                '%Y-%m',
                b.observation_start
            )

        AND c.first_purchase_month
            < strftime(
                '%Y-%m',
                b.eligibility_cutoff
            )

            THEN 1

        ELSE 0
    END AS is_full_month_cohort

FROM customer_repeat_90d_base AS c

CROSS JOIN observation_bounds AS b

WHERE
    c.is_eligible_90d = 1

GROUP BY
    c.first_purchase_month,
    b.observation_start,
    b.eligibility_cutoff

ORDER BY
    c.first_purchase_month;
	
-- Cohort 결과 확인

SELECT
    *

FROM cohort_90d_summary

ORDER BY
    first_purchase_month;
	
-- 30/60/90일 누적 재구매율

WITH observation_bounds AS (

    SELECT
        max(
            order_approved_at
        ) AS observation_end

    FROM order_base

    WHERE
        is_approved_order = 1
)


SELECT
    '30d' AS horizon,

    count(*) AS eligible_customer_count,

    sum(
        CASE
            WHEN c.second_approved_at IS NOT NULL

            AND c.second_approved_at
                <= datetime(
                    c.first_approved_at,
                    '+30 day'
                )

                THEN 1

            ELSE 0
        END
    ) AS repeat_customer_count,

    round(
        100.0
        *
        sum(
            CASE
                WHEN c.second_approved_at IS NOT NULL

                AND c.second_approved_at
                    <= datetime(
                        c.first_approved_at,
                        '+30 day'
                    )

                    THEN 1

                ELSE 0
            END
        )
        / count(*),
        2
    ) AS repeat_rate_pct

FROM customer_repeat_90d_base AS c

CROSS JOIN observation_bounds AS b

WHERE
    c.first_approved_at
        <= datetime(
            b.observation_end,
            '-30 day'
        )


UNION ALL


SELECT
    '60d',
    count(*),

    sum(
        CASE
            WHEN c.second_approved_at IS NOT NULL

            AND c.second_approved_at
                <= datetime(
                    c.first_approved_at,
                    '+60 day'
                )

                THEN 1

            ELSE 0
        END
    ),

    round(
        100.0
        *
        sum(
            CASE
                WHEN c.second_approved_at IS NOT NULL

                AND c.second_approved_at
                    <= datetime(
                        c.first_approved_at,
                        '+60 day'
                    )

                    THEN 1

                ELSE 0
            END
        )
        / count(*),
        2
    )

FROM customer_repeat_90d_base AS c

CROSS JOIN observation_bounds AS b

WHERE
    c.first_approved_at
        <= datetime(
            b.observation_end,
            '-60 day'
        )


UNION ALL


SELECT
    '90d',
    count(*),

    sum(
        CASE
            WHEN c.repeat_90d = 1
                THEN 1
            ELSE 0
        END
    ),

    round(
        avg(c.repeat_90d) * 100,
        2
    )

FROM customer_repeat_90d_base AS c

WHERE
    c.is_eligible_90d = 1;
	
-- 재구매까지 걸린 시간 분석

SELECT
    customer_unique_id,
    first_approved_at,
    second_approved_at,

    (
        julianday(second_approved_at)
        - julianday(first_approved_at)
    ) AS days_to_repeat

FROM customer_repeat_90d_base

WHERE
    repeat_90d = 1

ORDER BY
    days_to_repeat;
	
-- 즉시 재구매 Audit

WITH repeat_interval AS (

    SELECT
        customer_unique_id,

        (
            julianday(second_approved_at)
            - julianday(first_approved_at)
        ) AS days_to_repeat

    FROM customer_repeat_90d_base

    WHERE
        repeat_90d = 1
)


SELECT
    count(*) AS repeat_customer_count,

    sum(
        CASE
            WHEN days_to_repeat
                <= (1.0 / 24.0)

                THEN 1
            ELSE 0
        END
    ) AS repeat_within_1_hour,

    sum(
        CASE
            WHEN days_to_repeat <= 1
                THEN 1
            ELSE 0
        END
    ) AS repeat_within_24_hours,

    sum(
        CASE
            WHEN days_to_repeat <= 7
                THEN 1
            ELSE 0
        END
    ) AS repeat_within_7_days,

    round(
        100.0
        *
        sum(
            CASE
                WHEN days_to_repeat <= 1
                    THEN 1
                ELSE 0
            END
        )
        / count(*),
        2
    ) AS within_24h_pct

FROM repeat_interval;