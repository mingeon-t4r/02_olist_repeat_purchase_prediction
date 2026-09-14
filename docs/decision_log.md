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

Candidate Decision:
Use the first valid purchase timestamp.

Candidate fields:
- order_purchase_timestamp
- order_approved_at

Audit Finding:
order_approved_at contains 160 missing values:
- canceled: 141
- delivered: 14
- created: 5

Implication:
order_approved_at cannot be adopted as the prediction
snapshot without defining how valid delivered orders
with missing approval timestamps will be handled.

Status:
Pending

---

## D004 — 90-Day Label

Decision:
Only customers with a complete 90-day outcome window will receive a repeat_90d label.

Status:
Confirmed