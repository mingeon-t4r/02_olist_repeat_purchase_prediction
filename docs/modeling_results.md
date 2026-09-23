# Modeling Results

## Validation Strategy

Random Split 대신 고객의 첫 구매 시점을 기준으로 Time-Based Split을 적용하였다.

### Train

- Customers: 43,916
- Repeat Customers: 617
- Repeat Rate: 1.40%

### Validation

- Customers: 20,420
- Repeat Customers: 263
- Repeat Rate: 1.29%

### Test

- Customers: 14,169
- Repeat Customers: 202
- Repeat Rate: 1.43%

세 구간의 Positive Rate는 약 1.29% ~ 1.43%로, Target prevalence가 시간 구간별로 크게 붕괴하는 패턴은 관찰되지 않았다.

---

## Primary Target

`repeat_90d_after_1h`

첫 승인 주문 후 1시간을 초과한 시점부터 90일까지 추가 승인 주문이 존재하는지를 예측한다.

---

## Logistic Regression — Validation

PR-AUC:

0.0175

ROC-AUC:

0.5739

Validation Repeat Rate:

1.29%

### Top-K Performance

| Capacity | Customers | Precision | Recall | Lift |
|---|---:|---:|---:|---:|
| Top 5% | 1,021 | 1.86% | 7.22% | 1.44 |
| Top 10% | 2,042 | 1.96% | 15.21% | 1.52 |
| Top 20% | 4,084 | 1.76% | 27.38% | 1.37 |

Logistic Regression의 전체적인 구분력은 강하지 않았지만, 상위 Ranking 고객군에서는 전체 평균보다 높은 재구매율을 확인하였다.

---

## Rule-Based Baseline — Validation

Rule:

첫 주문에서 2개 이상의 Item을 구매한 Multi-Item 고객을 우선 대상으로 선정한다.

Selected Customers:

1,990명
(Validation 고객의 약 9.75%)

Results:

- Captured Repeat Customers: 43명
- Precision: 2.16%
- Recall: 16.35%
- Lift: 1.68

---

## Same-Capacity Comparison — Validation

동일하게 1,990명의 고객에게 CRM Action을 수행한다고 가정하였다.

### Multi-Item Rule

- Captured Repeat Customers: 43
- Precision: 2.16%
- Recall: 16.35%
- Lift: 1.68

### Logistic Regression

- Captured Repeat Customers: 39
- Precision: 1.96%
- Recall: 14.83%
- Lift: 1.52

### Interpretation

Validation에서는 Logistic Regression이 단순 Multi-Item Rule보다 높은 성과를 보이지 않았다.

동일한 CRM 처리 용량에서 Multi-Item Rule은 43명의 Repeat 고객을 포착한 반면, Logistic Regression은 39명을 포착하였다.

따라서 현재 Feature Set과 기본 Logistic Regression만으로는 복잡한 모델이 단순 Rule-Based 우선순위보다 추가적인 운영 가치를 제공한다고 판단하기 어렵다.

이는 모델의 복잡성 자체보다 실제 운영 조건에서의 비교가 중요함을 보여준다.

---

## Final Logistic Regression — Test

Validation에서 모델 구조와 전처리 방식을 확정한 뒤, Train과 Validation을 결합한 Development Population으로 최종 Logistic Regression을 다시 학습하였다.

Development Population:

- Customers: 64,336
- Repeat Customers: 880
- Repeat Rate: 1.37%

Final Test:

- Customers: 14,169
- Repeat Customers: 202
- Repeat Rate: 1.43%

### Overall Ranking Metrics

PR-AUC:

0.0169

ROC-AUC:

0.5264

전체적인 Ranking 구분력은 제한적인 수준으로 나타났다.

### Top-K Performance

| Capacity | Customers | Captured Repeat | Precision | Recall | Lift |
|---|---:|---:|---:|---:|---:|
| Top 5% | 708 | 19 | 2.68% | 9.41% | 1.88 |
| Top 10% | 1,416 | 24 | 1.69% | 11.88% | 1.19 |
| Top 20% | 2,833 | 48 | 1.69% | 23.76% | 1.19 |

### Interpretation

Final Logistic Regression은 전체적인 Ranking 성능에서는 제한적인 구분력을 보였다.

다만 가장 높은 확률을 부여한 Top 5% 고객군에서는 Lift 1.88을 기록해 재구매 고객이 상대적으로 집중되어 있음을 확인하였다.

그러나 CRM 대상을 확대할수록 Lift는 빠르게 감소하여 Top 10%와 Top 20%에서는 약 1.19 수준으로 나타났다.

따라서 현재 모델은 극상위 고객군에서는 일부 신호를 보이지만, 넓은 CRM Capacity에서 안정적인 고객 우선순위 모델로 사용하기에는 구분력이 제한적이다.

---

## Same-Capacity Comparison — Final Test

Multi-Item Rule이 선택하는 고객 수와 동일하게 1,466명을 선정하여 최종 Logistic Regression과 비교하였다.

이는 Test Population의 약 10.35%에 해당한다.

### Multi-Item Rule

- Selected Customers: 1,466
- Captured Repeat Customers: 32
- Precision: 2.18%
- Recall: 15.84%
- Lift: 1.53

### Final Logistic Regression

- Selected Customers: 1,466
- Captured Repeat Customers: 24
- Precision: 1.64%
- Recall: 11.88%
- Lift: 1.15

### Interpretation

동일한 CRM 처리 용량에서 Multi-Item Rule은 32명의 Repeat 고객을 포착한 반면, Final Logistic Regression은 24명을 포착하였다.

따라서 Multi-Item Rule은 Final Logistic Regression보다 8명의 Repeat 고객을 추가로 포착하였다.

Validation에서도 Rule-Based Baseline이 Logistic Regression보다 높은 성과를 보였으며, Final Test에서도 같은 방향의 결과가 확인되었다.

현재 First-Purchase Feature Set과 기본 Logistic Regression에서는 머신러닝 모델이 단순 Multi-Item Rule보다 추가적인 운영 가치를 제공하지 못했다.

이는 모델 복잡성 자체보다 명확한 Business Baseline과 동일 운영 용량에서의 비교가 중요함을 보여준다.