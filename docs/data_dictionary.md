# 데이터 사전

## 원천 데이터셋

| Dataset | 분석 단위 | Key | Join Key | 프로젝트 역할 |
|---|---|---|---|---|
| customers | customer_id 레코드 1행 | customer_id | customer_id | 고객 식별 |
| orders | 주문 1건 | order_id | customer_id | 주문 상태 및 시간 |
| order_items | 주문 내 상품 1개 | order_id + order_item_id | order_id | 상품 및 가격 |
| order_payments | 주문 내 결제 레코드 1개 | order_id + payment_sequential | order_id | 결제 정보 |
| products | 상품 1개 | product_id | product_id | 상품 속성 |
| category_translation | 카테고리 매핑 1개 | product_category_name | product_category_name | 카테고리 번역 |

## 고객 분석 단위

분석 Key:

`customer_unique_id`

Grain:

고객 1명당 1행

`customer_id`는 주문과 연결되는 고객 레코드 식별자로 사용하고, 반복 구매 고객을 추적할 때는 `customer_unique_id`를 사용한다.

---

## Analytical Order Base

View:

`order_base`

Grain:

`order_id` 1건당 1행

Source:

- orders
- customers
- order_id 단위로 집계된 order_items
- order_id 단위로 집계된 order_payments

Primary Key:

`order_id`

Customer Key:

`customer_unique_id`

Primary Event:

`order_approved_at`

### 주요 컬럼

| Field | 의미 |
|---|---|
| order_id | 주문 식별자 |
| customer_unique_id | 고객 분석 Key |
| order_approved_at | 구매 승인 시점 |
| is_approved_order | Primary Purchase Event 여부 |
| item_count | 주문 내 Item 레코드 수 |
| distinct_product_count | 주문 내 고유 상품 수 |
| seller_count | 주문 내 고유 판매자 수 |
| item_value | 상품 가격 합계 |
| freight_value | 배송비 합계 |
| payment_record_count | 결제 레코드 수 |
| payment_type_count | 결제 방식 수 |
| payment_value | 결제 금액 합계 |
| max_payment_installments | 최대 할부 개월 수 |

---

## Customer 90-Day Outcome Base

View:

`customer_repeat_90d_base`

Grain:

`customer_unique_id` 1명당 1행

Source:

`order_base`

Primary Key:

`customer_unique_id`

### 주요 컬럼

| Field | 의미 |
|---|---|
| customer_unique_id | 고객 분석 Key |
| first_order_id | 최초 승인 주문 ID |
| first_approved_at | 예측 기준 시점 |
| first_purchase_month | 최초 구매 Cohort 월 |
| observation_end | 승인 주문 기준 데이터 관찰 종료 시점 |
| eligibility_cutoff | 90일 Outcome을 완전히 관찰 가능한 마지막 첫 구매 시점 |
| is_eligible_90d | 90일 Outcome 관찰 가능 여부 |
| second_approved_at | 90일 이내 가장 빠른 추가 승인 주문 시점 |
| repeat_90d | 90일 재구매 Target |

`second_approved_at`과 `repeat_90d`는 Target 생성 및 검증을 위한 결과 정보이며 모델 Feature로 사용하지 않는다.

---

## First-Purchase Feature Base

View:

`first_purchase_feature_base`

Grain:

`customer_unique_id` 1명당 1행

Source:

고객의 첫 번째 승인 주문과 연결된
orders / customers / order_items / order_payments / products

Purpose:

예측 기준 시점에 확인 가능한 첫 구매 정보만 이용해 모델 입력 Feature를 구성한다.

Target 정보는 이 View에 포함하지 않고, 모델링 단계에서 고객 Key를 기준으로 Outcome Table과 결합한다.