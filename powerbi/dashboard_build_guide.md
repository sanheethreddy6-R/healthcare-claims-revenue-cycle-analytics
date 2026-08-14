# Power BI Build Guide

## 1. Load the data
Import the six CSV files from `data/` using **Get Data > Text/CSV**:
- claims.csv
- patients.csv
- providers.csv
- payers.csv
- procedures.csv
- diagnoses.csv

In Power Query, confirm dates are typed as Date, financial fields as Decimal Number, and `days_to_payment` as Whole Number.

## 2. Create the model
Use a simple star schema with Claims as the fact table.

Relationships (one-to-many, single direction):
- Patients[patient_id] 1 -> * Claims[patient_id]
- Providers[provider_id] 1 -> * Claims[provider_id]
- Payers[payer_id] 1 -> * Claims[payer_id]
- Procedures[cpt_code] 1 -> * Claims[cpt_code]
- Diagnoses[icd10_code] 1 -> * Claims[icd10_primary]
- Date[Date] 1 -> * Claims[service_date]

Do not create an additional active relationship from Patients[primary_payer_id] to Payers; it is not needed for this dashboard.

## 3. Create measures
Copy the measures from `dax_measures.txt`. Format currency measures as USD and rate measures as Percentage with one decimal place.

## 4. Page 1 - Revenue Cycle Overview
Use six KPI cards:
- Total Billed
- Total Collected
- Outstanding AR
- Net Collection Rate
- Denial Rate
- Average Days to Payment

Recommended visuals:
1. Line/clustered column chart: Month on axis; Total Billed and Total Collected as values.
2. Bar chart: Payer Name vs Denial Rate.
3. Column chart: AR Bucket vs Outstanding AR.
4. Matrix: Payer Name with Total Claims, Total Billed, Total Collected, Outstanding AR, Denial Rate, Average Days to Payment.
5. Slicers: Service Date, Payer Group, Department, Claim Status.

## 5. Page 2 - Denial Analysis
Recommended visuals:
1. KPI cards: Denied Claims, Denial Rate, Denial Recoveries.
2. Bar chart: Denial Reason vs Denied Claims.
3. Bar chart: Payer Name vs denied allowed amount.
4. Matrix: Denial Reason > Payer Name with claim count, allowed amount, recovery amount.
5. Scatter or column chart: submission-delay band vs Denial Rate (create the band in Power Query or DAX).
6. Table: high-dollar denied claims for follow-up.

Primary business question: **Which denial categories, payers, and operational behaviors are creating the largest avoidable revenue leakage?**

## 6. Page 3 - A/R & Reimbursement
Recommended visuals:
1. KPI cards: Outstanding AR, Open Claims, Open AR 90+ %.
2. Stacked bar: AR Bucket by Payer Name using Outstanding AR.
3. Bar chart: Department vs Outstanding AR.
4. Matrix: Service Line/CPT with Average Billed per Claim, Average Collected per Claim, Denial Rate.
5. Table: top outstanding claims.

Primary business question: **Where should a revenue-cycle team focus follow-up effort to accelerate cash and reduce aged receivables?**

## 7. Formatting rules
- Use a clean 16:9 canvas.
- Keep page backgrounds light and use one accent color for emphasis.
- Avoid more than 8 visuals per page.
- Use clear business titles such as `Denial Rate by Payer` rather than generic names.
- Add an info textbox stating: `Portfolio project using synthetic, de-identified healthcare claims data; no real PHI.`

## 8. What you should be able to explain in an interview
You should be able to explain:
- Why Claims is the fact table and why Payers/Providers/Procedures are dimensions.
- Difference between billed, allowed, collected, contractual adjustment, and outstanding A/R.
- Why denial rate alone is not enough; denied dollars and aging matter too.
- Why you validated the data before building visuals.
- One operational recommendation you derived from the dashboard.
