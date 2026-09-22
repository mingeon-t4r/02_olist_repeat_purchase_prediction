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

## Logistic Regression — Test

| Capacity | Customers | Captured Repeat | Precision | Recall | Lift |
|---|---:|---:|---:|---:|---:|
| Top 5% | 708 | 17 | 2.40% | 8.42% | 1.68 |
| Top 10% | 1,416 | 29 | 2.05% | 14.36% | 1.44 |
| Top 20% | 2,833 | 44 | 1.55% | 21.78% | 1.09 |

Test에서는 Logistic Regression의 Ranking 효과가 상위 5% 고객군에서 가장 크게 나타났다.

이는 모델이 가장 높은 확률을 부여한 일부 고객군에는 재구매 고객이 상대적으로 더 집중되어 있음을 보여준다.

---

## Same-Capacity Comparison — Test

Multi-Item Rule이 Test 고객 중 1,466명을 CRM 대상으로 선정하였다.

이는 전체 Test 고객의 약 10.35%에 해당한다.

동일하게 1,466명을 선정하도록 Logistic Regression Ranking과 비교하였다.

### Multi-Item Rule

- Selected Customers: 1,466
- Captured Repeat Customers: 32
- Precision: 2.18%
- Recall: 15.84%
- Lift: 1.53

### Logistic Regression

- Selected Customers: 1,466
- Captured Repeat Customers: 29
- Precision: 1.98%
- Recall: 14.36%
- Lift: 1.39

### Interpretation

Test에서도 Multi-Item Rule이 기본 Logistic Regression보다 높은 성과를 보였다.

동일한 1,466명의 고객에게 CRM Action을 수행한다고 가정했을 때, Multi-Item Rule은 32명의 Repeat 고객을 포착한 반면 Logistic Regression은 29명을 포착하였다.

따라서 Multi-Item Rule은 Logistic Regression보다 3명의 Repeat 고객을 추가로 포착하였다.

Validation에서도 동일한 방향의 결과가 나타났으며, 미래 Test 기간에서도 이 패턴이 재현되었다.

따라서 현재 First-Purchase Feature Set과 기본 Logistic Regression만으로는 단순 Multi-Item Rule보다 추가적인 CRM Ranking 가치를 제공한다고 보기 어렵다.

다만 Logistic Regression의 Test Top 5% Lift는 약 1.68로 나타나, 가장 높은 확률을 부여한 일부 고객군에는 예측 신호가 집중되어 있음을 확인하였다.

따라서 향후에는 추가 Feature Engineering 또는 비선형 모델이 이 Ranking 신호를 개선할 수 있는지 검토할 수 있다.