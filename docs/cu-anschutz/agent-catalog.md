# Agent catalog — CU Anschutz Research Administration

Short specifications per agent: trigger, inputs, knowledge/allowability source, actions, and outputs. Phase 4 agents first; Phase 5 agents summarized.

---

## 1. Cost transfer agent (Phase 4)

| Attribute | Specification |
|-----------|----------------|
| **Name** | Cost Transfer Allowability and Approval Agent |
| **Phase** | 4 |
| **Persona** | Post-award / financial staff, PI, approvers |

**Trigger**

- Event from ERP (PeopleSoft): cost transfer initiated or submitted.
- Event captured in AWS data lake and delivered to Salesforce platform in real time.

**Inputs**

- Cost transfer payload: amount, from/to account/cost center, grant/project reference, justification, date.
- Grant and award context from Data 360 / lake: budget, sponsor, terms, existing cost transfers.
- Researcher (PI) and org context for routing.

**Allowability / knowledge source**

- Federal regulations (e.g. Uniform Guidance 2 CFR 200).
- State regulations (Colorado, as applicable).
- Institution policies (CU Anschutz).
- Grant-specific terms and conditions (from proposal/award data).
- Gen AI (e.g. Amazon Bedrock) or equivalent to compare transfer details against rules and return allowability result and rationale.

**Actions**

1. Receive cost transfer event from platform (subscribed to lake/event bus).
2. Invoke allowability check (Gen AI + rules) with transfer details and grant/terms context.
3. If allowable: trigger Agentforce workflow; route approval tasks to configured stakeholders (e.g. PI, department, post-award).
4. If not allowable: return result to platform; optionally notify submitter with reason; no approval route.
5. On approval completion: update status in platform; optionally sync status back to lake/ERP for audit.
6. Update unified dashboards (real-time financial view).

**Outputs**

- Allowability result (allowable / not allowable) and rationale.
- Approval workflow tasks and outcomes (approved / rejected / returned).
- Updated cost transfer status in platform and dashboard.
- Audit trail of agent decision and approvals.

---

## 2. Compliance notification agent (Phase 4)

| Attribute | Specification |
|-----------|----------------|
| **Name** | Proactive Compliance Notification Agent |
| **Phase** | 4 |
| **Persona** | Compliance / regulatory, RA staff |

**Trigger**

- Time-based: scheduled checks (e.g. daily or weekly) for upcoming deadlines and requirement states.
- Rule-based: change in protocol status, grant lifecycle, or new requirement (e.g. sponsor amendment).

**Inputs**

- Compliance items and protocols from Data 360 / lake: due dates, requirement type (sponsor, state, federal, institutional), status, linked grant and PI.
- Grant and protocol metadata: lifecycle stage, end date, sponsor.

**Knowledge source**

- Institutional and sponsor compliance rules (configurable rules engine or policy store).
- Due-date and frequency rules (e.g. annual reports, IRB renewals, financial reports).

**Actions**

1. Evaluate compliance items and protocols against due dates and thresholds (e.g. 30/60/90 days before due).
2. Generate notifications (email, in-app, or both) to responsible parties (compliance staff, RA, PI as configured).
3. Optionally create tasks in Salesforce or assign to queues.
4. Support escalation or reminder follow-ups (configurable).

**Outputs**

- Notifications to stakeholders with clear due date, requirement type, and grant/protocol link.
- Task or queue assignments (optional).
- Reduced manual tracking and last-minute compliance sprints.

---

## 3. Q&A assistant (Phase 4)

| Attribute | Specification |
|-----------|----------------|
| **Name** | Research Administration Q&A Assistant |
| **Phase** | 4 |
| **Persona** | Faculty / Researcher, RA staff, Compliance |

**Trigger**

- User asks a question in natural language (e.g. chat or search) in the unified platform or portal.

**Inputs**

- User question (free text).
- Optional context: user identity (researcher vs staff), role, current grant or proposal (if in context).

**Knowledge source**

- Institution-defined, factually accurate sources only: policy docs, procedure guides, export control guidance, sponsor guidelines, FAQs.
- Curated and approved content (no open web); RAG or structured retrieval over approved corpus.
- Source citations returned with every answer.

**Actions**

1. Parse intent and entities from the question.
2. Retrieve relevant passages or FAQs from approved knowledge base (RAG or semantic search).
3. Generate concise answer grounded in retrieved content (Einstein or Bedrock); include citations.
4. Present answer and sources to user; optionally suggest related links or next steps.

**Outputs**

- Answer text with source citations (e.g. “Export control procedures …” with link to policy).
- Optional: suggested follow-up questions or links to Cayuse, eProtocol, etc.

---

## 4. Conversational analytics agent (Phase 4)

| Attribute | Specification |
|-----------|----------------|
| **Name** | Conversational Analytics Agent (Tableau + autonomous agent) |
| **Phase** | 4 |
| **Persona** | All (role-based); especially Leadership, RA |

**Trigger**

- User asks an ad hoc question about grant activity, spending, trends, or portfolio in natural language (e.g. in Tableau or embedded experience).

**Inputs**

- Natural language question (e.g. “What is total spending by department this quarter?”).
- User identity and role for row-level security and data access.
- Unified data (Data 360 / Tableau) as queryable dataset.

**Knowledge source**

- Schema and semantics of unified model (Researcher, Grant, Award Financial, etc.); Tableau data source definitions and metrics.
- No external policy content; analytics only over platform data.

**Actions**

1. Interpret question and map to dimensions, metrics, filters (NL to query or viz intent).
2. Execute query or trigger Tableau viz/API with appropriate filters and scope.
3. Return result (table, chart, or summary) and optional natural language summary.
4. Support follow-up questions in session (proactive insights optional).

**Outputs**

- Visualization or table plus short narrative summary.
- Enables “ask in plain language” over grant portfolios, spending patterns, and research trends without building every report upfront.

---

## 5. Phase 5 agents (summary specs)

| Agent | Trigger | Inputs | Knowledge / source | Actions | Outputs |
|-------|---------|--------|--------------------|--------|---------|
| **Collaborator identification / proposal evaluation** | Researcher or RA initiates “find collaborators” or “evaluate proposal” | Researcher profile, proposal draft or topic, criteria | CU Experts/VIVO, publication/collaboration data, internal expertise | Search and rank potential collaborators; score or suggest proposal improvements | Ranked list of collaborators; evaluation summary or checklist |
| **Contract / agreement review and remediation** | Staff uploads or links contract/agreement; or new agreement event | Document or link; grant/party context | Institution contract playbooks, clause library, compliance rules | Extract terms; compare to playbook; flag gaps; suggest remediation | Review report; redlines or suggested clauses; task list |
| **Research impact visualization** | Leadership or RA requests impact view | Grant and output data (publications, patents, etc.) from Data 360 / lake | Unified grant and impact data; definitions of impact metrics | Aggregate and visualize impact by unit, sponsor, theme; trend over time | Dashboards and visualizations; optional narrative |
| **Intelligent prospecting** | RA or researcher searches for funding opportunities | Researcher profile, keywords, discipline, past awards | Pivot-RP, SPIN, internal success patterns | Match opportunities to researcher/unit; rank and filter; surface best fits | Ranked opportunity list with fit rationale |

---

## 6. Agent–phase and dependency summary

| Agent | Phase | Depends on |
|-------|-------|------------|
| Cost transfer agent | 4 | Data lake events (Phase 2); Data 360 / platform (Phase 3); Agentforce |
| Compliance notification agent | 4 | Data 360 / lake compliance and protocol data (Phase 3) |
| Q&A assistant | 4 | Curated knowledge base; Data 360 identity for personalization (optional) |
| Conversational analytics | 4 | Data 360 + Tableau (Phase 3) |
| Collaborator ID / proposal eval | 5 | Researcher 360 and expertise data; optional external DBs |
| Contract/agreement review | 5 | Document linkage; contract playbooks and clause library |
| Research impact visualization | 5 | Grant and impact data in lake / Data 360 |
| Intelligent prospecting | 5 | Pivot-RP/SPIN integration; Researcher 360 |
