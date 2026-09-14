# Olist 90-Day Repeat Purchase Prediction

## Overview

This project evaluates whether customer information available at the first purchase can be used to predict repeat purchase within the following 90 days.

The project focuses not only on predictive performance, but also on whether machine-learning-based ranking provides meaningful improvement over a simple rule-based customer prioritization strategy.

## Business Question

Can information available at a customer's first purchase predict whether the customer will purchase again within 90 days?

And does the prediction model identify retention targets more effectively than a simple rule-based approach?

## Business Use Case

Decision maker:
CRM / Retention Manager

Decision:
Prioritize customers for post-purchase retention activity.

## Dataset

Brazilian E-Commerce Public Dataset by Olist.

Raw data is excluded from this repository.

## Project Scope

1. Data audit and customer identity validation
2. Valid purchase definition
3. First-purchase cohort construction
4. 90-day repeat-purchase label
5. Cohort and retention analysis
6. Customer segmentation
7. Statistical comparison
8. Rule-based baseline
9. Predictive modeling
10. Business-value comparison at fixed campaign capacity

## Evaluation Philosophy

The main goal is not to maximize model accuracy.

The project evaluates whether the model improves customer prioritization under the same operational capacity.

Primary evaluation:
- Precision@K
- Recall@K
- Lift@K