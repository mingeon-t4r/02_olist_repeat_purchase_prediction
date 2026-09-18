# 문제 정의

## 비즈니스 배경

신규 고객 전체에게 동일한 유지 활동을 적용하는 것은 비용과 운영 인력 측면에서 비효율적일 수 있다.

고객의 첫 구매가 승인된 시점에서 이미 확인 가능한 정보를 이용해 향후 재구매 가능성이 상대적으로 높은 고객을 식별할 수 있다면, CRM / Retention 팀은 제한된 운영 자원을 우선순위가 높은 고객에게 집중할 수 있다.

## 비즈니스 질문

데이터셋에서 관측된 고객의 첫 구매 시점까지 알 수 있는 정보만으로 향후 90일 이내 재구매 여부를 예측할 수 있는가?

그리고 이 예측 모델은 단순 규칙 기반 고객 우선순위보다 동일한 유지 활동 용량에서 실제 재구매 고객을 더 효과적으로 우선순위화할 수 있는가?

## 의사결정자

CRM / Retention Manager

## 의사결정 시점

고객의 첫 번째 payment-approved order가 확인된 직후

## 의사결정

유지 캠페인 또는 후속 CRM 활동을 수행할 고객의 우선순위를 정한다.

## 분석 단위

고객 1명당 1행

Olist 데이터에서 반복 주문을 동일 고객으로 연결할 수 있는 `customer_unique_id`를 고객 단위 분석 키로 사용한다.

## 예측 기준 시점

고객의 첫 번째 payment-approved order 시점

기준 Timestamp:

`order_approved_at`

`order_approved_at`이 기록되지 않은 주문은 Primary Analysis의 구매 이벤트에서 제외한다.

## 결과 변수

첫 번째 승인 주문 이후 90일 이내 추가 승인 주문 발생 여부를 `repeat_90d`로 정의한다.

`repeat_90d = 1`

첫 승인 주문 이후 90일 이내에 추가 payment-approved order가 존재한다.

`repeat_90d = 0`

90일 전체 관찰 기간 동안 추가 payment-approved order가 존재하지 않는다.

관찰 기간을 완전히 확보할 수 없는 고객은 `repeat_90d = NULL`로 유지한다.

## 분석 대상 조건

90일 Outcome Window를 완전히 관찰할 수 있는 고객만 90일 재구매율 계산과 모델링 대상에 포함한다.

## 비교 방법

1. Rule-Based Baseline
2. Logistic Regression
3. 필요 시 Decision Tree / Random Forest

Logistic Regression을 주 모델로 사용해
Feature 방향과 영향을 해석할 수 있도록 한다.

## 주요 업무 평가 기준

동일한 수의 고객에게 유지 활동을 수행한다고 가정했을 때 각 방법이 실제 90일 재구매 고객을 얼마나 효과적으로 우선순위화하는지 비교한다.

Primary Metrics:

- Precision@K
- Recall@K
- Lift@K

Secondary Metrics:

- PR-AUC
- Precision
- Recall
- F1

## 한계

- 데이터에서 최초로 관측된 구매를 고객 생애 전체의 절대적인 최초 구매라고 단정하지 않는다.
- 예측 가능성과 인과관계는 구분한다.
- 높은 예측 점수가 CRM 캠페인의 실제 효과를 의미하지 않는다.
- 캠페인의 증분 효과는 별도의 실험을 통해 검증해야 한다.
- 매우 짧은 시간 내 발생하는 추가 주문이 장기적인 Retention과 동일한 의미인지는 데이터만으로 확인할 수 없다.