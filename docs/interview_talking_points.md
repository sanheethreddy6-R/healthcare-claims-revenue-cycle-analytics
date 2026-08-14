# Interview Talking Points

## 30-second project explanation
I built an independent healthcare revenue-cycle analytics project using a synthetic claims dataset with about 6,000 claims. I designed a star schema, validated claim-level data in SQL, created revenue-cycle KPIs such as denial rate, net collection rate, outstanding A/R, and days to payment, and designed a Power BI dashboard to identify payer, denial, and aging patterns. I used synthetic de-identified data so the project is safe to publish and can be reproduced.

## Questions you should be ready for
### Why did you choose these KPIs?
They connect directly to claim reimbursement and cash flow: collections show realized revenue, denial rate and denied dollars show payment friction, A/R aging shows where follow-up is needed, and days to payment shows reimbursement speed.

### How did you validate the data?
I checked duplicate claim IDs, null identifiers, invalid date sequences, financial inconsistencies, missing denial reasons, and foreign-key integrity before analysis.

### Why a star schema?
It separates transaction-level claims from descriptive dimensions such as payer, provider, procedure, and diagnosis. That makes filtering and aggregation simpler and mirrors the structure commonly used in BI reporting.

### What is a useful finding to discuss?
Use the dashboard you build to identify one payer or denial reason with an above-average denial rate or a large amount of aged A/R. Explain the operational response: prioritize work queues, investigate authorization/coding/documentation issues, or review submission delays.

### What would you improve in a production environment?
I would add true claim lifecycle events, remittance/ERA detail, resubmission history, adjustment reason codes, patient-payment status, write-offs, and a formal data-quality pipeline. I would also apply role-based security and PHI controls to real healthcare data.

## Important honesty point
Do not describe this as paid work or production hospital experience. Call it an **Independent Health Informatics Project** or **Portfolio Project** using synthetic data.
