/* Healthcare Claims & Revenue Cycle Analytics - PostgreSQL data quality checks
   Run after loading all six CSV files.
   Most detail queries should return 0 rows.
*/

-- 1) Row counts: useful load verification.
SELECT 'payers' AS table_name, COUNT(*) AS row_count FROM payers
UNION ALL SELECT 'providers', COUNT(*) FROM providers
UNION ALL SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL SELECT 'diagnoses', COUNT(*) FROM diagnoses
UNION ALL SELECT 'patients', COUNT(*) FROM patients
UNION ALL SELECT 'claims', COUNT(*) FROM claims
ORDER BY table_name;

-- 2) Duplicate claim IDs: should return 0 rows.
SELECT claim_id, COUNT(*) AS duplicate_count
FROM claims
GROUP BY claim_id
HAVING COUNT(*) > 1;

-- 3) Missing required identifiers: should return 0 rows.
SELECT *
FROM claims
WHERE claim_id IS NULL
   OR patient_id IS NULL
   OR provider_id IS NULL
   OR payer_id IS NULL;

-- 4) Impossible financial relationships: should return 0 rows.
SELECT claim_id, billed_amount, allowed_amount, total_collected, outstanding_amount
FROM claims
WHERE allowed_amount > billed_amount
   OR total_collected < 0
   OR outstanding_amount < 0;

-- 5) Submission before service date: should return 0 rows.
SELECT claim_id, service_date, submission_date
FROM claims
WHERE submission_date < service_date;

-- 6) Payment before submission date: should return 0 rows.
SELECT claim_id, submission_date, payment_date
FROM claims
WHERE payment_date IS NOT NULL
  AND payment_date < submission_date;

-- 7) Denied claims without a denial reason: should return 0 rows.
SELECT claim_id, claim_status, denial_reason
FROM claims
WHERE claim_status = 'Denied'
  AND (denial_reason IS NULL OR TRIM(denial_reason) = '');

-- 8) Orphaned payer references: should return 0.
SELECT COUNT(*) AS orphan_payer_rows
FROM claims c
LEFT JOIN payers p ON c.payer_id = p.payer_id
WHERE p.payer_id IS NULL;

-- 9) Orphaned patient/provider/procedure/diagnosis references: all should be 0.
SELECT
    SUM(CASE WHEN pt.patient_id IS NULL THEN 1 ELSE 0 END) AS orphan_patient_rows,
    SUM(CASE WHEN pr.provider_id IS NULL THEN 1 ELSE 0 END) AS orphan_provider_rows,
    SUM(CASE WHEN pc.cpt_code IS NULL THEN 1 ELSE 0 END) AS orphan_procedure_rows,
    SUM(CASE WHEN d.icd10_code IS NULL THEN 1 ELSE 0 END) AS orphan_diagnosis_rows
FROM claims c
LEFT JOIN patients pt ON c.patient_id = pt.patient_id
LEFT JOIN providers pr ON c.provider_id = pr.provider_id
LEFT JOIN procedures pc ON c.cpt_code = pc.cpt_code
LEFT JOIN diagnoses d ON c.icd10_primary = d.icd10_code;
