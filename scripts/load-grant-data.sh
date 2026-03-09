#!/bin/bash
# Load grant management dataset into Salesforce org
# Usage: ./scripts/load-grant-data.sh <org-alias>
# Prerequisites: 1) Deploy metadata first  2) sf CLI authenticated

set -e
ORG_ALIAS="${1:?Usage: $0 <org-alias>}"
DATA_DIR="$(cd "$(dirname "$0")/../data" && pwd)"

echo "=== Loading Grant Management Data to org: $ORG_ALIAS ==="

# 1. Funding Opportunities (must load first - parent for requirements, lookup for applications)
echo "Loading Funding Opportunities..."
sf data import bulk --file "$DATA_DIR/funding_opportunities.csv" --sobject Funding_Opportunity__c --wait 10 --target-org "$ORG_ALIAS"

# 2. Funding Award Requirements (references Funding_Opportunity__c via Funding_Opportunity__r.Opportunity_Id__c)
echo "Loading Funding Award Requirements..."
sf data import bulk --file "$DATA_DIR/funding_award_requirements.csv" --sobject Funding_Award_Requirement__c --wait 10 --target-org "$ORG_ALIAS"

# 3. Individual Applications (references Funding_Opportunity__c via Funding_Opportunity__r.Opportunity_Id__c)
echo "Loading Individual Applications..."
sf data import bulk --file "$DATA_DIR/individual_applications.csv" --sobject Individual_Application__c --wait 10 --target-org "$ORG_ALIAS"

# 4. Funding Awards (references Individual_Application__c via Individual_Application__r.Application_Id__c)
echo "Loading Funding Awards..."
sf data import bulk --file "$DATA_DIR/funding_awards.csv" --sobject Funding_Award__c --wait 10 --target-org "$ORG_ALIAS"

echo "=== Data load complete ==="
