# Analysis Findings

## 1. Overall 90-Day Repeat Purchase

Eligible customers:
78,505

90-day repeat customers:
1,766

90-day repeat rate:
2.25%

Interpretation:
The target is highly imbalanced.

A classifier predicting every customer as non-repeat
would achieve approximately 97.75% accuracy, so accuracy
alone is not an appropriate primary evaluation metric.

Model evaluation will focus on ranking and positive-class
performance such as Precision@K, Recall@K, Lift@K,
and PR-AUC.

---

## 2. Cohort Stability

Primary cohort comparison period:
2017-01 to 2018-05

The 2016 cohorts are excluded from the primary comparison
because observed customer volume is sparse, and 2018-06
is excluded because only part of the month has a complete
90-day outcome window.

Finding:
Across the main observation period, monthly 90-day repeat
rates vary roughly between 1.5% and 3.4%.

For the larger cohorts from 2017-02 onward, most observed
rates fall approximately between 1.5% and 2.9%, without a
simple monotonic upward or downward trend.

These differences remain descriptive and will not be
interpreted as structural changes without further
validation.

![Cohort repeat rate](../reports/figures/cohort_90d_repeat_rate.png)

---

## 3. Repeat Timing

30-day repeat rate:
1.53% (90,718 eligible customers)

60-day repeat rate:
1.92% (84,552 eligible customers)

90-day repeat rate:
2.25% (78,505 eligible customers)

Because each horizon uses the customers with a complete
observation window for that horizon, these rates should
not be interpreted as a decomposition of the same
customer cohort.

Among customers labeled as 90-day repeat purchasers,
the median observed time to the next approved order is
approximately 5.73 days.

![Cumulative repeat rate](../reports/figures/cumulative_repeat_rate.png)

![Days to repeat](../reports/figures/days_to_repeat_distribution.png)

---

## 4. Near-Immediate Repeat Orders

Repeat within 1 hour:
711 (40.26%)

Repeat within 24 hours:
773 (43.77%)

Repeat within 7 days:
921 (52.15%)

Interpretation:
More than half of observed 90-day repeat purchasers place
another approved order within 7 days, and 40.26% do so
within the first hour.

These unusually short intervals may represent behavior
different from longer-term retention.

The dataset does not directly identify the cause, so the
current repeat definition will not be changed solely from
this observation.

A sensitivity analysis excluding near-immediate orders is
performed before the final modeling target is confirmed.

---

## 5. First-Purchase Feature Patterns

### First Order Value

Among 77,927 customers with observed first-order value:

- Q1: 2.38%
- Q2: 2.53%
- Q3: 2.04%
- Q4: 2.06%

A simple monotonic relationship between higher first-order
value and higher repeat purchase is not observed.

![Repeat rate by first order value](../reports/figures/first_order_value_repeat_rate.png)

### Basket Size

Finding:
Pending recalculation after excluding customers with
missing first_item_count from the single-item group.

### Payment Type

The two dominant payment methods have similar observed
repeat rates:

- credit_card: 2.25% (n=59,297)
- boleto: 2.21% (n=15,900)
- voucher: 2.66% (n=2,481)
- debit_card: 1.94% (n=826)

Observed differences are modest and require statistical
validation.

### Product Category

Repeat rates vary across several well-represented
first-purchase categories.

Examples:

- cama_mesa_banho: 3.80% (n=7,323)
- moveis_decoracao: 3.59% (n=5,147)
- esporte_lazer: 2.85% (n=6,238)
- telefonia: 1.41% (n=3,476)
- eletronicos: 1.01% (n=2,086)
- cool_stuff: 0.90% (n=3,219)

Product category therefore appears to be a potentially
useful predictive feature, although these differences are
descriptive rather than causal.

### Geography

Repeat rates show some geographic variation, but estimates
for low-volume states are unstable.

Geography is retained as a candidate predictor, with
state-level sample size and uncertainty considered in
later validation.

---

## 6. Data Quality Findings

Among the 78,505 eligible customers:

- 578 customers have missing first-order item features.
- 1 customer has missing first-order payment features.
- 1,877 customers have no primary product category.

These missing values require explicit preprocessing rules
before statistical testing and model training.

---

## Current Interpretation

The descriptive analysis suggests that first-purchase
category and basket composition may contain more visible
repeat-purchase signal than first-order monetary value or
payment method.

However, no feature is treated as statistically validated
at this stage.

The next step is to quantify uncertainty and compare
repeat rates using statistical tests and effect sizes.