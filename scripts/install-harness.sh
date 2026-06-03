#!/usr/bin/env bash
#
# install-harness.sh — 프론트엔드 하네스 엔지니어링에 필요한 skill 세트만 한 번에 설치한다.
#
# 사용법 (적용할 프로젝트 루트에서 실행):
#   curl -fsSL https://raw.githubusercontent.com/Yelihi/ai-skills/main/scripts/install-harness.sh | bash
#   # 또는 이 repo를 클론한 뒤:
#   bash scripts/install-harness.sh
#
# 추가 인자는 그대로 `npx skills add`로 전달된다. 예) 전역 설치:
#   bash scripts/install-harness.sh -g
#   특정 에이전트만:        bash scripts/install-harness.sh -a claude-code
#
# 식별자는 각 skill의 frontmatter `name` 값이다(디렉터리명이 아님).
# 예: domain-driven-architecture-agent → ddd-architecture, fsd-clean-architecture → clean-architecture
set -euo pipefail

REPO="Yelihi/ai-skills"

# 하네스 파이프라인 = 단계 skill 14개 + 위임 대상 의존성 5개 = 19개
SKILLS=(
  # ── 설계 (Design) ──
  ddd-architecture
  spec-advisor
  architecture-design
  design-system-spec
  feature-checklist
  # ── 구현 (Implementation) ──
  figma-to-tsx
  component-builder
  # ── 테스트 (Test) ──
  frontend-test-principles
  frontend-test-suite
  # ── 검증 (Verification) ──
  type-checker
  code-cleaner
  code-quality
  a11y-checker
  performance-checker
  # ── 위임 대상 의존성 (없으면 위 skill들의 위임이 깨짐) ──
  clean-architecture           # 폴더구조 (architecture-design, component-builder)
  vercel-composition-patterns  # props/variant 컴포지션
  vercel-react-best-practices  # 성능 58규칙 (performance-checker)
  web-design-guidelines        # 접근성·UI 가이드라인 (a11y-checker)
  karpathy-guidelines          # clean-code 행동지침 (code-cleaner, code-quality)
)

args=()
for s in "${SKILLS[@]}"; do
  args+=(--skill "$s")
done

echo "Installing ${#SKILLS[@]} harness skills from ${REPO} ..."
npx -y skills add "${REPO}" -y "${args[@]}" "$@"
