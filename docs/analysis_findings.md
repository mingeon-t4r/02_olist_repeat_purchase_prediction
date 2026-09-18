# Analysis Findings

## 1. Overall 90-Day Repeat Purchase

Eligible customers:
78,505

90-day repeat customers:
1,766

90-day repeat rate:
2.25%

Interpretation:
결과가 불균형하므로 모델 평가를 Accuracy만으로 하면 안된다.

---

## 2. Cohort Stability

Full-month cohort comparison period:
2016-10 to 2018-05

Finding:
구매 후 초기에 재구매율이 유난히 높은 것을 확인했다.
![Full-month cohort count](../reports/figures/cohort_customer_count.png)

---

## 3. Repeat Timing

30-day cumulative repeat rate:
1.53%

60-day cumulative repeat rate:
1.92%

90-day cumulative repeat rate:
2.25%

Finding:
90일 재구매 중 상당수는 첫 30일에 발생한다.

---

## 4. Near-Immediate Repeat Orders

Repeat within 1 hour:
711 (40.26%)

Repeat within 24 hours:
773 (43.77%)

Repeat within 7 days:
921 (52.15%)

Interpretation:
90일 이내 재구매한 고객 중 7일 이내에 재구매한 고객이 반정도이며 전체 40.26%가 1시간 이내에 재구매하였다.
이렇게 유난히 짧은 기간은 최종 유지 목표를 모델링에 사용하기전에 추가적인 분석이 필요하다.

## 5. First-Purchase Feature Patterns

### First Order Value

Finding:
[실제 결과]

### Basket Size

Finding:
[실제 결과]

### Payment Type

Finding:
[실제 결과]

### Product Category

Finding:
[실제 결과]

### Geography

Finding:
[실제 결과]

Interpretation:
Observed group differences are descriptive at this stage.
Statistical uncertainty will be evaluated separately.