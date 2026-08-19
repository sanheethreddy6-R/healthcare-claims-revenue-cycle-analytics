# Healthcare Claims & Revenue Cycle Analytics

A practical healthcare analytics portfolio project using **PostgreSQL, SQL, and Tableau** to analyze healthcare claims, reimbursement, collections, denials, accounts receivable, and payer performance.

The project uses **6,000 synthetic healthcare claims** and demonstrates an end-to-end analytics workflow including database design, data validation, SQL analysis, KPI development, and interactive dashboard creation.

> **Note:** All data in this project is synthetic and created only for educational and portfolio purposes. No real patient information or PHI is used.

---

## Interactive Tableau Dashboard

**[View the Interactive Tableau Dashboard](https://public.tableau.com/app/profile/sanheeth.reddy.kallem5923/viz/HealthcareClaimsRevenueCycleAnalytics/Dashboard2)**

![Healthcare Claims & Revenue Cycle Analytics Dashboard](tableau/dashboard_screenshot.png)

---

## Project Objectives

The goal of this project was to simulate a realistic healthcare revenue cycle analytics workflow and answer questions such as:

* How much revenue was billed, allowed, collected, and still outstanding?
* What is the overall denial rate?
* How efficiently are collectible balances being recovered?
* How long does it take to receive payment?
* Which payers contribute the most collections?
* What are the most common claim denial reasons?
* How much outstanding A/R is concentrated in older aging buckets?
* How do billing and collections change over time?

---

## Tools Used

* **PostgreSQL** — database creation and relational data storage
* **SQL** — data validation, joins, aggregation, KPI calculations, and revenue cycle analysis
* **Tableau Public** — interactive healthcare analytics dashboard
* **Python** — synthetic healthcare claims data generation
* **CSV** — source data files
* **GitHub** — project documentation and version control

---

## Dataset

The project contains:

| Dataset    |  Rows | Description                                     |
| ---------- | ----: | ----------------------------------------------- |
| Claims     | 6,000 | Healthcare claim transactions                   |
| Patients   |   900 | Synthetic patient demographic records           |
| Providers  |    30 | Providers, specialties, and departments         |
| Payers     |     8 | Commercial, government, and self-pay categories |
| Procedures |    16 | CPT-based procedure information                 |
| Diagnoses  |    12 | ICD-10 diagnosis information                    |

The claims dataset includes information such as:

* Claim ID
* Patient ID
* Provider ID
* Payer ID
* CPT code
* ICD-10 diagnosis
* Service date
* Submission date
* Payment date
* Billed amount
* Allowed amount
* Contractual adjustment
* Payer payment
* Patient responsibility
* Total collected
* Outstanding balance
* Claim status
* Denial reason
* A/R aging bucket
* Days to submit
* Days to payment

---

## Data Model

The project uses a claims-centered healthcare data model.

```text
                 patients
                    |
                    |
providers ------ claims ------ payers
                    |
                    |
               procedures
                    |
                    |
               diagnoses
```

Relationships:

```text
claims.patient_id    → patients.patient_id
claims.provider_id   → providers.provider_id
claims.payer_id      → payers.payer_id
claims.cpt_code      → procedures.cpt_code
claims.icd10_primary → diagnoses.icd10_code
```

---

## PostgreSQL Workflow

### 1. Create the database tables

Run:

```text
sql/01_create_schema_postgresql.sql
```

This creates the following tables:

* claims
* patients
* providers
* payers
* procedures
* diagnoses

### 2. Load the synthetic data

Run:

```text
sql/04_load_data_postgresql.sql
```

Expected row counts:

```text
claims       6000
diagnoses      12
patients      900
payers          8
procedures     16
providers      30
```

### 3. Perform data quality checks

Run:

```text
sql/02_data_quality_checks_postgresql.sql
```

The validation process checks for:

* Duplicate claim IDs
* Missing identifiers
* Invalid financial amounts
* Incorrect date sequences
* Denied claims without denial reasons
* Missing payer references
* Missing patient references
* Missing provider references
* Missing CPT references
* Missing ICD-10 references

### 4. Run the revenue cycle analysis

Run:

```text
sql/03_rcm_analysis_postgresql.sql
```

The analysis includes:

* Executive KPI summary
* Monthly billing and collections trends
* Payer performance
* Denial analysis
* A/R aging analysis
* Reimbursement analysis
* High-value outstanding claims
* Revenue cycle operational metrics

---

## Key Revenue Cycle KPIs

The synthetic dataset produced the following results:

| KPI                     |     Result |
| ----------------------- | ---------: |
| Total Claims            |      6,000 |
| Total Billed            |     $1.57M |
| Total Allowed           |     $1.08M |
| Total Collected         |     $0.94M |
| Outstanding A/R         |   $133.71K |
| Gross Collection Rate   |     59.88% |
| Net Collection Rate     |     87.57% |
| Denial Rate             |      8.02% |
| Average Days to Payment | 27.05 days |

These values are generated from the synthetic dataset and should not be interpreted as real hospital benchmarks.

---

## Tableau Dashboard

The Tableau dashboard includes:

### Executive KPIs

* Total Claims
* Total Billed
* Total Collected
* Outstanding A/R
* Net Collection Rate
* Denial Rate
* Average Days to Payment

### Revenue Cycle Visualizations

* Monthly Billing vs Collections Trend
* Payer Performance
* Outstanding A/R by Aging Bucket
* Claims Denied by Reason

### Interactive Filters

The dashboard can be filtered by:

* Payer Group
* Department
* Service Month

The payer performance visualization can also be used interactively to filter other dashboard components.

---

## Selected Findings

### Revenue Collection

Approximately **$1.57 million** was billed across 6,000 synthetic claims, while approximately **$941K** was collected.

### Net Collection Performance

The calculated **net collection rate was 87.57%**, indicating that most of the collectible allowed amount was recovered while some balances remained outstanding.

### Claim Denials

The dataset produced an overall **denial rate of 8.02%**.

Common denial categories included:

* Authorization missing or invalid
* Coding or medical necessity issues
* Missing documentation
* Eligibility or coverage issues
* Timely filing limits
* Duplicate claims

### Accounts Receivable

Approximately **$133.71K** remained in outstanding A/R.

The A/R aging analysis was used to identify balances requiring follow-up, especially claims in older aging categories.

### Payment Turnaround

The average payment turnaround was approximately **27 days**.

### Payer Analysis

Payer-level analysis was used to compare collections across commercial, government, and self-pay payer groups and identify differences in reimbursement performance.

---

## Repository Structure

```text
healthcare-claims-revenue-cycle-analytics/
│
├── README.md
│
├── generate_synthetic_data.py
│
├── data/
│   ├── claims.csv
│   ├── patients.csv
│   ├── providers.csv
│   ├── payers.csv
│   ├── procedures.csv
│   └── diagnoses.csv
│
├── sql/
│   ├── 01_create_schema_postgresql.sql
│   ├── 02_data_quality_checks_postgresql.sql
│   ├── 03_rcm_analysis_postgresql.sql
│   └── 04_load_data_postgresql.sql
│
├── tableau/
│   ├── README.md
│   └── dashboard_screenshot.png
│
└── docs/
    ├── data_dictionary.md
    ├── interview_talking_points.md
    ├── resume_linkedin_text.md
    └── screenshot_checklist.md
```

---

## Skills Demonstrated

* Healthcare claims analytics
* Revenue cycle management analytics
* PostgreSQL
* SQL querying
* Relational database design
* Data validation
* Data quality analysis
* Healthcare financial KPIs
* Claims denial analysis
* Accounts receivable analysis
* Payer performance analysis
* Tableau dashboard development
* Data visualization
* Healthcare reporting
* Analytical problem solving

---

## How to Reproduce the Project

1. Download or clone the repository.
2. Install PostgreSQL and pgAdmin.
3. Create a PostgreSQL database such as `healthcare_rcm`.
4. Run `01_create_schema_postgresql.sql`.
5. Run `04_load_data_postgresql.sql`.
6. Run `02_data_quality_checks_postgresql.sql`.
7. Run `03_rcm_analysis_postgresql.sql`.
8. Open the CSV files in Tableau Public.
9. Create relationships between the claims table and dimension tables.
10. Build the KPIs and revenue cycle visualizations.
11. Assemble the Tableau dashboard.
12. Publish the dashboard to Tableau Public.

---

## Portfolio Purpose

This project was developed as an independent health informatics portfolio project to demonstrate practical skills relevant to roles such as:

* Healthcare Data Analyst
* Revenue Cycle Analyst
* Clinical Data Analyst
* Health Informatics Analyst
* Reporting Analyst
* EHR / Clinical Systems Analyst
* Healthcare Business Intelligence Analyst

---

## Disclaimer

This project is an independent portfolio project.

All patients, providers, claims, financial values, diagnoses, procedures, and payer records are **synthetically generated**.

The dataset does not contain real patient information, protected health information, or confidential healthcare data.
