# Feature Dictionary

첫 번째 승인 주문 시점에 확인 가능한 정보만 모델 Feature 후보로 정의한다.

| Feature | Source | 정의 | Snapshot에서 사용 가능 | 모델 후보 |
|---|---|---|---|---|
| customer_state | customers | 고객 주(State) | Yes | Yes |
| purchase_weekday | orders | 첫 승인 주문 요일 | Yes | Yes |
| purchase_hour | orders | 첫 승인 주문 시간 | Yes | Yes |
| first_item_count | order_items | 첫 주문 Item 레코드 수 | Yes | Yes |
| first_distinct_product_count | order_items | 첫 주문 고유 상품 수 | Yes | Yes |
| first_seller_count | order_items | 첫 주문 고유 판매자 수 | Yes | Yes |
| first_item_value | order_items | 첫 주문 상품 가격 합계 | Yes | Yes |
| first_freight_value | order_items | 첫 주문 배송비 합계 | Yes | Yes |
| first_order_value | derived | 상품 금액 + 배송비 | Yes | Yes |
| first_freight_ratio | derived | 배송비 / 전체 주문 금액 | Yes | Yes |
| first_avg_item_price | derived | 상품 금액 / Item 수 | Yes | Yes |
| first_payment_record_count | order_payments | 첫 주문 결제 레코드 수 | Yes | Yes |
| first_payment_type_count | order_payments | 첫 주문 결제 방식 수 | Yes | Yes |
| first_payment_value | order_payments | 첫 주문 결제 금액 합계 | Yes | Yes |
| primary_payment_type | order_payments | 결제 금액이 가장 큰 결제 방식 | Yes | Yes |
| first_max_payment_installments | order_payments | 첫 주문 최대 할부 수 | Yes | Yes |
| first_category_count | products | 첫 주문 고유 카테고리 수 | Yes | Yes |
| primary_category | products | 첫 주문 상품금액 합계가 가장 큰 카테고리 | Yes | Yes |
| missing_category_item_count | derived | 카테고리가 없는 Item 수 | Yes | Review |
| customer_unique_id | customers | 고객 식별자 | Yes | No |
| first_order_id | orders | 최초 승인 주문 식별자 | Yes | No |
| first_approved_at | orders | 예측 기준 Timestamp | Yes | No |

## Identifier 처리

다음 값은 데이터 연결과 추적에만 사용하고 모델 Feature로 직접 사용하지 않는다.

`customer_unique_id`

`first_order_id`

`first_approved_at`

Timestamp 자체 대신 필요한 경우 요일, 시간 등 예측 시점에 사용 가능한 파생 Feature를 사용한다.

## 결측 처리

현재 확인된 주요 결측:

- 첫 주문 Item 관련 Feature 결측: 578명
- 첫 주문 Payment 관련 Feature 결측: 1명
- `primary_category` 결측: 1,877명

결측 원인을 확인하기 전에는 임의 삭제 또는 대체하지 않는다.

결측 처리 방식은 Train / Validation / Test 분리 이후 전처리 Pipeline 안에서 최종 결정한다.