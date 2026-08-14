# Healthcare Claims & Revenue Cycle Analytics Dashboard

Independent Health Informatics portfolio project using **SQL + Power BI** and a fully synthetic, de-identified healthcare claims dataset.

## Project goal
Build an end-to-end revenue-cycle analytics workflow that answers practical questions a healthcare data or revenue-cycle analyst may receive:
- How much was billed, allowed, collected, and left outstanding?
- Which payers have the highest denial rates or slowest payment turnaround?
- Which denial reasons account for the most denied dollars?
- How much A/R is aged beyond 90 days?
- Which departments or services should receive follow-up attention?
- Does delayed claim submission appear associated with higher denial rates?

## Tools
- SQL Server / T-SQL
- Power BI / Power Query / DAX
- Python (only to generate reproducible synthetic portfolio data)
- Git/GitHub

## Dataset
The generator creates:
- 6,000 claims
- 900 synthetic patients
- 30 synthetic providers
- 8 payers
- 16 procedures
- 12 diagnosis codes

All data is synthetic and contains **no real PHI**.

## Baseline results from the included seed
The supplied generated dataset contains approximately:
- **6,000 claims**
- **8.0% denied claims**
- **$1.57M billed**
- **$1.08M allowed**
- **$0.94M collected**
- **$0.13M outstanding A/R**
- **87.6% net collection rate**
- **27 days average payment turnaround** among claims with payment dates

These values are a consequence of the synthetic-data rules, not real-world benchmarks.

## Repository structure
```text
healthcare_claims_revenue_cycle_project/
├── README.md
├── generate_synthetic_data.py
├── data/
│   ├── claims.csv
│   ├── patients.csv
│   ├── providers.csv
│   ├── payers.csv
│   ├── procedures.csv
│   └── diagnoses.csv
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_data_quality_checks.sql
│   └── 03_rcm_analysis.sql
├── powerbi/
│   ├── dax_measures.txt
│   └── dashboard_build_guide.md
└── docs/
    ├── data_dictionary.md
    ├── interview_talking_points.md
    ├── resume_linkedin_text.md
    └── screenshot_checklist.md
```

## Workflow
1. Run `generate_synthetic_data.py` to reproduce the CSV files.
2. Create the SQL Server tables using `sql/01_create_schema.sql`.
3. Import the dimension CSVs first, then `claims.csv`.
4. Run `sql/02_data_quality_checks.sql` and confirm the checks are clean.
5. Explore the business questions with `sql/03_rcm_analysis.sql`.
6. Load the CSVs or SQL tables into Power BI.
7. Create the star schema and DAX measures in `powerbi/dax_measures.txt`.
8. Build the three report pages described in `powerbi/dashboard_build_guide.md`.
9. Add screenshots to GitHub only after you have personally built and verified the report.

## Skills demonstrated
- Healthcare claims and revenue-cycle concepts
- Relational/star-schema modeling
- SQL joins, aggregation, CASE expressions, date analysis, quality checks
- KPI definition and business interpretation
- Power Query transformations
- DAX measures
- Power BI dashboard design
- Data validation and documentation
- Reproducible synthetic-data generation

## Interview-safe description
This is an independent portfolio project, not production hospital work. The dataset was intentionally generated to mimic common claims/revenue-cycle relationships so the complete workflow can be published without exposing protected health information.

## Next extensions
After the base dashboard works, optional extensions include remittance adjustment reason codes, resubmission lifecycle events, write-offs, patient payments, authorization status, and a formal denial work queue. Keep these as future enhancements unless you can explain each one clearly.
