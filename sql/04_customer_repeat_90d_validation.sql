-- Grain 검증

SELECT
    count(*) AS row_count,

    count(
        DISTINCT customer_unique_id
    ) AS unique_customer_count

FROM customer_repeat_90d_base;

SELECT
    (
        SELECT
            count(
                DISTINCT customer_unique_id
            )

        FROM order_base

        WHERE
            is_approved_order = 1
    ) AS approved_customer_count,

    (
        SELECT
            count(*)

        FROM customer_repeat_90d_base
    ) AS cohort_customer_count;
	
-- Eligibility 검증

SELECT
    is_eligible_90d,
    count(*) AS customer_count

FROM customer_repeat_90d_base

GROUP BY
    is_eligible_90d;
	
SELECT
    min(first_approved_at)
        AS first_purchase_min,

    max(first_approved_at)
        AS first_purchase_max,

    eligibility_cutoff

FROM customer_repeat_90d_base;

-- Label 무결성 검사

SELECT
    is_eligible_90d,
    repeat_90d,
    count(*) AS customer_count

FROM customer_repeat_90d_base

GROUP BY
    is_eligible_90d,
    repeat_90d

ORDER BY
    is_eligible_90d,
    repeat_90d;
	
-- Positive Label 날짜 검증

SELECT
    count(*) AS invalid_positive_label_count

FROM customer_repeat_90d_base

WHERE
    repeat_90d = 1

    AND (
        second_approved_at
            <= first_approved_at

        OR

        second_approved_at
            > datetime(
                first_approved_at,
                '+90 day'
            )
    );
	
-- Negative Label 검증

SELECT
    count(*) AS invalid_negative_label_count

FROM customer_repeat_90d_base AS c

WHERE
    c.repeat_90d = 0

    AND EXISTS (

        SELECT
            1

        FROM order_base AS o

        WHERE
            o.customer_unique_id
                = c.customer_unique_id

            AND o.is_approved_order = 1

            AND o.order_approved_at
                > c.first_approved_at

            AND o.order_approved_at
                <= datetime(
                    c.first_approved_at,
                    '+90 day'
                )
    );

-- 실제 90일 재구매율 계산

SELECT
    count(*) AS eligible_customer_count,

    sum(
        repeat_90d
    ) AS repeat_customer_count,

    round(
        avg(repeat_90d) * 100,
        2
    ) AS repeat_rate_pct

FROM customer_repeat_90d_base

WHERE
    is_eligible_90d = 1;

-- 구매까지 걸린 시간 검증

SELECT
    customer_unique_id,
    first_approved_at,
    second_approved_at,

    round(
        julianday(second_approved_at)
        - julianday(first_approved_at),
        2
    ) AS days_to_repeat

FROM customer_repeat_90d_base

WHERE
    repeat_90d = 1

ORDER BY
    days_to_repeat;
	
-- 최초 구매 검증

SELECT
    count(*) AS invalid_first_purchase_count

FROM customer_repeat_90d_base AS c

WHERE EXISTS (

    SELECT
        1

    FROM order_base AS o

    WHERE
        o.customer_unique_id
            = c.customer_unique_id

        AND o.is_approved_order = 1

        AND o.order_approved_at
            < c.first_approved_at
);

-- Cohort Month 분포 확인

SELECT
    first_purchase_month,

    count(*) AS customer_count,

    sum(
        CASE
            WHEN is_eligible_90d = 1
                THEN 1
            ELSE 0
        END
    ) AS eligible_customer_count

FROM customer_repeat_90d_base

GROUP BY
    first_purchase_month

ORDER BY
    first_purchase_month;