/* Healthcare Claims & Revenue Cycle Analytics - PostgreSQL analysis queries */

-- 1) Executive KPI summary
SELECT
    COUNT(*) AS total_claims,
    ROUND(SUM(billed_amount), 2) AS total_billed,
    ROUND(SUM(allowed_amount), 2) AS total_allowed,
    ROUND(SUM(total_collected), 2) AS total_collected,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_ar,
    ROUND(100.0 * SUM(total_collected) / NULLIF(SUM(billed_amount), 0), 2) AS gross_collection_rate_pct,
    ROUND(100.0 * SUM(total_collected) / NULLIF(SUM(allowed_amount), 0), 2) AS net_collection_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS denial_rate_pct,
    ROUND(AVG(days_to_payment)::numeric, 2) AS avg_days_to_payment
FROM claims;

-- 2) Monthly billing and collections trend
SELECT
    DATE_TRUNC('month', service_date)::date AS service_month,
    COUNT(*) AS claim_count,
    ROUND(SUM(billed_amount), 2) AS billed_amount,
    ROUND(SUM(allowed_amount), 2) AS allowed_amount,
    ROUND(SUM(total_collected), 2) AS collected_amount,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_amount
FROM claims
GROUP BY DATE_TRUNC('month', service_date)::date
ORDER BY service_month;

-- 3) Payer performance
SELECT
    p.payer_name,
    p.payer_group,
    COUNT(*) AS claim_count,
    ROUND(SUM(c.billed_amount), 2) AS billed_amount,
    ROUND(SUM(c.allowed_amount), 2) AS allowed_amount,
    ROUND(SUM(c.total_collected), 2) AS collected_amount,
    ROUND(SUM(c.outstanding_amount), 2) AS outstanding_amount,
    ROUND(100.0 * SUM(CASE WHEN c.claim_status = 'Denied' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS denial_rate_pct,
    ROUND(AVG(c.days_to_payment)::numeric, 2) AS avg_days_to_payment
FROM claims c
JOIN payers p ON c.payer_id = p.payer_id
GROUP BY p.payer_name, p.payer_group
ORDER BY denial_rate_pct DESC;

-- 4) Denial root causes
SELECT
    denial_reason_code,
    denial_reason,
    COUNT(*) AS denied_claims,
    ROUND(SUM(allowed_amount), 2) AS denied_allowed_amount,
    ROUND(SUM(recovery_amount), 2) AS recovered_amount,
    ROUND(100.0 * SUM(recovery_amount) / NULLIF(SUM(allowed_amount), 0), 2) AS recovery_rate_pct
FROM claims
WHERE claim_status = 'Denied'
GROUP BY denial_reason_code, denial_reason
ORDER BY denied_allowed_amount DESC;

-- 5) Denials by payer and reason
SELECT
    p.payer_name,
    c.denial_reason,
    COUNT(*) AS denied_claims,
    ROUND(SUM(c.allowed_amount), 2) AS denied_allowed_amount
FROM claims c
JOIN payers p ON c.payer_id = p.payer_id
WHERE c.claim_status = 'Denied'
GROUP BY p.payer_name, c.denial_reason
ORDER BY denied_allowed_amount DESC;

-- 6) A/R aging
SELECT
    ar_bucket,
    COUNT(*) AS open_claims,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_ar
FROM claims
WHERE outstanding_amount > 0
GROUP BY ar_bucket
ORDER BY CASE ar_bucket
    WHEN '0-30' THEN 1
    WHEN '31-60' THEN 2
    WHEN '61-90' THEN 3
    WHEN '91-120' THEN 4
    WHEN '120+' THEN 5
    ELSE 6
END;

-- 7) Department performance
SELECT
    pr.department,
    COUNT(*) AS claim_count,
    ROUND(SUM(c.billed_amount), 2) AS billed_amount,
    ROUND(SUM(c.total_collected), 2) AS collected_amount,
    ROUND(SUM(c.outstanding_amount), 2) AS outstanding_ar,
    ROUND(100.0 * SUM(CASE WHEN c.claim_status = 'Denied' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS denial_rate_pct
FROM claims c
JOIN providers pr ON c.provider_id = pr.provider_id
GROUP BY pr.department
ORDER BY outstanding_ar DESC;

-- 8) CPT/service-line reimbursement analysis
SELECT
    pc.service_line,
    pc.cpt_code,
    pc.procedure_description,
    COUNT(*) AS claim_count,
    ROUND(AVG(c.billed_amount), 2) AS avg_billed,
    ROUND(AVG(c.allowed_amount), 2) AS avg_allowed,
    ROUND(AVG(c.total_collected), 2) AS avg_collected,
    ROUND(100.0 * SUM(CASE WHEN c.claim_status = 'Denied' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS denial_rate_pct
FROM claims c
JOIN procedures pc ON c.cpt_code = pc.cpt_code
GROUP BY pc.service_line, pc.cpt_code, pc.procedure_description
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
    SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) AS denied_claims,
    ROUND(100.0 * SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS denial_rate_pct
FROM claims
GROUP BY 1
ORDER BY MIN(days_to_submit);

-- 10) Largest outstanding balances for follow-up worklist
SELECT
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
FROM claims c
JOIN payers p ON c.payer_id = p.payer_id
JOIN providers pr ON c.provider_id = pr.provider_id
WHERE c.outstanding_amount > 0
ORDER BY c.outstanding_amount DESC
LIMIT 25;
