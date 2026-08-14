# Data Dictionary

## Claims fact table
| Field | Meaning |
|---|---|
| claim_id | Synthetic unique claim identifier |
| encounter_id | Synthetic encounter identifier |
| patient_id | Foreign key to patient dimension |
| provider_id | Foreign key to provider dimension |
| payer_id | Foreign key to payer dimension |
| service_date | Date healthcare service occurred |
| submission_date | Date claim was submitted |
| payment_date | Payment date; blank for unpaid claims |
| cpt_code | Procedure/service code |
| icd10_primary | Primary diagnosis code |
| claim_status | Paid, Partially Paid, Denied, or Pending |
| denial_reason_code | Synthetic denial category code |
| denial_reason | Human-readable denial category |
| appeal_status | Not Appealed, Appeal Pending, or Overturned for denied claims |
| billed_amount | Gross charge submitted on the claim |
| allowed_amount | Contractually allowed amount |
| contractual_adjustment | Billed amount minus allowed amount |
| payer_paid_amount | Amount paid by payer |
| patient_responsibility | Copay/coinsurance/deductible/self-pay amount represented in project |
| recovery_amount | Synthetic amount recovered after an overturned denial |
| total_collected | Payer payment + patient responsibility + recovery amount |
| outstanding_amount | Allowed amount minus collected amount, floored at zero |
| days_to_submit | Days from service to initial submission |
| days_to_payment | Days from submission to payment; blank if unpaid |
| ar_bucket | Closed, 0-30, 31-60, 61-90, 91-120, 120+ as of 2026-01-31 |

## Dimension tables
- **Patients:** synthetic ID, date of birth, gender, state, primary payer ID.
- **Providers:** synthetic provider ID, specialty, department.
- **Payers:** payer ID, payer name, payer group.
- **Procedures:** CPT-like code, description, service line, standard charge used to seed the synthetic data.
- **Diagnoses:** ICD-10 code and diagnosis description.

## Privacy note
All records are generated for portfolio education. They do not represent real patients, providers, claims, or protected health information.
