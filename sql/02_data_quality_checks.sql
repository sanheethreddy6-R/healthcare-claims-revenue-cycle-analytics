/* Run after loading the CSV files. Each query should return 0 rows unless noted. */

-- Duplicate claim IDs
SELECT claim_id, COUNT(*) AS duplicate_count
FROM dbo.Claims
GROUP BY claim_id
HAVING COUNT(*) > 1;

-- Missing required identifiers
SELECT *
FROM dbo.Claims
WHERE claim_id IS NULL OR patient_id IS NULL OR provider_id IS NULL OR payer_id IS NULL;

-- Impossible financial relationships
SELECT claim_id, billed_amount, allowed_amount, total_collected, outstanding_amount
FROM dbo.Claims
WHERE allowed_amount > billed_amount
   OR total_collected < 0
   OR outstanding_amount < 0;

-- Service date later than submission date
SELECT claim_id, service_date, submission_date
FROM dbo.Claims
WHERE submission_date < service_date;

-- Payment date before submission date
SELECT claim_id, submission_date, payment_date
FROM dbo.Claims
WHERE payment_date IS NOT NULL AND payment_date < submission_date;

-- Denied claims should have a denial reason
SELECT claim_id, claim_status, denial_reason
FROM dbo.Claims
WHERE claim_status = 'Denied'
  AND (denial_reason IS NULL OR LTRIM(RTRIM(denial_reason)) = '');

-- Reference integrity (these should all be zero because of foreign keys)
SELECT COUNT(*) AS orphan_payer_rows
FROM dbo.Claims c LEFT JOIN dbo.Payers p ON c.payer_id=p.payer_id
WHERE p.payer_id IS NULL;
