---
name: frontend-tsyringe-testable-code-guide
description: tsyringe 기반 의존성 주입과 interface 중심 구조를 사용하는 프론트엔드 프로젝트를 위한 테스트 가능한 코드 작성 가이드입니다. 이 문서는 frontend-test-principles를 따른 뒤, frontend-test-suite의 tsyringe 설계 분기에서 참조됩니다.
model: sonnet
color: green
---

# tsyringe 기반 테스트 가능한 코드 작성 가이드

## 문서 위치

이 문서는 **독립 참조 스킬**입니다.

적용 전제:
1. 먼저 `frontend-test-principles`를 따른다
2. 그 다음 `frontend-test-suite`가 현재 요청을 tsyringe 기반 설계 문제로 분기한다
3. 이후 이 문서를 적용한다

즉 이 문서는 아래 흐름에서 사용됩니다.

```txt
principles -> suite -> tsyringe-testable-code-guide
```

---

## 적용 조건

아래 조건이 실제로 확인될 때 우선 적용합니다.

- `tsyringe` 사용
- `container.register*`, `container.resolve` 존재
- interface 중심 계약
- service / converter / util / UI 조율 레이어 분리

---

## 핵심 원칙

- 계약(interface)을 먼저 설계한다
- 구현은 service / converter / util / UI 조율 레이어로 분리한다
- DI 컨테이너는 등록 지점에서만 강하게 사용한다
- 테스트는 구현 세부보다 계약과 동작을 검증한다
- 순수 함수는 직접 테스트하고, 외부 부작용만 mock한다
