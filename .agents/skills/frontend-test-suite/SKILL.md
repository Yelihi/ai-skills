---
name: frontend-test-suite
description: 프론트엔드 테스트 관련 작업을 위한 상위 분기 스킬입니다. 이 스킬은 frontend-test-principles를 선행 규범으로 전제하고, 요청을 구조 / 내용 / 설정 / tsyringe 기반 설계 / 일반 설계 중 어디에 해당하는지 판단한 뒤 적절한 참조 스킬로 연결합니다.
model: sonnet
color: purple
---

# 프론트엔드 테스트 종합 스킬

> **환경 전제:** 이 스킬 체계는 **Jest/Vitest + Testing Library** 환경을 기본으로 가정합니다.
> E2E 테스트(Playwright, Cypress 등)는 이 스킬의 범위 밖입니다.

이 문서는 Claude의 특별한 내장 기능인 "router skill"을 사용하는 문서가 아닙니다.  
Claude에는 공식 제품 개념으로 **별도의 router skill 타입이 있는 것은 아닙니다.**

대신 이 문서는 **분기 역할을 하는 상위 참조 스킬**로 설계되었습니다.

즉, 이 문서의 역할은:

- 직접 모든 세부 작업을 다 수행하는 것보다
- 현재 요청이 어떤 종류인지 먼저 분류하고
- 가장 적절한 참조 스킬 문서로 연결하는 것

입니다.

---

## 선행 규칙

이 스킬은 항상 **`frontend-test-principles`를 먼저 전제**합니다.

테스트 관련 요청을 처리할 때 Claude가 따라야 할 권장 흐름은 아래와 같습니다.

1. 먼저 `frontend-test-principles`의 규범을 따른다
2. 그 다음 `frontend-test-suite`가 요청 종류를 분기한다
3. 이후 필요한 참조 스킬을 하나 이상 적용한다

즉, Claude가 이해해야 할 흐름은 아래와 같습니다.

```txt
principles -> suite -> references
```

이 문서에서 `references`는 하위 실행 모듈이라기보다, **상황별로 우선 참고해야 하는 책임별 문서들**입니다.

---

## 참조 스킬 목록

### 1. `frontend-test-organizer`
구조와 위치를 담당합니다.

- 테스트 파일 위치 강제
- `src/_tests/` 중앙 집중 구조 유지
- 원본 소스 구조 미러링
- 잘못된 위치의 테스트 파일 이동/정리

### 2. `frontend-test-writer`
테스트 본문과 시나리오를 담당합니다.

- 테스트 시나리오 설계
- 컴포넌트 / 서비스 / 유틸 테스트 본문 작성
- 공개 계약 중심 테스트 작성
- 회귀 위험 시나리오 보강

### 3. `frontend-test-config-checker`
탐지/설정/실행을 담당합니다.

- 테스트 러너 탐지 규칙 점검
- 테스트 설정 충돌 확인
- 실행 가능성 검증
- 로컬/CI 환경 차이 조사

### 4. `frontend-tsyringe-testable-code-guide`
tsyringe 기반 구조 설계를 담당합니다.

- tsyringe 기반 DI 구조에서 테스트 가능한 코드 설계 가이드 제공
- interface 중심 계약 설계 원칙 정리
- service / converter / util / UI 조율 레이어 분리 기준 제시

### 5. `frontend-generic-testable-code-guide`
일반적인 테스트 가능 코드 설계를 담당합니다.

- 특정 DI 컨테이너 없이도 적용 가능한 테스트 가능한 코드 작성 원칙 제공
- SOLID, 의존성 주입, 관심사 분리, clean code 기반 구조 안내

---

## 분기 규칙

요청이 들어오면 먼저 아래 5가지 중 어디에 속하는지 판단합니다.

### A. 구조 문제인가?
아래에 해당하면 `frontend-test-organizer`를 우선 참조합니다.

- 테스트 파일을 어디에 둘지 모른다
- 테스트 파일 위치가 프로젝트 규칙과 맞지 않는다
- 테스트 디렉토리 구조를 정리해야 한다

### B. 테스트 내용 문제인가?
아래에 해당하면 `frontend-test-writer`를 우선 참조합니다.

- 테스트 본문을 새로 작성해야 한다
- 어떤 시나리오를 검증할지 정해야 한다
- 테스트 품질을 높이고 싶다

### C. 설정/실행 문제인가?
아래에 해당하면 `frontend-test-config-checker`를 우선 참조합니다.

- 테스트 러너가 파일을 찾지 못한다
- 로컬/CI 환경 차이로 테스트가 실패한다
- 설정 파일이나 setup 문제가 의심된다

### D. tsyringe 기반 설계 문제인가?
아래에 해당하면 `frontend-tsyringe-testable-code-guide`를 우선 참조합니다.

- 프로젝트가 실제로 tsyringe를 사용한다
- interface 기반 구조가 존재한다
- service/converter 분리 구조를 이미 사용한다
- DI 컨테이너 기반으로 더 테스트 가능하게 만들고 싶다

### E. 일반적인 설계 문제인가?
아래에 해당하면 `frontend-generic-testable-code-guide`를 우선 참조합니다.

- 특정 DI 컨테이너가 없다
- 테스트 가능한 코드의 기본 원칙이 필요하다
- SOLID, 의존성 주입, clean code 기준이 필요하다
- 구조 개선이 필요하지만 tsyringe 전용 세팅은 없다

### F. 코드가 테스트하기 어려운 구조인가?
아래에 해당하면 **테스트를 바로 작성하지 않고** 먼저 설계 가이드를 참조해 구조 개선을 제안합니다.
개선 후 다시 B(테스트 내용 문제)로 돌아와 테스트를 작성합니다.

- 테스트를 위해 4개 이상의 mock이 필요한 경우
- 하나의 함수/컴포넌트가 3개 이상의 외부 의존성을 직접 import & 호출하는 경우
- 함수 내부에서 전역 상태를 직접 변경하는 경우
- 하나의 함수가 2가지 이상 서로 다른 책임을 수행하는 경우

→ tsyringe 구조면 `frontend-tsyringe-testable-code-guide`, 아니면 `frontend-generic-testable-code-guide` 참조

---

## tsyringe 전용 분기 체크리스트

아래 질문에 대부분 예라면 `frontend-tsyringe-testable-code-guide`를 우선 적용합니다.

- `tsyringe` 패키지가 실제로 사용 중인가?
- `container.register*` 또는 `container.resolve` 호출이 존재하는가?
- interface 기반 계약 설계가 이미 존재하는가?
- service / converter / util / UI 조율 레이어가 구분되어 있는가?
- 지금 목표가 그 구조를 유지하면서 테스트 가능성을 높이는 것인가?

이 중 대부분이 아니라면 기본적으로 `frontend-generic-testable-code-guide`를 우선 적용합니다.

---

## 권장 적용 흐름

### 새 테스트를 만들 때
1. `frontend-test-principles`
2. `frontend-test-suite`
3. `frontend-test-organizer`
4. `frontend-test-writer`
5. 필요 시 `frontend-test-config-checker`

### 테스트가 탐지되지 않을 때
1. `frontend-test-principles`
2. `frontend-test-suite`
3. `frontend-test-organizer`
4. `frontend-test-config-checker`

### 테스트 가능한 코드 구조를 설계할 때
1. `frontend-test-principles`
2. `frontend-test-suite`
3. tsyringe 구조면 `frontend-tsyringe-testable-code-guide`
4. 아니면 `frontend-generic-testable-code-guide`

### 테스트하기 어려운 코드를 만났을 때 (분기 F)
1. `frontend-test-principles`
2. `frontend-test-suite` → 분기 F 진입
3. tsyringe 구조면 `frontend-tsyringe-testable-code-guide`, 아니면 `frontend-generic-testable-code-guide`
4. 구조 개선 제안 후 → `frontend-test-organizer` → `frontend-test-writer`

---

## 실제 판단 예시

### 예시 1
사용자:
"src/components/Button.tsx를 만들었는데 테스트도 필요해"

판단:
- 원칙 확인 → `frontend-test-principles`
- 구조 문제 → `frontend-test-organizer`
- 본문 작성 → `frontend-test-writer`

### 예시 2
사용자:
"테스트 파일은 만들었는데 러너가 못 찾는 것 같아"

판단:
- 원칙 확인 → `frontend-test-principles`
- 구조 점검 → `frontend-test-organizer`
- 설정 점검 → `frontend-test-config-checker`

### 예시 3
사용자:
"우리 프로젝트는 tsyringe 쓰고 있는데, 지금 구조에 맞춰 테스트 가능하게 설계하고 싶어"

판단:
- 원칙 확인 → `frontend-test-principles`
- tsyringe 기반 설계 문제 → `frontend-tsyringe-testable-code-guide`

### 예시 4
사용자:
"이 서비스 코드에 테스트를 작성하려는데 mock이 너무 많이 필요해"

판단:
- 원칙 확인 → `frontend-test-principles`
- 분기 F: 테스트하기 어려운 구조 → 먼저 설계 가이드 참조
- tsyringe 없는 구조면 → `frontend-generic-testable-code-guide`로 구조 개선 제안
- 개선 후 → `frontend-test-organizer` → `frontend-test-writer`

---

## 최종 원칙

이 문서는 Claude의 공식 내장 "router skill"이 아닙니다.  
하지만 **분기 역할을 담당하는 상위 참조 스킬**로서 아래 흐름을 Claude가 이해하도록 돕습니다.

```txt
frontend-test-principles
    -> frontend-test-suite
        -> frontend-test-organizer
        -> frontend-test-writer
        -> frontend-test-config-checker
        -> frontend-tsyringe-testable-code-guide
        -> frontend-generic-testable-code-guide
```

즉:

- `frontend-test-principles` = 최상위 규범
- `frontend-test-suite` = 분기 허브
- 나머지 문서 = 책임별 참조 스킬

이 관계를 항상 유지합니다.
