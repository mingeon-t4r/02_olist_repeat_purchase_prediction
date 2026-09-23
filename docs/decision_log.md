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

Confirmed as Reference Target

Note:

Primary Modeling Target은 이후 D011의
`repeat_90d_after_1h` 정의로 변경되었다.

기존 `repeat_90d`는 Target Sensitivity와
분석 설계 추적을 위한 Reference로 유지한다.

---

## D009 — 동일 날짜 추가 주문

Decision:

첫 주문보다 Timestamp가 실제로 늦은 별도 주문이면 같은 날짜에 발생하더라도 재구매 후보로 인정한다.

승인 Timestamp가 완전히 동일한 주문은 예측 시점 이후 주문으로 판단하지 않는다.

Reason:

데이터가 Timestamp 수준의 순서를 제공하므로 단순 날짜 차이보다 실제 시간 순서를 사용할 수 있다.

Status:

Superseded for Primary Modeling Target

Note:

Primary Modeling Target은 D011에 따라
첫 구매 승인 후 1시간을 초과한 주문만
재구매 후보로 인정한다.

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

## D011 — Primary Modeling Target

Decision:

모델링용 Primary Target으로
`repeat_90d_after_1h`을 사용한다.

Definition:

첫 번째 승인 주문 시점으로부터
1시간을 초과한 시점부터 90일까지
추가 승인 주문이 존재하면 1로 정의한다.

Observed:

Reference `repeat_90d`:
- Repeat customers: 1,766
- Repeat rate: 2.25%

After 1 hour:
- Repeat customers: 1,082
- Repeat rate: 1.38%

After 24 hours:
- Repeat customers: 1,024
- Repeat rate: 1.30%

Impact:

1시간 이내 주문을 제외하면
Positive 고객은 684명 감소하며
기존 Positive 고객 대비 약 38.7% 감소한다.

1시간에서 24시간까지 추가로 제외하면
58명만 추가 감소하며
재구매율 차이는 약 0.08%p이다.

Reason:

초단기 추가 주문은 장기적인 CRM Retention과
다른 행동을 포함하고 있을 가능성이 높다.

데이터만으로 실제 주문 의도를 판별할 수는 없지만,
1시간 이내 주문이 Target의 상당한 비중을 차지하는 반면
1시간과 24시간 기준의 차이는 상대적으로 작았다.

따라서 24시간보다 덜 강한 가정을 사용하는
1시간을 Primary Modeling Boundary로 선택한다.

이 Threshold는 모델 성능 최적화를 위해 선택한 것이 아니라
Target을 비즈니스 목적과 정렬하기 위해
모델링 이전에 확정한 정책이다.

기존 `repeat_90d`는 Reference Target으로 유지한다.

Status:

Confirmed

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

## D014 — First-Purchase Feature Missingness

Observed:

Primary Modeling Population인 90일 Outcome 관찰 가능 고객 78,505명에서 다음 결측이 확인되었다.

### Item Feature Missing

Item 관련 First-Purchase Feature 결측:

- 578명
- 전체 Modeling Population의 약 0.74%

결측 주문의 `order_status` 분포:

- unavailable: 552명
- canceled: 23명
- invoiced: 2명
- shipped: 1명

원본 `order_items`를 다시 확인한 결과, 578건 모두 대응되는 `order_items` 레코드가 존재하지 않았다.

따라서 Item Feature 결측은 Feature 생성 과정이나 JOIN 오류가 아니라, 원천 데이터에서 해당 첫 주문의 Item 레코드가 관측되지 않은 데서 발생한 것으로 판단한다.

특히 578건 중 552건이 `unavailable` 상태로, Item 결측은 특정 주문 상태와 강하게 연결된 구조적인 Missing Pattern을 보인다.

### Payment Feature Missing

Payment 관련 Feature 결측:

- 1명

원본 `order_payments`를 확인한 결과, 해당 주문에는 대응되는 Payment Record가 존재하지 않았다.

따라서 Payment Feature 결측 역시 Feature 생성 또는 JOIN 오류가 아니라 원천 데이터의 결측으로 판단한다.

### Product Category Missing

Primary Category 기준 고객 분포:

- observed: 76,628명
- missing_category: 1,299명
- missing_items: 578명

총 Primary Category 결측 고객은 1,877명이다.

이 중 578명은 첫 주문 자체에 `order_items` 레코드가 존재하지 않아 Category를 구성할 수 없는 고객이다.

나머지 1,299명은 Item Record는 존재하지만 `primary_category`가 관측되지 않은 고객이다.

현재 Audit에서는 이 1,299건의 Category 결측이 발생한 세부 원인까지는 확정하지 않는다.

Decision:

결측 고객을 분석 데이터에서 일괄 삭제하지 않는다.

Item 및 Payment 결측은 단순한 임의 대체 대상으로 간주하지 않고, 원천 데이터의 구조적인 Missing Pattern으로 취급한다.

모델링 단계에서는 다음 원칙을 적용한다.

- Item 관련 Feature에는 Missing 여부를 식별할 수 있는   별도의 Indicator를 두는 방식을 우선 검토한다.
- Numeric Feature의 대체값은   Train / Validation / Test 분리 이후 Preprocessing Pipeline 내부에서 결정한다.
- Category 결측은 별도의 Missing / Unknown Category로 처리하는 방식을 우선 검토한다.
- 결측 처리 과정에서 Validation / Test 정보를 이용하지 않는다.
- 결측 고객을 제거하는 방식과 유지하는 방식의 영향은 필요할 경우 Sensitivity Analysis로 비교한다.

Reason:

Item 결측 578건 모두 실제 `order_items`가 존재하지 않았고, 대부분이 `order_status = unavailable`에 집중되어 있어 무작위적인 Feature 계산 실패로 보기 어렵다.

결측 고객을 단순 삭제하면 특정 주문 상태와 연결된 고객군을 체계적으로 제거할 수 있으므로, 결측 자체가 가진 정보를 보존하는 방향이 더 적절하다.

Status:

Cause Confirmed / Preprocessing Policy Defined

---

## D015 — Statistical Interpretation Policy

Decision:

Feature와 Target의 관계는
p-value만으로 판단하지 않는다.

다음을 함께 확인한다.

- Sample Size
- Confidence Interval
- Absolute Difference
- Relative Difference
- Effect Size
- Business Relevance

Reason:

표본이 큰 데이터에서는
실무적으로 작은 차이도 통계적으로
유의하게 나타날 수 있기 때문이다.

Status:

Confirmed

---

## D016 — Temporal Validation Strategy

Decision:

모델 평가는 Random Split이 아니라 첫 구매 시점 기준 Time-Based Split을 사용한다.

- Train: 2018-01-01 이전
- Validation: 2018-01-01 ~ 2018-03-31
- Test: 2018-04-01 이후 Eligibility Cutoff까지

Reason:

실제 운영에서는 과거 고객으로 모델을 구축하고 미래 고객에게 적용하므로, 시간 순서를 보존한 검증이 실제 사용 조건에 더 가깝다.

Status:

Confirmed

---

## D017 — Rule-Based Baseline

Decision:

첫 주문의 `first_item_count >= 2`인 Multi-Item 고객을 우선 선정하는 Rule을 주요 Rule-Based Baseline으로 사용한다.

Evidence:

Training Period에서도 Basket Size에 따른 재구매율 차이가 같은 방향으로 관측되었다.

- Single-Item: 538 / 39,180 = 1.37%
- Multi-Item: 74 / 4,274 = 1.73%

따라서 전체 탐색 분석에서 확인한 Multi-Item 고객의 높은 재구매율 방향성이 Training Period에서도 재확인되었다.

Reason:

Basket Size는 사전 분석과 통계 검증에서 재구매율 차이가 확인되었으며, 운영상 설명이 쉬운 단순 고객 우선순위 규칙이다.

모델의 가치는 이 Rule과 동일한 CRM 처리 용량에서 비교한다.

Status:

Confirmed

---

## D018 — Final Operational Comparison

Decision:

현재 First-Purchase Feature Set에서는 Final Logistic Regression을 Multi-Item Rule보다 우선적인 CRM Ranking 방법으로 채택하지 않는다.

Evidence:

Final Test에서 동일하게 1,466명의 고객을 선정했을 때:

Multi-Item Rule:

- Captured Repeat Customers: 32
- Precision: 2.18%
- Recall: 15.84%
- Lift: 1.53

Final Logistic Regression:

- Captured Repeat Customers: 24
- Precision: 1.64%
- Recall: 11.88%
- Lift: 1.15

Final Logistic Regression은 Top 5%에서는 Lift 1.88을 기록했지만, CRM 대상을 약 10%까지 확대하면 Rule-Based Baseline보다 낮은 성능을 보였다.

Interpretation:

현재 Feature Set에서는 모델 복잡성을 증가시키는 것만으로 추가적인 운영 가치가 확보되지 않았다.

따라서 현 단계에서는 해석 가능하고 운영이 단순한 Multi-Item Rule을 주요 Business Baseline으로 유지한다.

향후 머신러닝 접근은 추가 Feature 또는 비선형 관계가 실질적인 Out-of-Time 성능 개선을 제공하는지 검증하는 방향으로 확장한다.

Status:

Confirmed