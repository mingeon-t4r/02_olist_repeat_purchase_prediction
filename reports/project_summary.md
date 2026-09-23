# Olist 90-Day Repeat Purchase Prediction
## Project Summary

### 1. Problem

첫 구매 고객에게 제한된 CRM 예산을 사용해야 할 때, 어떤 고객을 유지 활동 대상으로 우선 선정해야 하는가?

본 프로젝트는 Olist 데이터에서 관측된 첫 구매 시점까지 확인 가능한 정보만 사용하여 향후 90일 재구매 고객을 우선순위화하는 문제를 다룬다.

머신러닝 모델 자체의 정확도를 높이는 것이 아니라, 동일한 CRM 운영 용량에서 단순 Rule-Based 방식보다 실제 Repeat 고객을 더 많이 포착할 수 있는지를 평가한다.

---

### 2. Target Design

Prediction Snapshot:

`order_approved_at`

Customer Grain:

`customer_unique_id`

90일 Outcome을 완전히 관찰할 수 있는 고객:

78,505명

초기 Reference Target의 재구매율:

2.25%

Sensitivity Analysis 결과, 첫 구매 후 1시간 이내의 추가 주문을 제외하면 재구매율은 1.38%로 감소하였다.

1시간 기준과 24시간 기준의 차이는 0.08%p에 그쳐, CRM Retention 목적에 맞게 `repeat_90d_after_1h`을 Primary Target으로 확정하였다.

Primary Repeat Customers:

1,082명

Primary Repeat Rate:

1.38%

---

### 3. Analysis Design

미래 정보 사용을 방지하기 위해 Feature는 첫 구매 시점에 확인 가능한 정보로 제한하였다.

주요 Feature:

- Basket Size
- First Order Value
- Payment Type
- Product Category
- Customer State
- Purchase Time
- Freight / Item Composition

Missing Feature는 고객을 제거하지 않고 Pipeline 내부에서 처리하였다.

모델 평가는 Random Split이 아닌 First-Purchase Date 기준 Time-Based Split을 사용하였다.

---

### 4. Statistical Findings

Basket Size:

- Single-Item Repeat Rate: 1.32%
- Multi-Item Repeat Rate: 1.93%
- Difference: +0.61%p
- Relative Risk: 1.46
- p = 1.27e-05

Product Category 역시 통계적으로 유의한 관계를 보였지만 Effect Size는 작았다(Cramér's V = 0.0362).

First Order Value와 Payment Type에서는 유의한 관계가 확인되지 않았다.

---

### 5. Modeling

비교 대상:

1. Multi-Item Rule
2. Logistic Regression

Validation 이후 Train과 Validation을 결합해 64,336명의 Development Population으로 최종 Logistic Regression을 재학습하였다.

Final Test:

- Customers: 14,169
- Repeat Customers: 202
- Repeat Rate: 1.43%

Final Logistic Regression:

- PR-AUC: 0.0169
- ROC-AUC: 0.5264
- Top 5% Lift: 1.88

---

### 6. Business Evaluation

동일한 CRM 처리 용량으로 1,466명의 고객을 선정했을 때:

| Method | Captured Repeat | Precision | Recall | Lift |
|---|---:|---:|---:|---:|
| Multi-Item Rule | 32 | 2.18% | 15.84% | 1.53 |
| Logistic Regression | 24 | 1.64% | 11.88% | 1.15 |

Multi-Item Rule은 동일한 운영 용량에서 Final Logistic Regression보다 8명의 Repeat 고객을 추가로 포착하였다.

---

### 7. Conclusion

현재 First-Purchase Feature Set에서는 기본 Logistic Regression이 단순 Multi-Item Rule보다 추가적인 CRM Ranking 가치를 제공하지 못했다.

Logistic Regression은 Top 5% 고객군에서는 일부 Ranking 신호를 보였지만, CRM 대상 범위를 확대하면 성능이 빠르게 감소하였다.

이 결과는 모델 복잡성 자체보다 명확한 Business Baseline, Leakage 방지, Out-of-Time Validation, 동일 운영 조건에서의 평가가 중요함을 보여준다.

---

### 8. Limitations

- 데이터에서 관측된 첫 구매가 고객 생애 최초 구매임을 보장하지 않는다.
- 예측 결과는 CRM 캠페인의 인과적 효과를 의미하지 않는다.
- 캠페인의 실제 Incremental Effect는 별도의 실험이 필요하다.
- 추가 Feature와 비선형 모델은 향후 확장 과제로 남긴다.
- Feature 및 Rule 탐색의 일부가 Temporal Split 이전 전체 Eligible Population에서 수행되었으므로, Final Test는 시간 순서를 보존한 Out-of-Time Evaluation이지만 완전히 사전 격리된 Blind Holdout으로 해석하지 않는다.