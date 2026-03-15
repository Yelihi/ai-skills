#!/usr/bin/env bash
# scripts/list_changed_md.sh
# 현재 git 저장소에서 변경된 .md 파일 목록을 한 줄에 하나씩 출력한다.
# - staged + unstaged 둘 다 보고 싶으면 --cached 부분을 조정하면 된다.

set -euo pipefail

# git이 아니면 종료
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "이 디렉터리는 git 저장소가 아닙니다." >&2
  exit 1
fi

# 기준:
# 1) git status --porcelain으로 변경된 파일 목록을 가져온다.
# 2) 마크다운(.md) 파일만 필터링한다.
git status --porcelain | awk '{print $2}' | grep '\.md$' || true
