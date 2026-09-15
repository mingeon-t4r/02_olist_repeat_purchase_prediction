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