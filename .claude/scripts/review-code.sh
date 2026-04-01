#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${BASE_REF:-origin/main}"
HEAD_REF="${HEAD_REF:-HEAD}"

DIFF_FILE="$(mktemp)"
CHANGED_FILE="$(mktemp)"

git diff --unified=3 "${BASE_REF}...${HEAD_REF}" > "$DIFF_FILE"
git diff --name-only "${BASE_REF}...${HEAD_REF}" > "$CHANGED_FILE"

PROMPT_FILE="$(mktemp)"

cat > "$PROMPT_FILE" <<EOF
Review the current pull request changes using the repository's AGENTS.md and the review-pr skill.

Comparison range: ${BASE_REF}...${HEAD_REF}

Changed files:
$(cat "$CHANGED_FILE")

Instructions:
- Review in repository context, not by diff alone.
- Focus on FSD boundary safety, clean architecture fit, correctness, React/Next risks, query invalidation, Zustand usage, converter usage, accessibility, performance, and missing tests.
- Use the repository's required severity levels.
- Return only the structured markdown report.

Diff:
$(cat "$DIFF_FILE")
EOF

# Example: replace this command with your actual codex CLI invocation
# codex run --profile deep-review --skill review-pr < "$PROMPT_FILE"

echo "## Summary"
echo "- overall risk: medium"
echo "- compared range: ${BASE_REF}...${HEAD_REF}"
echo "- changed areas: placeholder"
echo "- architecture fit: placeholder"
echo "- must-fix count: 0"
echo "- should-fix count: 0"
echo "- checked dimensions: correctness, architecture, performance, accessibility, testing"
echo
echo "## Findings"
echo "- No automated findings generated because codex CLI invocation is not wired yet."
echo
echo "## Missing tests"
echo "- Add codex invocation to scripts/review-pr.sh"
echo
echo "## Assumptions / Questions"
echo "- Replace placeholder section with your actual model output"
echo
echo "## Final verdict"
echo "- approve with follow-ups"