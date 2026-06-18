# Financial Fraud Detection System
### IEEE-CIS Fraud Detection | End-to-End Data Analytics Project

---

## Business Problem
A payments company processes 590,000+ transactions with a **3.5% fraud rate**. Missing fraud costs the company directly (average $149/transaction); over-flagging legitimate transactions damages customer trust. This project builds a system that catches fraud early, explains *why* each transaction is flagged, and quantifies the optimal business tradeoff between the two error types.

---

## Headline Findings
> Product category **C has an 11.69% fraud rate — 3.3× the company average.** Mobile transactions carry **1.56× higher fraud risk** than desktop. Fraud peaks at **7AM with a 10.61% rate**, suggesting automated bot-driven attacks during low-monitoring hours.

> Final model (XGBoost) catches **78.4% of fraud** before completion, protecting an estimated **$482,611** per test batch while costing only $80,100 in false-alarm investigation — a **net business value of $402,511**.

---

## Tech Stack
| Tool | Purpose |
|---|---|
| Python (Pandas, NumPy) | Data merging, cleaning, feature engineering at 590K-row scale |
| PostgreSQL | Normalized 4-table schema, indexed analytical queries |
| XGBoost / LightGBM | Gradient boosting fraud classifiers |
| imbalanced-learn (SMOTE) | Class imbalance comparison |
| SHAP (TreeExplainer) | Model explainability, fraud rule derivation |
| Power BI + DAX | 4-page risk intelligence dashboard |
| Streamlit | Live transaction-level fraud scorer |

---

## Project Architecture
---

## Dataset
IEEE-CIS Fraud Detection — [Kaggle Competition](https://www.kaggle.com/c/ieee-fraud-detection)
- 590,540 transactions, 434 raw columns (merged transaction + identity files)
- Real anonymized Vesta/Visa payment data
- 3.5% fraud rate (20,663 fraud cases)

---

## SQL Schema & Key Findings
4 normalized PostgreSQL tables: `fact_transactions`, `dim_identity`, `fact_fraud_features`, `fact_vesta_features` — built with foreign key constraints across 590,540 rows.

Key SQL findings (validated independently of Python EDA):
- Fraud rate by product category: **C = 11.69%**, S = 5.90%, H = 4.77%, R = 3.78%, W = 2.04%
- Mobile fraud rate (**10.17%**) vs Desktop (**6.52%**)
- Discover card has highest fraud rate (**7.73%**); Visa has most fraud in absolute volume (13,373 cases)
- Top 10 highest-value fraud transactions all occurred on ProductCD "W" using Visa/Mastercard

---

## EDA Highlights
- Minimum fraud transaction: **$0.29** — evidence of card-testing behavior (fraudsters validate stolen cards with micro-transactions before larger attacks)
- Maximum fraud transaction: **$5,191**
- 231 of 434 columns had >50% missing values — required a structured drop/impute/encode strategy
- 15 V-columns (of 339) selected via correlation analysis (|r| > 0.05); top predictor V257 (r = 0.383)

---

## Feature Engineering
11 business-justified features engineered, including:
- `log_amt` — log-transformed transaction amount (corrects right-skew)
- `card_txn_count` & `amt_to_card_mean_ratio` — velocity and unusual-spending signals, mirroring real card-network fraud detection logic
- `email_domain_risk` — target-encoded fraud rate per email domain
- `transaction_hour` — extracted from raw TransactionDT, captures the 7AM fraud spike
- `addr_match` — billing/shipping address mismatch flag

Final feature set: 200 columns (down from 434), zero nulls, all categoricals encoded.

---

## Model Comparison

| Model | PR-AUC | AUC-ROC | F1 | Recall |
|---|---|---|---|---|
| Logistic Regression | 0.1678 | 0.7576 | 0.116 | 0.746 |
| **XGBoost (winner)** | **0.6412** | **0.9361** | 0.361 | **0.821** |
| LightGBM | 0.6224 | 0.9301 | 0.338 | 0.820 |
| XGBoost + SMOTE | 0.5294 | 0.8862 | 0.519 | 0.403 |
| Random baseline | 0.035 | — | — | — |

XGBoost with `scale_pos_weight` outperformed SMOTE-based oversampling — PR-AUC used as primary metric given the 3.5% fraud rate makes accuracy and even AUC-ROC misleading on their own.

---

## Cost Matrix Analysis
Defined business costs: **False Negative (missed fraud) = $149**, **False Positive (false alarm) = $10** — a 14.9× cost asymmetry. Computed total business cost across all classification thresholds (0.01–0.99) to find the threshold that minimizes real-world cost rather than maximizing F1.

- Optimal threshold: **0.57**
- Net business value at optimal threshold: **$402,511** per test batch
- Marginal gain over default 0.5 threshold ($9,672) confirmed that `scale_pos_weight` training already pre-calibrates the model effectively for this cost structure

---

## SHAP Explainability
Top 5 fraud predictors (TreeExplainer): `log_amt`, `C14`, `C13`, `card6_risk`, `C1` — Vesta's counting features (C-columns) proved more predictive than the 339 engineered V-columns for this model.

5 fraud prevention rules derived directly from SHAP findings:
1. **High-velocity card alert** — flag cards with >50 transactions
2. **Unusual spending alert** — block transactions >5× a card's historical mean
3. **High-risk email domain alert** — extra verification for disposable domains
4. **Early morning alert** — enhanced monitoring 5AM–9AM (7AM fraud peak)
5. **Product Category C alert** — manual review for C-category transactions >$200

---

## Dashboard Preview
*4-page Power BI dashboard — Fraud Overview, Risk Segmentation, Model Performance, Fraud Rules & Recommendations*

![Dashboard]([dashboard_preview.png](https://github.com/NitinPandey12465/Financial-Fraud-Detection-System/blob/main/fraud_project.pbix))

---

## Live Demo
🚀 **Try it live:** [fraud-risk-scorer.huggingface.co](#) — input transaction details, get instant fraud probability with SHAP-based explanation

---

## How to Run
```bash
pip install pandas numpy scikit-learn xgboost lightgbm shap imbalanced-learn sqlalchemy psycopg2-binary

python load_fraud_to_postgres.py   # loads data into PostgreSQL
python fraud_detection.py          # runs full pipeline
```

---

*Project by Nitin Pandey | B.Tech Production & Industrial Engineering, DTU | Published NLP researcher (ICAIT 2025, IEEE Xplore)*
