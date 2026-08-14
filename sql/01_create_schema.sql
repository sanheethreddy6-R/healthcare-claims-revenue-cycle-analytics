/* Healthcare Claims & Revenue Cycle Analytics - SQL Server schema
   Portfolio project using synthetic, de-identified data.
*/

CREATE TABLE dbo.Payers (
    payer_id           VARCHAR(10)  NOT NULL PRIMARY KEY,
    payer_name         VARCHAR(100) NOT NULL,
    payer_group        VARCHAR(30)  NOT NULL
);

CREATE TABLE dbo.Providers (
    provider_id        VARCHAR(10)  NOT NULL PRIMARY KEY,
    provider_name      VARCHAR(100) NOT NULL,
    specialty          VARCHAR(80)  NOT NULL,
    department         VARCHAR(80)  NOT NULL
);

CREATE TABLE dbo.Procedures (
    cpt_code              VARCHAR(10)   NOT NULL PRIMARY KEY,
    procedure_description VARCHAR(200)  NOT NULL,
    service_line          VARCHAR(50)   NOT NULL,
    standard_charge       DECIMAL(12,2) NOT NULL
);

CREATE TABLE dbo.Diagnoses (
    icd10_code             VARCHAR(10)  NOT NULL PRIMARY KEY,
    diagnosis_description  VARCHAR(200) NOT NULL
);

CREATE TABLE dbo.Patients (
    patient_id         VARCHAR(12) NOT NULL PRIMARY KEY,
    date_of_birth      DATE        NOT NULL,
    gender             VARCHAR(20) NOT NULL,
    state              CHAR(2)     NOT NULL,
    primary_payer_id   VARCHAR(10) NOT NULL
);

CREATE TABLE dbo.Claims (
    claim_id                 VARCHAR(15)   NOT NULL PRIMARY KEY,
    encounter_id             VARCHAR(15)   NOT NULL,
    patient_id               VARCHAR(12)   NOT NULL,
    provider_id              VARCHAR(10)   NOT NULL,
    payer_id                 VARCHAR(10)   NOT NULL,
    service_date             DATE          NOT NULL,
    submission_date          DATE          NOT NULL,
    payment_date             DATE          NULL,
    cpt_code                 VARCHAR(10)   NOT NULL,
    icd10_primary            VARCHAR(10)   NOT NULL,
    claim_status             VARCHAR(30)   NOT NULL,
    denial_reason_code       VARCHAR(15)   NULL,
    denial_reason            VARCHAR(150)  NULL,
    appeal_status            VARCHAR(30)   NULL,
    billed_amount            DECIMAL(12,2) NOT NULL,
    allowed_amount           DECIMAL(12,2) NOT NULL,
    contractual_adjustment   DECIMAL(12,2) NOT NULL,
    payer_paid_amount        DECIMAL(12,2) NOT NULL,
    patient_responsibility   DECIMAL(12,2) NOT NULL,
    recovery_amount          DECIMAL(12,2) NOT NULL,
    total_collected          DECIMAL(12,2) NOT NULL,
    outstanding_amount       DECIMAL(12,2) NOT NULL,
    days_to_submit           INT           NOT NULL,
    days_to_payment          INT           NULL,
    ar_bucket                VARCHAR(15)   NOT NULL,
    CONSTRAINT FK_Claims_Patients   FOREIGN KEY (patient_id)    REFERENCES dbo.Patients(patient_id),
    CONSTRAINT FK_Claims_Providers  FOREIGN KEY (provider_id)   REFERENCES dbo.Providers(provider_id),
    CONSTRAINT FK_Claims_Payers     FOREIGN KEY (payer_id)      REFERENCES dbo.Payers(payer_id),
    CONSTRAINT FK_Claims_Procedures FOREIGN KEY (cpt_code)      REFERENCES dbo.Procedures(cpt_code),
    CONSTRAINT FK_Claims_Diagnoses  FOREIGN KEY (icd10_primary) REFERENCES dbo.Diagnoses(icd10_code)
);

CREATE INDEX IX_Claims_ServiceDate ON dbo.Claims(service_date);
CREATE INDEX IX_Claims_Payer ON dbo.Claims(payer_id);
CREATE INDEX IX_Claims_Status ON dbo.Claims(claim_status);
CREATE INDEX IX_Claims_Provider ON dbo.Claims(provider_id);
