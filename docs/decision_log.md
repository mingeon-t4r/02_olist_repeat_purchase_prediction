# Decision Log

## D001 — Business Objective

Decision:
The model will not be optimized for accuracy alone.

The primary objective is to determine whether machine-learning ranking improves customer selection over a simple rule-based baseline under the same retention campaign capacity.

Status:
Confirmed

---

## D002 — Customer Grain

Candidate Decision:
Use customer_unique_id as the customer-level key.

Reason:
The project requires tracking repeat purchases belonging to the same customer.

Status:
Pending validation in 01_data_audit.ipynb

---

## D003 — Prediction Snapshot

Candidate Decision:
Use the first valid purchase timestamp.

Candidate fields:
- order_purchase_timestamp
- order_approved_at

Status:
Pending order-status and missing-value audit

---

## D004 — 90-Day Label

Decision:
Only customers with a complete 90-day outcome window will receive a repeat_90d label.

Status:
Confirmed