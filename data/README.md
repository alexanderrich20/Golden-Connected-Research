# Grant Management Dataset

Dataset for populating the grant management data model, based on **CU Anschutz Medical Campus** research administration patterns. Data reflects grant types and success rates from ACCORDS (Adult & Child Center for Outcomes Research & Delivery Science), CCTSI, and institutional sources.

## Data Sources

- [ACCORDS 2024 Grant Awards](https://accords.cuanschutz.edu/research-publications/grant-awards/2024-grant-awards)
- [CU Anschutz Research Development](https://research.cuanschutz.edu/research-development)
- [K to R Transition Program Success Rates](https://cctsi.cuanschutz.edu/docs/librariesprovider28/k-to-r-transition-program/pre-r-success-rates.pdf)
- NIH, AHRQ, CDC, PCORI, and foundation funding mechanisms

## Entity Relationship Overview

```
Funding_Opportunity (1) ──────< (N) Funding_Award_Requirement
       │
       │ (1)
       │
       └────────────< (N) Individual_Application
                            │
                            │ (1)
                            │
                            └────────< (1) Funding_Award
```

## Files

| File | Records | Description |
|------|---------|-------------|
| `funding_opportunities.csv` | 19 | Grant types/sponsors CU Anschutz pursues successfully |
| `funding_award_requirements.csv` | 26 | Requirements per opportunity (budget limits, eligibility, compliance) |
| `individual_applications.csv` | 25 | PI applications with status and award amounts |
| `funding_awards.csv` | 26 | Awarded grants with financial details |

## CU Anschutz Success Patterns

| Sponsor Type | Success Rate | Notes |
|--------------|--------------|-------|
| NIH (new submissions) | 29% | ~2x national average (16%) via KTR program |
| NIH (resubmissions) | 36% | vs 28% national |
| Non-NIH (foundations, etc.) | ~57% | 60 of 106 submissions funded |
| Internal (AAI, Ergen) | 100% | Pilot/seed funding |

## Grant Types Represented

**Federal (NIH):** R01, R21, R03, R33, R25, K08, K23, U01, UL1, Supplements  
**Federal (Other):** AHRQ R01, CDC R21, ARPA-H  
**Foundation:** PCORI, American Cancer Society, AAP, Ergen Family  
**Internal:** Anschutz Acceleration Initiative  
**Subcontracts:** Johns Hopkins U01, PEDSNet, Immunize.org  

## Field Reference

### funding_opportunities
- `opportunity_id` – PK
- `sponsor`, `sponsor_type` – Federal/Foundation/Internal
- `award_type` – R01, K08, etc.
- `success_rate_cu_anschutz` – CU Anschutz historical rate

### funding_award_requirements
- `requirement_id` – PK
- `opportunity_id` – FK to funding_opportunities
- `requirement_type` – budget, narrative, eligibility, compliance

### individual_applications
- `application_id` – PK
- `opportunity_id` – FK to funding_opportunities
- `pi_name`, `pi_department` – Principal investigator
- `status` – Awarded, Pending, etc.

### funding_awards
- `award_id` – PK
- `application_id` – FK to individual_applications (nullable for institutional awards)
- `cfda_number` – Federal Catalog of Domestic Assistance
- `prime_recipient`, `subrecipient` – For subcontract flow

## Loading into Salesforce

Use Data Loader or similar ETL:

1. **Funding_Opportunity__c** – Load `funding_opportunities.csv`  
2. **Funding_Award_Requirement__c** – Load `funding_award_requirements.csv` (map `opportunity_id` to Funding_Opportunity__c)  
3. **Individual_Application__c** – Load `individual_applications.csv`  
4. **Funding_Award__c** – Load `funding_awards.csv` (map `application_id` to Individual_Application__c)

Ensure custom objects and lookup/master-detail relationships exist before load.
