# Tableau Dashboard

## Dashboard

Repeat Purchase & CRM Targeting Dashboard

## Status

Day 4 - Project #2 dashboard draft completed.

## Customer Data Source

- `tableau_customer_repeat_base.csv`
- Grain: 1 row = 1 customer_unique_id
- Population: 90-day eligible customers
- Primary Target: repeat_90d_after_1h

## Model Data Source

- `tableau_model_comparison.csv`
- Grain: 1 row = 1 targeting method
- Comparison: Final Test, same CRM capacity

## KPI

- Eligible Customers
- Repeat Customers
- 90-Day Repeat Rate
- Multi-Item Repeat Rate

## Worksheets

- KPI - Eligible Customers
- KPI - Repeat Customers
- KPI - Repeat Rate
- KPI - Multi-Item Repeat Rate
- Basket Size Repeat Rate
- Monthly Repeat Rate
- Captured Repeat Comparison
- Lift Comparison

## Filters

Customer analysis filters:

- Customer State
- Primary Category
- Primary Payment Type

Model comparison sheets use fixed Final Test results
and are not affected by customer filters.

## Validation

- Eligible Customers: 78,505
- Repeat Customers: 1,082
- Repeat Rate: 1.38%
- Single-Item Repeat Rate: 1.32%
- Multi-Item Repeat Rate: 1.93%
- Rule Captured Repeat: 32
- Logistic Captured Repeat: 24
- Rule Lift: 1.53
- Logistic Lift: 1.15

## Tableau Public

Final publication scheduled for Day 5.