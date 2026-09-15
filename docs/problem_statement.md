# Problem Statement

## Business Context

신규 고객 전체에게 동일한 유지 활동을 적용하는 것은 비용과 운영 인력 측면에서 비효율적일 수 있다.

첫 구매가 완료된 시점에서 이미 확인 가능한 정보를 이용해 향후 재구매 가능성이 상대적으로 높은 고객을 식별할 수 있다면, CRM / Retention 팀은 제한된 운영 자원을 우선순위가 높은 고객에게 집중할 수 있다.

## Business Question

첫 구매 고객의 첫 구매 시점까지 알 수 있는 정보만으로 향후 90일 이내 재구매 여부를 예측할 수 있는가?

그리고 이 예측 모델은 단순 규칙 기반 고객 우선순위보다 실제 유지 대상 선정에 얼마나 더 유용한가?

## Decision Maker

CRM / Retention Manager

## Decision Timing

고객의 첫 구매가 유효한 구매로 확인된 직후

## Decision

유지 캠페인 또는 후속 CRM 활동의 우선 대상 고객을 선정한다.

## Analysis Unit

고객 1명당 1행

Olist 데이터에서는 동일 고객의 주문 이력을 연결할 수 있는 customer_unique_id를 고객 단위 분석 키로 사용한다.

## Prediction Snapshot

고객의 첫 번째 payment-approved order 시점 (order_approved_at)

order_approved_at이 기록되지 않은 주문은 primary analysis의 purchase event에서 제외한다.

## Outcome

첫 번째 승인 주문 이후 90일 이내에 추가 승인 주문이 발생했는지 여부

repeat_90d = 1:
90일 이내 추가 payment-approved order 존재

repeat_90d = 0:
90일 전체 관찰 기간 동안 추가 승인 주문 없음

## Eligibility

90일의 outcome window를 완전히 관찰할 수 있는 고객만 모델링 및 90일 재구매율 계산에 포함한다.

## Comparison

1. Rule-based baseline
2. Logistic Regression
3. 필요 시 Tree-based model

## Primary Business Evaluation

동일한 수의 고객에게 유지 활동을 수행한다고 가정했을 때 각 방법이 실제 90일 재구매 고객을 얼마나 효과적으로 우선순위화하는지 비교한다.

Primary metrics:
- Precision@K
- Recall@K
- Lift@K

Secondary metrics:
- PR-AUC
- Precision
- Recall
- F1

## Limitations

- 데이터에서 최초로 관측된 구매가 고객 생애 전체의 절대적인 최초 구매라고 단정하지 않는다.
- 예측 가능성과 인과관계는 구분한다.
- 높은 예측 점수가 유지 캠페인의 실제 효과를 의미하지 않는다.
- 캠페인 효과 자체는 별도의 실험이 필요하다.