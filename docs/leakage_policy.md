# Leakage Policy

## Principle

모델 Feature는 예측 시점에 실제로 존재하는 정보만 사용한다.

## Prediction Snapshot

고객의 첫 번째 payment-approved order 시점
(order_approved_at)

## Candidate Features

첫 구매 시점까지 확인 가능한 후보:

- customer location
- first-order item count
- first-order product diversity
- first-order product value
- freight value
- payment type
- installment count
- purchase weekday
- purchase hour
- product category

## Prohibited Future Information

예측 시점 이후 생성되는 정보:

- delivery completion date
- actual delivery delay
- review score
- review timestamps
- future order count
- future revenue
- future product categories
- future payment behavior
- 90-day repeat outcome

## Identifiers

JOIN과 레코드 추적에는 사용하지만 모델 Feature에는 넣지 않는다.

- customer_id
- customer_unique_id
- order_id
- product_id

## Audit-Only Fields

다음 값은 분석과 데이터 품질 검증에는 사용할 수 있지만
ML Feature에는 사용하지 않는다.

- final order_status
- order_delivered_carrier_date
- order_delivered_customer_date
- review information

## Snapshot-Available Candidates

- customer location
- first-order item count
- first-order product diversity
- first-order item value
- freight value
- payment type
- installment count
- purchase weekday
- purchase hour

## Pending Review

- seller information
- estimated delivery date