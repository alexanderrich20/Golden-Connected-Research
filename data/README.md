# Grant Management Dataset — CU Anschutz

Dataset for the **Connected Research Administration** solution (AWS + Salesforce). Data follows the [solution architecture data model](../docs/cu-anschutz/data-model.md) and is grounded in **CU Anschutz Medical Campus** public research grant activity.

## Data Sources (Anschutz public)

- [ACCORDS 2024 Grant Awards](https://accords.cuanschutz.edu/research-publications/grant-awards/2024-grant-awards)
- [CU Anschutz Research Development](https://research.cuanschutz.edu/research-development)
- [CCTSI — Colorado Clinical and Translational Sciences Institute](https://news.cuanschutz.edu/cctsi/university-of-colorado-anschutz-medical-campus-receives-54-million-from-nih) ($54M NIH/NCATS UL1, 2024)
- [ARPA-H award](https://news.cuanschutz.edu) (CU Anschutz public award)
- [K to R Transition Program Success Rates](https://cctsi.cuanschutz.edu/docs/librariesprovider28/k-to-r-transition-program/pre-r-success-rates.pdf)
- NIH, AHRQ, CDC, PCORI, and foundation funding mechanisms

## Solution architecture alignment

This dataset implements the **core entities** from [docs/cu-anschutz/data-model.md](../docs/cu-anschutz/data-model.md):

| Entity (data model) | CSV file | Description |
|---------------------|----------|-------------|
| **Researcher** | `researchers.csv` | Unified PI identity; source_system_ids; expertise; department (identity resolution for Data 360) |
| **Funding Opportunity** | `funding_opportunities.csv` | Sponsor, award type, deadlines, terms_ref; includes CCTSI UL1, ARPA-H |
| **Proposal** | `individual_applications.csv` | application_id → id; opportunity_id; pi_researcher_id (FK to researchers); status; submitted_date |
| **Grant** | `funding_awards.csv` | award_id → id; application_id → proposal_id; lifecycle_stage; sponsor; period dates |
| **Award Financial** | `award_financials.csv` | grant_id; budget_total; expended; cost_center (PeopleSoft-style) |
| **Cost Transfer** | `cost_transfers.csv` | grant_id; award_financial_id; status; allowability_result; initiated_at (for cost transfer agent) |
| **Protocol** | `protocols.csv` | researcher_id; type (IRB); status; expiry_date (eProtocol-style) |
| **Compliance Item** | `compliance_items.csv` | grant_id; protocol_id; requirement_type; due_date; status |
| **Document Record** | `document_records.csv` | grant_id; document_type; storage_ref; created_at (OnBase/Cayuse refs) |

Additional file used for requirements per opportunity (pre-award): `funding_award_requirements.csv` (opportunity_id, requirement_type, compliance).

## Files

| File | Records | Description |
|------|---------|-------------|
| `researchers.csv` | 23 | Unified researcher/PI profiles (ACCORDS PIs); source_system_ids for identity resolution |
| `funding_opportunities.csv` | 19 | Grant types/sponsors; CCTSI UL1, ARPA-H, NIH, AHRQ, PCORI, foundations, internal |
| `funding_award_requirements.csv` | 26 | Requirements per opportunity (budget, eligibility, compliance) |
| `individual_applications.csv` | 25 | Proposals with pi_researcher_id → researchers; status; award amounts |
| `funding_awards.csv` | 26 | Awards (incl. CCTSI-UL1-2024, ARPA-H-Eye-2024); lifecycle_stage |
| `award_financials.csv` | 26 | Budget and expended by grant; cost_center; source_system PeopleSoft |
| `cost_transfers.csv` | 5 | Sample cost transfers for Agentforce workflow (allowable/rejected/pending) |
| `protocols.csv` | 17 | IRB protocols linked to researchers; expiry for compliance |
| `compliance_items.csv` | 12 | Sponsor/IRB due dates; status (Not started, Due soon, Submitted) |
| `document_records.csv` | 9 | NoA, contracts, cost transfer approvals; storage_ref (OnBase) |

## CU Anschutz success patterns

| Sponsor type | Success rate | Notes |
|--------------|--------------|--------|
| NIH (new submissions) | 29% | ~2x national average (16%) via KTR program |
| NIH (resubmissions) | 36% | vs 28% national |
| Non-NIH (foundations, etc.) | ~57% | 60 of 106 submissions funded |
| Internal (AAI, Ergen) | 100% | Pilot/seed funding |

## Grant types represented

**Federal (NIH):** R01, R21, R03, R33, R25, K08, K23, U01, UL1, Supplements  
**Federal (other):** AHRQ R01, CDC R21, ARPA-H  
**Foundation:** PCORI, American Cancer Society, AAP, Ergen Family  
**Internal:** Anschutz Acceleration Initiative  
**Institutional (public):** CCTSI UL1 $54M; ARPA-H award  
**Subcontracts:** Johns Hopkins U01, PEDSNet

## Loading into Salesforce

Use the load script (expects Salesforce object names and optional mapping):

```bash
./scripts/load-grant-data.sh <org-alias>
```

For the **conformed** (architecture) CSVs, map fields as follows if your org uses different API names:

- `opportunity_id` → Funding_Opportunity__c (external id or Opportunity_Id__c)
- `application_id` → Individual_Application__c (external id or Application_Id__c)
- `award_id` → Funding_Award__c (external id or Award_Id__c)
- `pi_researcher_id` → lookup to Researcher 360 or Contact

See [docs/cu-anschutz](../docs/cu-anschutz) for the full solution architecture (personas, roadmap, agents, integration map).
