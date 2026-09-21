# 데이터 누수 방지 정책

## 기본 원칙

모델 Feature는 예측 시점에 실제로 확인 가능한 정보만 사용한다.

예측 시점 이후에 생성되는 고객 행동이나 주문 결과를 Feature로 사용하지 않는다.

## 예측 기준 시점

고객의 첫 번째 payment-approved order 시점

기준 Timestamp:

`order_approved_at`

## 사용 가능한 Feature 후보

첫 승인 주문 시점까지 확인 가능한 정보:

- 고객 지역
- 첫 주문 상품 수
- 첫 주문 고유 상품 수
- 첫 주문 상품 금액
- 배송비
- 배송비 비율
- 평균 상품 가격
- 결제 방식
- 할부 수
- 결제 레코드 수
- 상품 카테고리
- 카테고리 다양성
- 판매자 수
- 구매 요일
- 구매 시간

단, Feature가 실제 모델에 포함되는지는 결측률, 표본 수, 통계 분석 및 모델링 과정에서 최종 결정한다.

## 식별자

다음 컬럼은 JOIN과 레코드 추적에는 사용하지만 모델 Feature에는 사용하지 않는다.

- `customer_id`
- `customer_unique_id`
- `order_id`
- `product_id`

## 사용 금지 — 미래 정보

예측 시점 이후에 생성되는 다음 정보는 모델 Feature로 사용할 수 없다.

- 배송 완료 일시
- 실제 배송 지연
- 리뷰 점수
- 리뷰 작성 시점
- 미래 주문 수
- 미래 매출
- 미래 구매 상품 카테고리
- 미래 결제 행동
- 두 번째 주문 시점
- 90일 재구매 결과
- 전체 기간 구매 횟수
- 전체 기간 고객 매출
- 전체 기간 마지막 구매일

## Audit 전용 정보

다음 정보는 데이터 품질 및 Target 검증에는 사용할 수 있지만 ML Feature에는 사용하지 않는다.

- 최종 `order_status`
- `order_delivered_carrier_date`
- `order_delivered_customer_date`
- 리뷰 관련 정보
- `second_approved_at`
- `repeat_90d`
- `second_approved_at_after_1h`
- `repeat_90d_after_1h`

## 추가 검토 대상

### Seller Information

첫 주문에 포함된 판매자 수(`first_seller_count`)는 첫 구매 시점에 확인 가능한 주문 구성 정보이므로 Feature 후보로 사용할 수 있다.

다만 판매자의 이후 배송 성과나 미래 평가 정보는 예측 시점 이후 정보이므로 사용할 수 없다.

### Estimated Delivery Date

`order_estimated_delivery_date`가 실제 주문 승인 시점에 제공되는 값인지 프로젝트 가정과 함께 명확하게 문서화한 뒤
사용 여부를 결정한다.

현재 모델 Feature에서는 제외한다.

## Feature 생성 원칙

고객 전체 이력을 이용해 Feature를 만들지 않는다.

예를 들어 다음 값은 첫 구매 직후에는 존재하지 않으므로 제외한다.

- RFM 기반 Frequency
- 전체 주문 수
- 전체 매출
- 마지막 구매일
- 미래 상품 선호
- 미래 결제 방식

Feature Table은 첫 구매 주문과 해당 주문에 연결된 정보만 사용해 생성한다.