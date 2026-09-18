# Decision Log

## D001 — 비즈니스 목표

Decision:

모델의 목표를 Accuracy 최대화로 설정하지 않는다.

동일한 CRM 운영 용량에서 머신러닝 기반 고객 Ranking이 단순 Rule-Based Baseline보다 실제 90일 재구매 고객을 더 효과적으로 우선순위화할 수 있는지를 평가한다.

Status:

Confirmed

---

## D002 — 고객 분석 단위

Decision:

고객 단위 분석 Key로 `customer_unique_id`를 사용한다.

Evidence:

- customers rows: 99,441
- unique customer_id: 99,441
- unique customer_unique_id: 96,096
- duplicated customer_unique_id rows: 3,345

Reason:

`customer_id`는 주문과 연결되는 고객 레코드 식별자이고, `customer_unique_id`는 동일 고객의 여러 주문 레코드를 연결할 수 있다.

Impact:

Cohort, 재구매 Target, Segment 및 모델링은 `customer_unique_id` 단위를 기준으로 한다.

Status:

Confirmed

---

## D003 — 예측 기준 시점

Decision:

Primary Prediction Snapshot으로 `order_approved_at`을 사용한다.

Reason:

결제 승인 시점은 첫 구매가 승인되었다고 판단할 수 있는 운영상 식별 가능한 시점이다.

최종 배송 상태를 사용하면 예측 시점 이후에 생성되는 정보를 이용하게 된다.

Data Quality:

`order_approved_at` 결측 주문은 160건이며, 이 중 최종 상태가 delivered인 주문도 14건 존재한다.

관측되지 않은 승인 시간을 임의로 대체하지 않고 Primary Purchase Definition에서 제외한다.

Status:

Confirmed

---

## D004 — 90일 Target 관찰 조건

Decision:

90일 전체 Outcome Window를 관찰할 수 있는 고객에게만 `repeat_90d` Target을 확정한다.

관찰기간이 부족한 고객은 `repeat_90d = 0`으로 처리하지 않는다.

Status:

Confirmed

---

## D005 — 유효 구매 이벤트

Decision:

`order_approved_at IS NOT NULL`인 주문을 Primary Purchase Event로 정의한다.

Reason:

예측 기준 시점과 일관된 구매 정의를 유지하고, 미래의 최종 주문 상태에 의존하지 않기 위해서다.

Limitation:

결제가 승인된 주문 중 일부는 이후 취소될 수 있다.

필요한 경우 delivered 기반 정의를 Sensitivity Analysis로 비교할 수 있다.

Status:

Confirmed

---

## D006 — 관찰 종료 시점

Decision:

가장 늦은 `order_approved_at`을 Outcome Observation End로 사용한다.

Observation End:

2018-09-03 17:40:06

90-Day Eligibility Cutoff:

2018-06-05 17:40:06

Status:

Confirmed

---

## D007 — 주문 단위 집계

Decision:

`order_items`와 `order_payments`는 먼저 `order_id` 단위로 집계한 후 orders와 JOIN한다.

Reason:

두 테이블 모두 주문당 여러 행을 가질 수 있으므로 Raw Table을 직접 JOIN하면 행이 증식하고 금액이 중복 집계될 수 있다.

Status:

Confirmed

---

## D008 — 90일 재구매 Target

Decision:

`repeat_90d`는 payment-approved order 기준으로 정의한다.

`repeat_90d = 1`

첫 승인 주문보다 늦고 90일 이내인 추가 승인 주문이 존재한다.

`repeat_90d = 0`

90일 전체 기간을 관찰할 수 있고 추가 승인 주문이 존재하지 않는다.

`repeat_90d = NULL`

90일 전체 Outcome Window를 관찰할 수 없다.

Reason:

관찰 기간이 부족한 최근 고객을 Non-Repeat 고객으로 처리하면 재구매율이 체계적으로 낮아질 수 있다.

Status:

Confirmed

---

## D009 — 동일 날짜 추가 주문

Decision:

첫 주문보다 Timestamp가 실제로 늦은 별도 주문이면 같은 날짜에 발생하더라도 재구매 후보로 인정한다.

승인 Timestamp가 완전히 동일한 주문은 예측 시점 이후 주문으로 판단하지 않는다.

Reason:

데이터가 Timestamp 수준의 순서를 제공하므로 단순 날짜 차이보다 실제 시간 순서를 사용할 수 있다.

Status:

Confirmed

---

## D010 — Cohort 비교 기간

Decision:

월별 Cohort 안정성의 Primary 비교 기간은 2017-01부터 2018-05까지로 한다.

2016년 Cohort는 데이터에 유지하지만 초기 관측량이 매우 적어 Primary 비교에서 제외한다.

- 2016-10: 317명
- 2016-11: 관측 Cohort 없음
- 2016-12: 1명

2018-06은 해당 월 일부 고객만 90일 전체 Outcome을 관찰할 수 있으므로 제외한다.

Reason:

표본이 극단적으로 작거나 부분 관찰된 Cohort를 전체 월과 직접 비교하면 재구매율이 불안정하게 나타날 수 있다.

Status:

Confirmed

---

## D011 — 초단기 재구매 주문

Decision:

현재 Target을 변경하기 전에 첫 구매 이후 1시간, 24시간, 7일 이내 추가 주문 규모를 먼저 정량화한다.

Observed:

- 1시간 이내: 711명
- 24시간 이내: 773명
- 7일 이내: 921명

Reason:

매우 짧은 간격의 추가 주문은 장기 Retention과 다른 행동일 가능성이 있지만, 데이터에서 그 원인을 직접 확인할 수 없다.

1시간 또는 24시간 이내 주문을 제외했을 때 90일 재구매율이 얼마나 달라지는지 Sensitivity Analysis를 수행한 후 최종 Target 정책을 확정한다.

Status:

Pending sensitivity review

---

## D012 — First-Purchase Feature Boundary

Decision:

예측 Feature는 고객의 첫 번째 승인 주문 시점에 확인 가능한 정보로 제한한다.

사용 가능한 Feature Group:

- 고객 지역
- Basket Size
- 상품 금액
- 배송비
- 결제 정보
- 상품 카테고리
- 판매자 수
- 구매 시간

미래 고객 행동은 제외한다.

Reason:

실제 운영에서 모델 예측은
첫 결제 승인 직후 수행된다는 가정을 사용한다.

Status:

Confirmed

---

## D013 — 고객 전체 이력 Feature

Decision:

다음 고객 전체 이력 Feature는 사용하지 않는다.

- Full-History RFM
- 전체 주문 수
- 전체 매출
- 마지막 구매일
- 미래 카테고리 행동
- 미래 결제 행동

Reason:

해당 값들은 첫 구매 Prediction Snapshot 이후 생성되는 정보를 필요로 하므로 Target Leakage를 발생시킨다.

Status:

Confirmed

---

## D014 — First-Purchase Feature 결측

Observed:

Eligible 고객 78,505명 중

- Item 관련 First-Purchase Feature 결측: 578명
- Payment 관련 Feature 결측: 1명
- Primary Category 결측: 1,877명

Decision:

결측 원인을 확인하기 전에는 해당 고객을 임의로 삭제하거나 값을 임의 대체하지 않는다.

결측 처리 규칙은 데이터 원인을 검증하고
Train / Validation / Test를 분리한 이후
전처리 Pipeline에서 결정한다.

Status:

Pending preprocessing decision