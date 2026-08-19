# Healthcare Claims & Revenue Cycle Analytics — Interview Talking Points

## 30-Second Project Explanation

I built an independent healthcare claims and revenue cycle analytics project using PostgreSQL, SQL, Python, and Tableau. I worked with 6,000 synthetic healthcare claims along with patient, provider, payer, procedure, and diagnosis data. I performed data quality checks, analyzed revenue cycle KPIs such as collections, denial rate, A/R aging, payer performance, and payment turnaround, and then built an interactive Tableau dashboard to present the results.

---

## What Was the Goal of the Project?

The goal was to simulate a realistic healthcare revenue cycle analytics workflow and understand how claims data can be used to monitor billing, collections, denials, payer performance, and outstanding accounts receivable.

---

## Why Did You Use Synthetic Data?

I wanted to build a realistic healthcare analytics project without using real patient information or PHI. I generated synthetic claims data that allowed me to practice the complete workflow while maintaining privacy and compliance.

---

## What Data Did You Work With?

The project included:

* 6,000 healthcare claims
* 900 patients
* 30 providers
* 8 payers
* 16 procedures
* 12 diagnoses

The claims included fields such as service date, submission date, payment date, billed amount, allowed amount, total collected, outstanding balance, claim status, denial reason, A/R bucket, payer, provider, CPT code, and ICD-10 diagnosis.

---

## What Did You Do in PostgreSQL?

I created a relational healthcare claims database in PostgreSQL and loaded the synthetic datasets into six related tables.

I then used SQL to perform:

* Data quality validation
* Duplicate checks
* Missing-value checks
* Referential integrity checks
* Billing and collection analysis
* Denial analysis
* Payer performance analysis
* A/R aging analysis
* Monthly revenue trend analysis
* Payment turnaround analysis

---

## What Data Quality Checks Did You Perform?

Before starting the analysis, I checked for:

* Duplicate claim IDs
* Missing patient, provider, or payer identifiers
* Invalid financial values
* Payment dates occurring before submission dates
* Submission dates occurring before service dates
* Denied claims without denial reasons
* Missing patient, payer, provider, CPT, or ICD-10 references

The goal was to make sure the data was reliable before calculating revenue cycle KPIs.

---

## Key Results

The synthetic dataset produced:

* Total Claims: 6,000
* Total Billed: $1.57M
* Total Allowed: $1.08M
* Total Collected: $0.94M
* Outstanding A/R: $133.71K
* Gross Collection Rate: 59.88%
* Net Collection Rate: 87.57%
* Denial Rate: 8.02%
* Average Days to Payment: 27.05 days

These results are based entirely on synthetic portfolio data and are not real hospital benchmarks.

---

## What Is Net Collection Rate?

Net collection rate measures how much of the collectible amount was actually collected after contractual adjustments.

In this project, I calculated it as:

Total Collected / Allowed Amount

The result was approximately 87.57%.

---

## What Is the Difference Between Gross and Net Collection Rate?

Gross collection rate compares collections against the original billed charges.

Net collection rate compares collections against the amount the organization was actually entitled to collect after contractual adjustments.

Net collection rate is more useful for evaluating collection effectiveness because billed charges can be significantly higher than negotiated reimbursement amounts.

---

## How Did You Analyze Denials?

I filtered claims with a denied status and analyzed:

* Number of denied claims
* Overall denial rate
* Denials by payer
* Denials by denial reason
* High-value denied claims

The overall denial rate in the synthetic dataset was approximately 8.02%.

---

## What Denial Reasons Did You Analyze?

The synthetic data included reasons such as:

* Authorization missing or invalid
* Coding or medical necessity issues
* Missing documentation
* Eligibility or coverage issues
* Timely filing limits
* Duplicate claims

This helped identify where claim follow-up or workflow improvements could be prioritized.

---

## What Is A/R Aging?

A/R aging shows how long outstanding balances have remained unpaid.

I grouped outstanding claims into aging buckets such as:

* 31–60 days
* 61–90 days
* 91–120 days
* 120+ days

This allows revenue cycle teams to prioritize older balances for follow-up.

---

## What Did You Build in Tableau?

I created an interactive Tableau dashboard containing:

### KPI Cards

* Total Claims
* Total Billed
* Total Collected
* Outstanding A/R
* Net Collection Rate
* Denial Rate
* Average Days to Payment

### Visualizations

* Monthly Billing vs Collections Trend
* Payer Performance
* Claims Denied by Reason
* Outstanding A/R by Aging Bucket

### Interactive Filters

* Payer Group
* Department
* Service Month

I also configured interactive filtering so users can click payer information and explore related dashboard results.

---

## Why Did You Use PostgreSQL and Tableau?

I used PostgreSQL because it allowed me to practice relational database design, SQL analysis, and healthcare data validation.

I used Tableau because it allowed me to turn the SQL analysis into an interactive dashboard and communicate the revenue cycle results visually.

---

## What Was the Most Important Insight?

One important area was the difference between billed charges and actual collections.

Although the synthetic claims totaled approximately $1.57M in billed charges, collections were approximately $0.94M and about $133.71K remained outstanding.

This showed why it is important to look beyond billed revenue and analyze allowed amounts, collections, denials, and A/R together.

---

## What Would You Improve Next?

If I expanded the project, I would add:

* Claim-level root cause analysis
* Provider-level denial trends
* First-pass acceptance rate
* Days in A/R
* Clean claim rate
* More detailed patient responsibility analysis
* Predictive modeling for denial risk
* Automated refresh workflows

---

## What Did You Learn?

This project helped me understand how healthcare claims move through the revenue cycle and how SQL and visualization tools can be used to identify collection performance, denial patterns, payer differences, and outstanding balances.

It also strengthened my experience with healthcare data modeling, SQL validation, KPI development, and Tableau dashboard creation.

---

## If an Interviewer Asks: “Tell Me About a Project You’re Proud Of”

One project I completed was a healthcare claims and revenue cycle analytics dashboard. I created a PostgreSQL database containing 6,000 synthetic claims and related patient, provider, payer, procedure, and diagnosis tables. I first performed SQL data quality checks and then analyzed billing, collections, denial rates, payer performance, A/R aging, and payment turnaround. I used Tableau to build an interactive dashboard that summarized the results, including approximately $1.57 million billed, $941,000 collected, an 87.57% net collection rate, and an 8.02% denial rate. The project gave me practical experience working through the full healthcare analytics process from raw data through analysis and visualization.
