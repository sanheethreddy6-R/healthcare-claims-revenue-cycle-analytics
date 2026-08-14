import csv, random, math
from datetime import date, timedelta
from pathlib import Path

random.seed(20260814)
BASE = Path(__file__).resolve().parent
DATA = BASE / 'data'
DATA.mkdir(exist_ok=True)

first_names = ['Avery','Jordan','Taylor','Morgan','Riley','Casey','Cameron','Drew','Quinn','Reese','Parker','Hayden','Skyler','Alex','Jamie','Robin','Devin','Sam','Logan','Emerson']
last_initials = list('ABCDEFGHIJKLMNOPRSTUVWXYZ')

payers = [
    ('PAY001','Medicare','Government'),('PAY002','Medicaid','Government'),('PAY003','BlueCross PPO','Commercial'),
    ('PAY004','United PPO','Commercial'),('PAY005','Aetna HMO','Commercial'),('PAY006','Cigna PPO','Commercial'),
    ('PAY007','Self Pay','Self-Pay'),('PAY008','Employer Direct','Commercial')
]

providers = []
specialties = [('Internal Medicine','Primary Care'),('Family Medicine','Primary Care'),('Cardiology','Cardiology'),('Orthopedics','Orthopedics'),('Emergency Medicine','Emergency'),('Radiology','Imaging'),('Gastroenterology','GI'),('Endocrinology','Endocrinology')]
for i in range(1,31):
    sp, dept = random.choice(specialties)
    providers.append((f'PRV{i:03d}', f'Provider {i:02d}', sp, dept))

procedures = [
    ('99213','Office/outpatient visit, established patient','E/M',135),
    ('99214','Office/outpatient visit, established patient, higher complexity','E/M',190),
    ('99203','Office/outpatient visit, new patient','E/M',210),
    ('93000','Electrocardiogram with interpretation','Cardiology',95),
    ('71046','Chest X-ray, 2 views','Imaging',165),
    ('73562','Knee X-ray, 3 views','Imaging',180),
    ('80053','Comprehensive metabolic panel','Laboratory',78),
    ('85025','Complete blood count','Laboratory',55),
    ('83036','Hemoglobin A1c','Laboratory',48),
    ('36415','Venipuncture','Laboratory',25),
    ('45378','Diagnostic colonoscopy','GI',1450),
    ('43235','Upper GI endoscopy','GI',1280),
    ('93306','Echocardiography','Cardiology',1200),
    ('97110','Therapeutic exercises','Rehab',120),
    ('99284','Emergency department visit','Emergency',980),
    ('99285','Emergency department visit, high severity','Emergency',1650),
]

diagnoses = [
    ('I10','Essential hypertension'),('E11.9','Type 2 diabetes mellitus without complications'),('E78.5','Hyperlipidemia'),
    ('M25.561','Pain in right knee'),('R07.9','Chest pain, unspecified'),('R10.9','Unspecified abdominal pain'),
    ('J06.9','Acute upper respiratory infection'),('K21.9','Gastro-esophageal reflux disease'),('R53.83','Other fatigue'),
    ('Z00.00','General adult medical examination'),('M54.50','Low back pain'),('R06.02','Shortness of breath')
]

# Patients: only de-identified synthetic identifiers and broad demographics.
patients = []
start_birth = date(1940,1,1)
end_birth = date(2005,12,31)
days_span = (end_birth-start_birth).days
for i in range(1,901):
    dob = start_birth + timedelta(days=random.randint(0,days_span))
    gender = random.choice(['Female','Male','Nonbinary'])
    state = random.choices(['MA','CT','NY','NJ','PA','RI'], weights=[32,12,20,16,14,6])[0]
    primary_payer = random.choices([p[0] for p in payers], weights=[20,14,18,16,12,10,4,6])[0]
    patients.append((f'PAT{i:04d}', dob.isoformat(), gender, state, primary_payer))

payer_map = {x[0]: x for x in payers}
proc_map = {x[0]: x for x in procedures}
prov_map = {x[0]: x for x in providers}

def write_csv(name, header, rows):
    with open(DATA/name,'w',newline='',encoding='utf-8') as f:
        w=csv.writer(f); w.writerow(header); w.writerows(rows)

write_csv('payers.csv',['payer_id','payer_name','payer_group'],payers)
write_csv('providers.csv',['provider_id','provider_name','specialty','department'],providers)
write_csv('procedures.csv',['cpt_code','procedure_description','service_line','standard_charge'],procedures)
write_csv('diagnoses.csv',['icd10_code','diagnosis_description'],diagnoses)
write_csv('patients.csv',['patient_id','date_of_birth','gender','state','primary_payer_id'],patients)

service_start = date(2025,1,1)
service_end = date(2025,12,31)
span=(service_end-service_start).days

denial_reasons = [
    ('AUTH','Authorization missing/invalid'),('CODING','Coding/medical necessity edit'),('ELIG','Eligibility/coverage issue'),
    ('DUP','Duplicate claim'),('INFO','Missing information/documentation'),('TIMELY','Timely filing limit')
]

claims=[]
for i in range(1,6001):
    patient = random.choice(patients)
    patient_id, _, _, _, primary_payer = patient
    payer_id = primary_payer if random.random()<0.87 else random.choice(payers)[0]
    provider_id = random.choice(providers)[0]
    cpt = random.choices([p[0] for p in procedures], weights=[18,16,8,5,6,4,10,8,7,8,2,2,2,4,5,3])[0]
    icd, _ = random.choice(diagnoses)
    service_date = service_start + timedelta(days=random.randint(0,span))

    # Charges vary around the procedure standard charge.
    standard = proc_map[cpt][3]
    billed = round(max(15, random.gauss(standard, standard*0.12)),2)
    payer_group = payer_map[payer_id][2]
    contract_factor = {'Government':0.58,'Commercial':0.72,'Self-Pay':0.82}[payer_group]
    allowed = round(billed * max(0.38,min(0.95,random.gauss(contract_factor,0.06))),2)

    # Denial likelihood varies by payer, procedure complexity and delayed submission.
    submit_days = max(0, int(random.gauss(7,5)))
    if random.random() < 0.025:
        submit_days += random.randint(30,90)
    submission_date = service_date + timedelta(days=submit_days)

    denial_prob = {'PAY001':0.075,'PAY002':0.12,'PAY003':0.065,'PAY004':0.07,'PAY005':0.09,'PAY006':0.08,'PAY007':0.025,'PAY008':0.055}[payer_id]
    if cpt in {'45378','43235','93306'}: denial_prob += 0.035
    if submit_days > 45: denial_prob += 0.12

    r=random.random()
    if r < denial_prob:
        status='Denied'
        reason_code, reason_desc = random.choices(denial_reasons, weights=[24,22,14,10,20,10])[0]
        payer_paid=0.0
        patient_resp=round(allowed*random.uniform(0.0,0.12),2) if payer_group!='Self-Pay' else allowed
        payment_date=''
        days_to_payment=''
        appeal_status=random.choices(['Not Appealed','Appeal Pending','Overturned'],weights=[62,25,13])[0]
        if appeal_status=='Overturned':
            # keep original claim status denied; recovery tracked separately.
            recovery_amount=round(allowed*random.uniform(0.6,0.92),2)
        else:
            recovery_amount=0.0
    elif r < denial_prob + 0.045:
        status='Pending'
        reason_code=''; reason_desc=''
        payer_paid=0.0; patient_resp=0.0; payment_date=''; days_to_payment=''; appeal_status=''; recovery_amount=0.0
    elif r < denial_prob + 0.09:
        status='Partially Paid'
        reason_code=''; reason_desc=''
        patient_resp=round(allowed*random.uniform(0.08,0.24),2)
        payer_paid=round(max(0,allowed-patient_resp)*random.uniform(0.65,0.9),2)
        pay_days=max(5,int(random.gauss(39,14)))
        payment_date=(submission_date+timedelta(days=pay_days)).isoformat(); days_to_payment=pay_days
        appeal_status=''; recovery_amount=0.0
    else:
        status='Paid'
        reason_code=''; reason_desc=''
        if payer_group=='Self-Pay':
            patient_resp=round(allowed,2); payer_paid=0.0
        else:
            patient_resp=round(allowed*random.uniform(0.05,0.22),2)
            payer_paid=round(max(0,allowed-patient_resp),2)
        pay_days=max(3,int(random.gauss(27,11)))
        payment_date=(submission_date+timedelta(days=pay_days)).isoformat(); days_to_payment=pay_days
        appeal_status=''; recovery_amount=0.0

    contractual_adjustment=round(max(0,billed-allowed),2)
    total_collected=round(payer_paid + patient_resp + recovery_amount,2)
    outstanding=round(max(0,allowed-total_collected),2)
    age_as_of_2026_01_31=(date(2026,1,31)-service_date).days
    if outstanding <= 0.01:
        ar_bucket='Closed'
    elif age_as_of_2026_01_31 <= 30: ar_bucket='0-30'
    elif age_as_of_2026_01_31 <= 60: ar_bucket='31-60'
    elif age_as_of_2026_01_31 <= 90: ar_bucket='61-90'
    elif age_as_of_2026_01_31 <= 120: ar_bucket='91-120'
    else: ar_bucket='120+'

    claims.append([
        f'CLM{i:06d}', f'ENC{i:06d}', patient_id, provider_id, payer_id, service_date.isoformat(), submission_date.isoformat(), payment_date,
        cpt, icd, status, reason_code, reason_desc, appeal_status, billed, allowed, contractual_adjustment,
        payer_paid, patient_resp, recovery_amount, total_collected, outstanding, submit_days, days_to_payment, ar_bucket
    ])

headers=['claim_id','encounter_id','patient_id','provider_id','payer_id','service_date','submission_date','payment_date','cpt_code','icd10_primary','claim_status','denial_reason_code','denial_reason','appeal_status','billed_amount','allowed_amount','contractual_adjustment','payer_paid_amount','patient_responsibility','recovery_amount','total_collected','outstanding_amount','days_to_submit','days_to_payment','ar_bucket']
write_csv('claims.csv',headers,claims)

# Simple validation summary
idx={h:i for i,h in enumerate(headers)}
count=len(claims)
denied=sum(1 for r in claims if r[idx['claim_status']]=='Denied')
paid=sum(1 for r in claims if r[idx['claim_status']]=='Paid')
billed=sum(float(r[idx['billed_amount']]) for r in claims)
allowed=sum(float(r[idx['allowed_amount']]) for r in claims)
collected=sum(float(r[idx['total_collected']]) for r in claims)
outstanding=sum(float(r[idx['outstanding_amount']]) for r in claims)
avg_days=sum(int(r[idx['days_to_payment']]) for r in claims if r[idx['days_to_payment']]!='') / sum(1 for r in claims if r[idx['days_to_payment']]!='')
print(f'claims={count}, denied={denied} ({denied/count:.1%}), paid={paid}')
print(f'billed=${billed:,.0f}, allowed=${allowed:,.0f}, collected=${collected:,.0f}, outstanding=${outstanding:,.0f}')
print(f'gross_collection_rate={collected/billed:.1%}, net_collection_rate={collected/allowed:.1%}, avg_days_to_payment={avg_days:.1f}')
