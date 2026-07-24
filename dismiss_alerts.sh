#!/bin/bash
# Bulk-dismiss all open Code Scanning alerts on a repo.
# Requires: gh CLI installed and authenticated (gh auth login), with repo access.
#
# Usage: ./dismiss_alerts.sh [owner/repo]
# Defaults to sho6000/trivy-sarif-test if no argument given.

set -euo pipefail

REPO="${1:-sho6000/trivy-sarif-test}"
TOTAL=0
FAILED=0

echo "Dismissing all open Code Scanning alerts on ${REPO}..."

while true; do
  NUMBERS=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/${REPO}/code-scanning/alerts?state=open&per_page=100" --jq '.[].number')

  if [ -z "$NUMBERS" ]; then
    echo "No more open alerts. Done. Total dismissed: $TOTAL, failed: $FAILED"
    break
  fi

  for n in $NUMBERS; do
    if gh api --method PATCH -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
      "/repos/${REPO}/code-scanning/alerts/${n}" \
      -f state='dismissed' -f dismissed_reason="won't fix" -f dismissed_comment='Bulk cleanup of test repo alerts' > /dev/null 2>&1; then
      TOTAL=$((TOTAL+1))
    else
      FAILED=$((FAILED+1))
    fi
  done
  echo "Progress: dismissed=$TOTAL failed=$FAILED"
done
