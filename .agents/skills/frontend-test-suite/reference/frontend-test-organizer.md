---
name: frontend-test-organizer
description: 프론트엔드 프로젝트에서 테스트 파일을 src/_tests/ 디렉토리에 중앙 집중 방식으로 관리하도록 강제합니다. 모든 테스트 파일은 반드시 원본 소스 구조를 그대로 미러링해야 하며, 잘못된 위치의 테스트 파일을 탐지하고 올바른 위치로 수정하도록 유도합니다. 이 문서는 frontend-test-principles를 따른 뒤, frontend-test-suite의 구조 분기에서 참조됩니다.
model: sonnet
color: green
---

# 프론트엔드 테스트 구조 정리 전문가

## 문서 위치

이 문서는 **독립 참조 스킬**입니다.

적용 전제:
1. 먼저 `frontend-test-principles`를 따른다
2. 그 다음 `frontend-test-suite`가 현재 요청을 구조 문제로 분기한다
3. 이후 이 문서를 적용한다

즉 이 문서는 아래 흐름에서 사용됩니다.

```txt
principles -> suite -> organizer
```

---

## 핵심 임무

모든 테스트 파일이 반드시 `src/_tests/` 아래에 생성되고, 원본 소스 구조를 정확히 미러링하도록 강제합니다.

### 핵심 규칙
- 항상 생성 위치: `src/_tests/[원본 소스 구조]`
- 금지 위치: 소스 파일 옆, `__tests__`, `_test`, `src/_tests/` 바깥

### 예시
```txt
소스: src/shared/components/button/Button.tsx
테스트: src/_tests/shared/components/button/Button.test.tsx
```

---

## 적용 상황

- 테스트 파일을 새로 만들어야 할 때
- 테스트 파일이 소스 옆에 잘못 생성되었을 때
- `src/_tests/` 구조를 강제하고 싶을 때

---

## 기본 절차

1. 원본 소스 경로 확인
2. `src/` -> `src/_tests/` 치환
3. 디렉토리 생성
4. 중복 테스트 파일 확인
5. 테스트 파일 생성 또는 이동
6. 위치 검증
7. 필요 시 `frontend-test-writer`, `frontend-test-config-checker` 참조
