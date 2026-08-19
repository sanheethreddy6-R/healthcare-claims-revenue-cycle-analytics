/* Healthcare Claims & Revenue Cycle Analytics - PostgreSQL schema
   Portfolio project using synthetic, de-identified data.
*/

-- Run this while connected to the healthcare_rcm database.

CREATE TABLE payers (
    payer_id           VARCHAR(10)  PRIMARY KEY,
    payer_name         VARCHAR(100) NOT NULL,
    payer_group        VARCHAR(30)  NOT NULL
);

CREATE TABLE providers (
    provider_id        VARCHAR(10)  PRIMARY KEY,
    provider_name      VARCHAR(100) NOT NULL,
    specialty          VARCHAR(80)  NOT NULL,
    department         VARCHAR(80)  NOT NULL
);

CREATE TABLE procedures (
    cpt_code              VARCHAR(10)   PRIMARY KEY,
    procedure_description VARCHAR(200)  NOT NULL,
    service_line          VARCHAR(50)   NOT NULL,
    standard_charge       NUMERIC(12,2) NOT NULL CHECK (standard_charge >= 0)
);

CREATE TABLE diagnoses (
    icd10_code            VARCHAR(10)  PRIMARY KEY,
    diagnosis_description VARCHAR(200) NOT NULL
);

CREATE TABLE patients (
    patient_id        VARCHAR(12) PRIMARY KEY,
    date_of_birth     DATE        NOT NULL,
    gender            VARCHAR(20) NOT NULL,
    state             CHAR(2)     NOT NULL,
    primary_payer_id  VARCHAR(10) NOT NULL,
    CONSTRAINT fk_patients_primary_payer
        FOREIGN KEY (primary_payer_id) REFERENCES payers(payer_id)
);

CREATE TABLE claims (
    claim_id                 VARCHAR(15)   PRIMARY KEY,
    encounter_id             VARCHAR(15)   NOT NULL,
    patient_id               VARCHAR(12)   NOT NULL,
    provider_id              VARCHAR(10)   NOT NULL,
    payer_id                 VARCHAR(10)   NOT NULL,
    service_date             DATE          NOT NULL,
    submission_date          DATE          NOT NULL,
    payment_date             DATE,
    cpt_code                 VARCHAR(10)   NOT NULL,
    icd10_primary            VARCHAR(10)   NOT NULL,
    claim_status             VARCHAR(30)   NOT NULL,
    denial_reason_code       VARCHAR(15),
    denial_reason            VARCHAR(150),
    appeal_status            VARCHAR(30),
    billed_amount            NUMERIC(12,2) NOT NULL CHECK (billed_amount >= 0),
    allowed_amount           NUMERIC(12,2) NOT NULL CHECK (allowed_amount >= 0),
    contractual_adjustment   NUMERIC(12,2) NOT NULL CHECK (contractual_adjustment >= 0),
    payer_paid_amount        NUMERIC(12,2) NOT NULL CHECK (payer_paid_amount >= 0),
    patient_responsibility   NUMERIC(12,2) NOT NULL CHECK (patient_responsibility >= 0),
    recovery_amount          NUMERIC(12,2) NOT NULL CHECK (recovery_amount >= 0),
    total_collected          NUMERIC(12,2) NOT NULL CHECK (total_collected >= 0),
    outstanding_amount       NUMERIC(12,2) NOT NULL CHECK (outstanding_amount >= 0),
    days_to_submit           INTEGER       NOT NULL CHECK (days_to_submit >= 0),
    days_to_payment          INTEGER,
    ar_bucket                VARCHAR(15)   NOT NULL,

    CONSTRAINT fk_claims_patients
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_claims_providers
        FOREIGN KEY (provider_id) REFERENCES providers(provider_id),
    CONSTRAINT fk_claims_payers
        FOREIGN KEY (payer_id) REFERENCES payers(payer_id),
    CONSTRAINT fk_claims_procedures
        FOREIGN KEY (cpt_code) REFERENCES procedures(cpt_code),
    CONSTRAINT fk_claims_diagnoses
        FOREIGN KEY (icd10_primary) REFERENCES diagnoses(icd10_code),

    CONSTRAINT chk_allowed_not_over_billed CHECK (allowed_amount <= billed_amount),
    CONSTRAINT chk_submission_after_service CHECK (submission_date >= service_date),
    CONSTRAINT chk_payment_after_submission CHECK (payment_date IS NULL OR payment_date >= submission_date)
);

CREATE INDEX ix_claims_service_date ON claims(service_date);
CREATE INDEX ix_claims_payer ON claims(payer_id);
CREATE INDEX ix_claims_status ON claims(claim_status);
CREATE INDEX ix_claims_provider ON claims(provider_id);

-- Quick verification: should return 6 rows.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('payers','providers','procedures','diagnoses','patients','claims')
ORDER BY table_name;
