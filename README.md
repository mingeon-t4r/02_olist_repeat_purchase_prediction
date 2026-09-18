# Olist 90-Day Repeat Purchase Prediction

## 프로젝트 개요

이 프로젝트는 Olist 이커머스 데이터를 이용해 데이터셋에서 관측된 고객의 첫 구매 시점에 확인 가능한 정보만으로 향후 90일 이내 재구매 여부를 예측할 수 있는지 분석한다.

단순히 예측 정확도를 높이는 것이 목적이 아니라, 제한된 CRM 운영 자원 아래에서 머신러닝 기반 고객 우선순위가 단순 규칙 기반 방식보다 실제 재구매 고객을 더 효과적으로 선별할 수 있는지를 비교하는 것을 목표로 한다.

## 비즈니스 질문

첫 구매 시점까지 알 수 있는 정보만으로 향후 90일 이내 재구매 고객을 식별할 수 있는가?

그리고 머신러닝 기반 고객 우선순위는 단순 규칙 기반 우선순위보다 동일한 운영 용량에서 실제 재구매 고객을 더 효과적으로 포착할 수 있는가?

## 비즈니스 활용 시나리오

의사결정자:
CRM / Retention Manager

의사결정:
첫 구매 이후 유지 활동을 수행할 고객의 우선순위를 정한다.

예측 기준 시점:
고객의 첫 번째 payment-approved order가 확인된 시점
(`order_approved_at`)

## 데이터

Brazilian E-Commerce Public Dataset by Olist

원본 데이터는 저장소에 포함하지 않는다.

분석에서는 고객의 생애 전체 최초 구매가 아니라 Olist 데이터 관측 기간 내에서 확인되는 최초 구매를 사용한다.

## 프로젝트 범위

1. 데이터 구조 및 고객 식별자 검증
2. 유효 구매 이벤트 정의
3. 주문 단위 분석 테이블 구축
4. 고객별 최초 구매 Cohort 생성
5. 90일 재구매 Target 정의
6. Cohort 및 재구매 Timing 분석
7. 첫 구매 Feature 구축 및 탐색
8. 고객 Segment 통계 비교
9. Rule-based Baseline 구축
10. Logistic Regression 중심 예측 모델 구축
11. 동일 CRM 처리 용량에서 Rule과 ML 비교
12. Precision@K / Recall@K / Lift@K 기반 업무 가치 평가

## 현재 핵심 지표

90일 전체 관찰이 가능한 고객:
78,505명

90일 이내 재구매 고객:
1,766명

90일 재구매율:
2.25%

Target이 매우 불균형하므로 Accuracy를 핵심 지표로 사용하지 않는다.

## 평가 기준

Primary Metrics:

- Precision@K
- Recall@K
- Lift@K

Secondary Metrics:

- PR-AUC
- Precision
- Recall
- F1

필요한 경우 확률 기반 운영을 위해 Calibration도 확인한다.

## 데이터 파이프라인

Raw Olist Data

→ Order-Level Analytical Base

→ Customer-Level First Approved Purchase

→ 90-Day Observation Eligibility

→ Repeat-Purchase Outcome

→ First-Purchase Feature Base

→ Statistical Validation

→ Rule-Based Baseline

→ Predictive Models

→ Top-K Business Comparison

## 주요 설계 원칙

모델 Feature는 첫 구매 예측 시점에 실제로 존재하는 정보만 사용한다.

미래 주문 수, 미래 매출, 배송 완료 결과, 리뷰, 90일 재구매 결과 등 예측 시점 이후 생성되는 정보는 모델 Feature에서 제외한다.

고객 분석 단위는 `customer_unique_id` 1명당 1행이다.

## 현재 분석상 주의사항

90일 재구매 고객 중 상당수가 첫 구매 직후 매우 짧은 시간 안에 추가 주문을 발생시키는 패턴이 확인되었다.

이러한 주문이 장기적인 고객 유지 행동과 동일한 의미인지 데이터만으로 단정할 수 없으므로, 최종 모델링 Target 확정 전에 sensitivity analysis를 수행한다.

## 한계

- 데이터에서 최초로 관측된 구매가 고객 생애 전체의 최초 구매임을 보장하지 않는다.
- 예측 가능성과 인과관계는 구분한다.
- 높은 재구매 확률이 CRM 캠페인의 실제 증분 효과를 의미하지 않는다.
- 캠페인의 인과적 효과를 평가하려면 별도의 실험 설계가 필요하다.