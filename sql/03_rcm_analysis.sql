/* Core Revenue Cycle Analytics Queries */

-- 1) Executive KPI summary
SELECT
    COUNT(*) AS total_claims,
    SUM(billed_amount) AS total_billed,
    SUM(allowed_amount) AS total_allowed,
    SUM(total_collected) AS total_collected,
    SUM(outstanding_amount) AS outstanding_ar,
    CAST(100.0 * SUM(total_collected) / NULLIF(SUM(billed_amount),0) AS DECIMAL(6,2)) AS gross_collection_rate_pct,
    CAST(100.0 * SUM(total_collected) / NULLIF(SUM(allowed_amount),0) AS DECIMAL(6,2)) AS net_collection_rate_pct,
    CAST(100.0 * SUM(CASE WHEN claim_status='Denied' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(6,2)) AS denial_rate_pct,
    CAST(AVG(CAST(days_to_payment AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_days_to_payment
FROM dbo.Claims;

-- 2) Monthly billing and collections trend
SELECT
    DATEFROMPARTS(YEAR(service_date), MONTH(service_date), 1) AS service_month,
    COUNT(*) AS claim_count,
    SUM(billed_amount) AS billed_amount,
    SUM(allowed_amount) AS allowed_amount,
    SUM(total_collected) AS collected_amount,
    SUM(outstanding_amount) AS outstanding_amount
FROM dbo.Claims
GROUP BY DATEFROMPARTS(YEAR(service_date), MONTH(service_date), 1)
ORDER BY service_month;

-- 3) Payer performance
SELECT
    p.payer_name,
    p.payer_group,
    COUNT(*) AS claim_count,
    SUM(c.billed_amount) AS billed_amount,
    SUM(c.allowed_amount) AS allowed_amount,
    SUM(c.total_collected) AS collected_amount,
    SUM(c.outstanding_amount) AS outstanding_amount,
    CAST(100.0*SUM(CASE WHEN c.claim_status='Denied' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) AS denial_rate_pct,
    CAST(AVG(CAST(c.days_to_payment AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_days_to_payment
FROM dbo.Claims c
JOIN dbo.Payers p ON c.payer_id=p.payer_id
GROUP BY p.payer_name,p.payer_group
ORDER BY denial_rate_pct DESC;

-- 4) Denial root causes
SELECT
    denial_reason_code,
    denial_reason,
    COUNT(*) AS denied_claims,
    SUM(allowed_amount) AS denied_allowed_amount,
    SUM(recovery_amount) AS recovered_amount,
    CAST(100.0*SUM(recovery_amount)/NULLIF(SUM(allowed_amount),0) AS DECIMAL(6,2)) AS recovery_rate_pct
FROM dbo.Claims
WHERE claim_status='Denied'
GROUP BY denial_reason_code,denial_reason
ORDER BY denied_allowed_amount DESC;

-- 5) Denials by payer and reason
SELECT
    p.payer_name,
    c.denial_reason,
    COUNT(*) AS denied_claims,
    SUM(c.allowed_amount) AS denied_allowed_amount
FROM dbo.Claims c
JOIN dbo.Payers p ON c.payer_id=p.payer_id
WHERE c.claim_status='Denied'
GROUP BY p.payer_name,c.denial_reason
ORDER BY denied_allowed_amount DESC;

-- 6) A/R aging
SELECT
    ar_bucket,
    COUNT(*) AS open_claims,
    SUM(outstanding_amount) AS outstanding_ar
FROM dbo.Claims
WHERE outstanding_amount > 0
GROUP BY ar_bucket
ORDER BY CASE ar_bucket WHEN '0-30' THEN 1 WHEN '31-60' THEN 2 WHEN '61-90' THEN 3 WHEN '91-120' THEN 4 WHEN '120+' THEN 5 ELSE 6 END;

-- 7) Department performance
SELECT
    pr.department,
    COUNT(*) AS claim_count,
    SUM(c.billed_amount) AS billed_amount,
    SUM(c.total_collected) AS collected_amount,
    SUM(c.outstanding_amount) AS outstanding_ar,
    CAST(100.0*SUM(CASE WHEN c.claim_status='Denied' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) AS denial_rate_pct
FROM dbo.Claims c
JOIN dbo.Providers pr ON c.provider_id=pr.provider_id
GROUP BY pr.department
ORDER BY outstanding_ar DESC;

-- 8) CPT/service-line reimbursement analysis
SELECT
    prc.service_line,
    prc.cpt_code,
    prc.procedure_description,
    COUNT(*) AS claim_count,
    CAST(AVG(c.billed_amount) AS DECIMAL(12,2)) AS avg_billed,
    CAST(AVG(c.allowed_amount) AS DECIMAL(12,2)) AS avg_allowed,
    CAST(AVG(c.total_collected) AS DECIMAL(12,2)) AS avg_collected,
    CAST(100.0*SUM(CASE WHEN c.claim_status='Denied' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) AS denial_rate_pct
FROM dbo.Claims c
JOIN dbo.Procedures prc ON c.cpt_code=prc.cpt_code
GROUP BY prc.service_line,prc.cpt_code,prc.procedure_description
ORDER BY denial_rate_pct DESC, claim_count DESC;

-- 9) Submission delay and denial risk
SELECT
    CASE
      WHEN days_to_submit <= 7 THEN '0-7 days'
      WHEN days_to_submit <= 14 THEN '8-14 days'
      WHEN days_to_submit <= 30 THEN '15-30 days'
      WHEN days_to_submit <= 45 THEN '31-45 days'
      ELSE '46+ days'
    END AS submission_delay_band,
    COUNT(*) AS claim_count,
    SUM(CASE WHEN claim_status='Denied' THEN 1 ELSE 0 END) AS denied_claims,
    CAST(100.0*SUM(CASE WHEN claim_status='Denied' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) AS denial_rate_pct
FROM dbo.Claims
GROUP BY CASE
      WHEN days_to_submit <= 7 THEN '0-7 days'
      WHEN days_to_submit <= 14 THEN '8-14 days'
      WHEN days_to_submit <= 30 THEN '15-30 days'
      WHEN days_to_submit <= 45 THEN '31-45 days'
      ELSE '46+ days'
    END
ORDER BY MIN(days_to_submit);

-- 10) Largest outstanding balances for follow-up worklist
SELECT TOP 25
    c.claim_id,
    c.service_date,
    p.payer_name,
    pr.department,
    c.claim_status,
    c.denial_reason,
    c.allowed_amount,
    c.total_collected,
    c.outstanding_amount,
    c.ar_bucket
FROM dbo.Claims c
JOIN dbo.Payers p ON c.payer_id=p.payer_id
JOIN dbo.Providers pr ON c.provider_id=pr.provider_id
WHERE c.outstanding_amount > 0
ORDER BY c.outstanding_amount DESC;
