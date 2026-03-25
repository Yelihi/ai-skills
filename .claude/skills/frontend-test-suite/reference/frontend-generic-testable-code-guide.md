---
name: frontend-generic-testable-code-guide
description: 특정 DI 컨테이너에 종속되지 않는 일반적인 프론트엔드 테스트 가능한 코드 작성 가이드입니다. 이 문서는 frontend-test-principles를 따른 뒤, frontend-test-suite의 일반 설계 분기에서 참조됩니다.
model: sonnet
color: blue
---

# 일반적인 테스트 가능한 코드 작성 가이드

## 문서 위치

이 문서는 **독립 참조 스킬**입니다.

적용 전제:
1. 먼저 `frontend-test-principles`를 따른다
2. 그 다음 `frontend-test-suite`가 현재 요청을 일반 설계 문제로 분기한다
3. 이후 이 문서를 적용한다

즉 이 문서는 아래 흐름에서 사용됩니다.

```txt
principles -> suite -> generic-testable-code-guide
```

---

## 적용 조건

아래 상황에서 우선 적용합니다.

- 특정 DI 컨테이너가 없다
- tsyringe 기반 구조가 아니다
- 테스트 가능한 코드의 기본 원칙이 필요하다
- 직접 import와 결합도가 높아 구조 개선이 필요하다

---

## 핵심 원칙

- SOLID 기반으로 역할을 나눈다
- 외부 의존성은 주입 가능하게 만든다
- 순수 함수는 직접 테스트한다
- UI는 조율에 집중하고 비즈니스 규칙은 분리한다
- 테스트는 구현이 아니라 동작과 계약을 검증한다
