#!/usr/bin/env bash
# scripts/show_file.sh 파일경로
# 인자로 받은 파일 내용을 표준 출력으로 그대로 보여준다.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "사용법: bash scripts/show_file.sh 경로/파일명.md" >&2
  exit 1
fi

FILE_PATH="$1"

if [ ! -f "$FILE_PATH" ]; then
  echo "파일을 찾을 수 없습니다: $FILE_PATH" >&2
  exit 1
fi

cat "$FILE_PATH"
