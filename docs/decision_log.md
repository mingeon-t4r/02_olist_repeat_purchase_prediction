# Decision Log

## D001 — Business Objective

Decision:
The model will not be optimized for accuracy alone.

The primary objective is to determine whether machine-learning ranking improves customer selection over a simple rule-based baseline under the same retention campaign capacity.

Status:
Confirmed

---

## D002 — Customer Grain

Decision:
Use customer_unique_id as the customer-level analysis key.

Evidence:
- customers rows: 99,441
- unique customer_id: 99,441
- unique customer_unique_id: 96,096
- duplicated customer_unique_id rows: 3,345

Reason:
customer_id identifies an order-level customer record,
while customer_unique_id connects records belonging
to the same underlying customer.

Impact:
Cohort assignment, repeat-purchase labels,
segmentation, and modeling will use
customer_unique_id as the customer grain.

Status:
Confirmed

---

## D003 — Prediction Snapshot

Decision:
Use order_approved_at as the primary prediction snapshot.

Reason:
Payment approval provides an operationally identifiable point at which a first purchase has been accepted.

Using final delivery status to define the prediction snapshot would rely on information generated later in the order lifecycle.

Data Quality:
160 orders have no recorded order_approved_at, including 14 orders whose final status is delivered.

These rows are excluded from the primary definition rather than imputing an unobserved approval timestamp.

Status:
Confirmed

---

## D004 — 90-Day Label

Decision:
Only customers with a complete 90-day outcome window will receive a repeat_90d label.

Status:
Confirmed

---

## D005 — Valid Purchase Event

Decision:
A purchase event is defined as an order with a non-null order_approved_at.

Reason:
The definition is aligned with the prediction snapshot and avoids relying on future final order status.

Limitation:
Some payment-approved orders may later be canceled.

A fulfilled-order definition may be evaluated later as a sensitivity analysis.

Status:
Confirmed

---

## D006 — Observation End

Decision:
Use the latest observed order_approved_at as the end of the outcome observation period.

Observation End:
2018-09-03 17:40:06

90-Day Eligibility Cutoff:
2018-06-05 17:40:06

Status:
Confirmed

---

## D007 — Order-Level Aggregation

Decision:
Aggregate order_items and order_payments to order_id before joining them to orders.

Reason:
Both source tables contain multiple rows per order.
Pre-aggregation prevents row multiplication and inflated transaction totals.

Status:
Confirmed

---

## D008 — 90-Day Repeat-Purchase Label

Decision:
repeat_90d is defined using payment-approved orders.

repeat_90d = 1 when another approved order occurs strictly after the first approval timestamp and within the following 90 days.

repeat_90d = 0 when the full 90-day window is observable and no additional approved order occurs.

repeat_90d remains NULL when the full outcome window cannot be observed.

Reason:
Treating recent customers as non-repeaters would systematically understate repeat purchase and bias recent cohorts.

Status:
Confirmed

---

## D009 — Same-Day Repeat Orders

Decision:
A separate order approved later than the first approval timestamp is considered a repeat purchase, even when both orders occur on the same calendar date.

Orders with an identical approval timestamp are not treated as post-snapshot repeat purchases.

Reason:
The dataset provides timestamp-level information, allowing the project to use temporal ordering rather than calendar-day differences.

Status:
Confirmed

---

## D010 — Cohort Comparison Window

Decision:
Primary month-to-month cohort comparisons use first-purchase cohorts from 2017-01 through 2018-05.

The 2016 cohorts are retained in the dataset but excluded from the primary stability analysis because observed
customer volume is extremely sparse:
- 2016-10: 317 customers
- 2016-11: no observed cohort
- 2016-12: 1 customer

The 2018-06 cohort is excluded because only part of the month has a complete 90-day observation window.

Reason:
Sparse or partially observed cohorts can create unstable repeat-rate estimates that are not directly comparable with the main observation period.

Status:
Confirmed

---

## D011 — Near-Immediate Repeat Orders

Decision:
Quantify repeat purchases occurring within 1 hour, 24 hours, and 7 days of the first purchase before changing the current repeat_90d definition.

Reason:
Very short intervals may represent behavior different from longer-term customer retention, but the dataset does not directly identify the cause.

Status:
Pending sensitivity review

---

## D012 — First-Purchase Feature Boundary

Decision:
Predictive features are restricted to information
available from the customer's first approved order
at the prediction snapshot.

Allowed feature groups include:

- customer geography
- basket size
- item value
- freight
- payment characteristics
- product category
- purchase timing

Future customer behavior is excluded.

Reason:
The production prediction would be generated immediately
after the first payment-approved purchase.

Status:
Confirmed

---

## D013 — Customer History Features

Decision:
Full-history RFM, total orders, total revenue,
last purchase date, and future category behavior
will not be used as predictors.

Reason:
These values require information generated after
the first-purchase prediction snapshot and would
introduce target leakage.

Status:
Confirmed