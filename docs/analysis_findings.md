# Analysis Findings

## 1. Primary 90-Day Repeat Purchase Target

모델링 대상 고객:

78,505명

Primary Modeling Target:

첫 승인 주문 이후 1시간을 초과한 시점부터
90일 이내에 추가 승인 주문이 발생했는지 여부

Primary Repeat Customers:

1,082명

Primary Repeat Rate:

1.38%

### Reference Target

첫 승인 주문 직후부터 90일까지의
기존 `repeat_90d` 정의에서는:

- Repeat customers: 1,766명
- Repeat rate: 2.25%

### 해석

초단기 주문을 제외한 Primary Modeling Target은
전체 고객의 1.38%만 Positive Class에 해당한다.

모든 고객을 Non-Repeat로 예측해도
약 98.62%의 Accuracy가 나오므로
Accuracy는 주요 모델 평가 지표로 사용하지 않는다.

향후 평가는 다음 지표를 중심으로 진행한다.

- PR-AUC
- Precision@K
- Recall@K
- Lift@K

---

## 2. Cohort Stability

Primary Cohort 비교 기간:

2017-01 ~ 2018-05

2016년 Cohort는 관측 고객 수가 매우 적어 Primary 비교에서 제외한다.

2018-06 Cohort는 해당 월 일부 고객만 90일 전체 Outcome Window를 확보할 수 있으므로 제외한다.

### 분석 결과

Primary 기간의 월별 90일 재구매율은 대략 1.5% ~ 3.4% 범위에서 움직였다.

표본 규모가 더 안정적인 2017-02 이후 Cohort의 대부분은 약 1.5% ~ 2.9% 범위에 분포한다.

시간이 지날수록 재구매율이 지속적으로 상승하거나 지속적으로 하락하는 단순한 패턴은 확인되지 않았다.

현재 결과는 기술적 관찰이며, 추가 통계 검증 없이 기간별 구조적 차이라고 해석하지 않는다.

![Cohort customer count](../reports/figures/cohort_customer_count.png)

![Cohort repeat rate](../reports/figures/cohort_90d_repeat_rate.png)

---

## 3. Repeat Timing

30일 재구매율:

1.53%
(90,718명 관찰 가능)

60일 재구매율:

1.92%
(84,552명 관찰 가능)

90일 재구매율:

2.25%
(78,505명 관찰 가능)

### 해석

각 기간의 재구매율은 각각 해당 Outcome Window를 완전히 관찰할 수 있는 고객을 분모로 사용한다.

따라서 30일, 60일, 90일 비율은 완전히 동일한 고객 집단의 단순 누적 분해값으로 해석하지 않는다.

90일 재구매 고객 1,766명의 첫 구매 이후 다음 승인 주문까지의 중앙값은 약 5.73일이다.

![Cumulative repeat rate](../reports/figures/cumulative_repeat_rate.png)

![Days to repeat](../reports/figures/days_to_repeat_distribution.png)

---

## 4. Near-Immediate Repeat Orders

첫 구매 후 1시간 이내 추가 주문:

711명
(90일 재구매 고객의 40.26%)

첫 구매 후 24시간 이내 추가 주문:

773명
(43.77%)

첫 구매 후 7일 이내 추가 주문:

921명
(52.15%)

### 해석

90일 재구매 고객의 절반 이상이 첫 구매 이후 7일 이내에 추가 승인 주문을 발생시켰다.

특히 전체 90일 재구매 고객의 40.26%가 1시간 이내에 추가 주문을 발생시켰다.

매우 짧은 주문 간격은 장기적인 고객 유지 행동과 다른 현상을 포함하고 있을 가능성이 있다.

하지만 데이터만으로 분할 주문, 추가 구매, 주문 재시도 등 구체적인 원인을 판별할 수 없다.

따라서 현재 Target을 바로 변경하지 않고, 1시간 또는 24시간 이내 주문을 제외한 Sensitivity Analysis 결과를 확인한 뒤 최종 모델링 Target을 결정한다.

---

## 5. First-Purchase Feature Patterns

### 5.1 First Order Value

First Order Value가 관측된 고객:

77,927명

Quartile별 90일 재구매율:

- Q1: 1.43%
- Q2: 1.36%
- Q3: 1.33%
- Q4: 1.39%

### 해석

첫 주문 금액이 커질수록 재구매율도 지속적으로 증가하는 단순한 관계는 나타나지 않았다.

Q1가 가장 높은 재구매율을 보였으며, Q3와 Q2는 Q1과 Q4보다 낮게 나타났다.

따라서 첫 주문 금액만 이용한 단순 Rule은 강한 재구매 우선순위 기준이 아닐 가능성이 있다.

통계적 유의성은 아직 검증하지 않았다.

![Repeat rate by first order value](../reports/figures/first_order_value_repeat_rate.png)

---

### 5.2 Basket Size

`first_item_count`가 결측인 고객 578명을 제외하고 77,927명의 고객을 대상으로 첫 주문의 Basket Size와 90일 재구매율을 비교하였다.

Single-Item Order:

- 고객 수: 70,197명
- 90일 재구매 고객: 925명
- 90일 재구매율: 1.32%

Multi-Item Order:

- 고객 수: 7,730명
- 90일 재구매 고객: 149명
- 90일 재구매율: 1.93%

### 해석

첫 주문에서 2개 이상의 Item을 구매한 고객의 90일 재구매율은 1.93%로, 단일 Item 구매 고객의 1.32%보다 높게 나타났다.

두 그룹의 절대 재구매율 차이는 약 0.61%p이며, Multi-Item 고객의 재구매율은 Single-Item 고객보다 기술적으로 약 46% 높은 수준이다.

따라서 첫 구매의 Basket Size는 향후 재구매 가능성을 구분하는 후보 Feature로서 추가 검증 가치가 있는 것으로 보인다.

다만 현재 결과는 기술 통계 수준의 관찰이며, Basket Size가 재구매를 유발한다고 해석할 수 없다.

또한 두 그룹의 표본 크기가 크게 다르므로 다음 단계에서 비율 차이에 대한 신뢰구간, 통계적 유의성 및 Effect Size를 함께 확인한다.

---

### 5.3 Payment Type

Primary Payment Type별 결과:

- credit_card: 1.38% (n=59,297)
- boleto: 1.31% (n=15,900)
- voucher: 1.77% (n=2,481)
- debit_card: 1.57% (n=826)

### 해석

가장 많은 고객이 사용하는 credit_card와 boleto의 재구매율은 매우 비슷하다.

voucher는 1.77%, debit_card는 1.57%를 보였지만 두 집단의 표본 수는 주요 결제 방식보다 작다.

현재 차이는 기술적 관찰 수준이며, Payment Type을 의미 있는 구분 변수로 판단하기 전에 통계적 불확실성을 검증한다.

---

### 5.4 Product Category

표본 수가 비교적 큰 주요 First-Purchase Category에서도 재구매율 차이가 관측된다.

Examples:

- cama_mesa_banho: 3.80% (n=7,323)
- moveis_decoracao: 3.59% (n=5,147)
- esporte_lazer: 2.85% (n=6,238)
- telefonia: 1.41% (n=3,476)
- eletronicos: 1.01% (n=2,086)
- cool_stuff: 0.90% (n=3,219)

### 해석

첫 구매 상품 Category는 현재 확인한 Feature 중 상대적으로 뚜렷한 재구매율 차이를 보이는 후보 중 하나다.

따라서 모델 Feature 후보로 유지한다.

다만 이러한 차이는 인과관계를 의미하지 않으며, 통계적 검증과 시간 기반 모델 평가를 거친 뒤 실제 예측 가치가 있는지 판단한다.

현재 Category 값은 Olist 원본의 포르투갈어 Category Name을 사용하고 있다.

향후 리포트 가독성을 위해 `category_translation`을 이용한 영문 Category를 추가할 수 있다.

---

### 5.5 Geography

State별 재구매율에도 일부 차이가 관측된다.

하지만 고객 수가 적은 State에서는 재구매율 추정치의 변동성이 매우 크다.

예를 들어 표본 수가 큰 SP와 RJ는 전체 재구매율과 비슷한 수준을 보이는 반면, 일부 중소 규모 State는 상대적으로 높거나 낮은 재구매율을 보인다.

### 해석

Geography는 모델 후보 Feature로 유지한다.

다만 State별 재구매율은 반드시 표본 수와 통계적 불확실성을 함께 고려한다.

표본 수가 매우 작은 State의 높은 재구매율을 독립적인 비즈니스 결과로 해석하지 않는다.

---

## 6. Data Quality Findings

Eligible 고객 78,505명 기준으로 다음 결측이 확인되었다.

First-Order Item 관련 Feature 결측:

578명

First-Order Payment 관련 Feature 결측:

1명

Primary Product Category 결측:

1,877명

### 해석

결측값을 즉시 삭제하거나 평균 및 최빈값으로 임의 대체하지 않는다.

먼저 원천 데이터에서 결측이 발생한 이유를 확인하고, Train / Validation / Test 분리 이후 전처리 Pipeline 안에서 처리 정책을 결정한다.

---

## 7. Target Sensitivity

현재 Primary Target:

- Eligible customers: 78,505명
- Repeat customers: 1,766명
- 90-day repeat rate: 2.25%

Near-Immediate Repeat Order를 제외했을 때의
Sensitivity Analysis 결과는 다음과 같다.

### 1시간 이후 재구매만 인정

- Eligible customers: 78,505명
- Repeat customers: 1,082명
- Repeat rate: 1.38%

기존 Target 대비 재구매 고객은 684명 감소하였다.

이는 기존 Repeat 고객의 약 38.7%에 해당한다.

### 24시간 이후 재구매만 인정

- Eligible customers: 78,505명
- Repeat customers: 1,024명
- Repeat rate: 1.30%

기존 Target 대비 재구매 고객은 742명 감소하였다.

이는 기존 Repeat 고객의 약 42.0%에 해당한다.

### 해석

초단기 주문을 제외하면 90일 재구매율은
2.25%에서 1.38% 또는 1.30%까지 크게 감소한다.

특히 1시간 이내 주문을 제외하는 것만으로
재구매 고객 수가 약 38.7% 감소한다.

반면 1시간 기준과 24시간 기준의 차이는
58명, 재구매율 기준 약 0.08%p에 불과하다.

이는 현재 `repeat_90d` Target의 상당 부분이
첫 구매 직후 매우 짧은 시간 안에 발생하는
추가 주문으로 구성되어 있음을 보여준다.

이러한 주문이 장기적인 고객 Retention과 동일한 의미인지
데이터만으로 확인할 수 없으므로,
초단기 주문을 그대로 모델링 Target에 포함하는 것은
CRM 활용 관점에서 주의가 필요하다.

본 프로젝트에서는 모델링용 Primary Target으로
첫 구매 승인 후 1시간을 초과한 시점부터
90일 이내 발생한 추가 승인 주문을 사용하는 방향을 검토한다.

기존 `repeat_90d`는 원래 정의에 대한
Reference / Sensitivity Target으로 유지한다.

### 해석

Sensitivity 결과를 확인한 후
Near-Immediate Repeat Order를 최종 Target에
포함할지 결정한다.

결과가 확정되기 전까지
기존 `repeat_90d` 정의를 유지한다.

---

## 현재까지의 해석

현재 기술 분석에서는 First-Purchase Category와 Basket Composition이 First Order Value나 주요 Payment Type보다 상대적으로 더 뚜렷한 재구매율 차이를 보일 가능성이 있다.

하지만 현재 단계에서는 어떤 Feature도 통계적으로 검증되었다고 판단하지 않는다.

다음 단계에서는:

- 그룹별 재구매율의 신뢰구간
- 비율 차이 검정
- Effect Size
- 표본 수에 따른 불확실성

을 확인한 뒤 Rule-Based Baseline과 모델 Feature 설계에 반영한다.