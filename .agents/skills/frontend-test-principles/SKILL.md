---
name: frontend-test-principles
description: 해당 코드에 대한 테스트코드를 작성해줘, 이 컴포넌트에 대한 단위 테스트코드를 작성해줘, 해당 코드에 대해 테스트 진행 설계를 해주고, 실제 테스트 코드를 작성해줘, 이 컴포넌트에 대해 테스트 진행 설계를 해주고, 실제 테스트 코드를 작성해줘, mocking 을 최소화 하면서 테스트 코드를 작성해줘 등등, 프론트엔드 테스트를 작성할 때 가장 먼저 적용해야 하는 공통 원칙 문서입니다. 모든 테스트 관련 스킬보다 선행하며, 테스트 이름, 독립성, Given-When-Then, 경계값, 비동기 테스트, 테스트 데이터 관리 등 기본 규준을 정의합니다.
model: sonnet
color: yellow
---

# 프론트엔드 테스트 기본 원칙

이 문서는 프론트엔드 테스트를 작성할 때 **가장 먼저 적용해야 하는 공통 기준 문서**입니다.  
테스트 파일 구조, 테스트 코드 작성, 테스트 설정 검증, 테스트 가능한 코드 설계보다 **먼저** 이 문서의 원칙을 따릅니다.

## 이 문서의 위치

이 문서는 **라우터 문서가 아닙니다.**
이 문서는 **최상위 선행 규범**입니다.

즉, 테스트 관련 요청을 처리할 때는 아래 순서를 전제로 합니다.

1. 먼저 `frontend-test-principles`를 따른다
2. 그 다음 `frontend-test-suite`가 요청을 분기한다
3. 이후 필요한 참조 스킬을 적용한다

---

## 핵심 원칙

### 1. 테스트 이름 규칙

- 테스트 이름은 **의도를 명확히 드러내야 합니다**
- 가능하면 **situation_action_result** 형태로 작성합니다
- 비즈니스 요구사항이 드러나는 표현을 사용합니다

```typescript
// Good
it("should calculate answer ratio when completed test chapter exists", () => {})
it("should display results after selecting semester and searching", () => {})
it("should not allow empty string or null values", () => {})

// Bad
it("test one number", () => {})
it("should work", () => {})
it("test calculation", () => {})
```

### 2. 테스트 독립성

- 테스트는 **서로 독립적**이어야 합니다
- 각 테스트는 **자기 자신이 필요한 데이터와 상태를 직접 준비**해야 합니다
- 전역 상태나 공유 변수에 의존하지 않습니다

```typescript
// Bad
describe("WalletService", () => {
    static wallet = new Wallet()

    it("should save amount", () => {
        wallet.save(1000)
        expect(wallet.get()).toBe(1000)
    })

    it("should pay amount", () => {
        wallet.pay(500)
        expect(wallet.get()).toBe(500)
    })
})

// Good
describe("WalletService", () => {
    it("should save amount", () => {
        const wallet = new Wallet(0)
        wallet.save(1000)
        expect(wallet.get()).toBe(1000)
    })

    it("should pay amount", () => {
        const wallet = new Wallet(1000)
        wallet.pay(500)
        expect(wallet.get()).toBe(500)
    })
})
```

### 3. Given-When-Then 패턴

- 조건(Given), 행동(When), 검증(Then)을 명확히 분리합니다
- 가독성을 위해 주석으로 섹션을 나눕니다

```typescript
it("should display success message when user enters valid data", () => {
    // Given
    const validUserData = {
        name: "John Doe",
        email: "john@example.com"
    }
    const userService = new UserService()

    // When
    const result = userService.createUser(validUserData)

    // Then
    expect(result.success).toBe(true)
    expect(result.message).toBe("User has been created")
})
```

### 4. 순수 함수 우선 테스트

- 순수 함수는 가장 먼저 테스트합니다
- 빠르고 안정적이며 유지보수성이 높습니다
- 0, null-like, boundary, rounding 같은 조건을 빠뜨리지 않습니다

```typescript
describe("calculateAnswerRatio", () => {
    it("should return 0 when total count is 0", () => {
        expect(calculateAnswerRatio(5, 0)).toBe(0)
    })

    it("should return rounded percentage", () => {
        expect(calculateAnswerRatio(7, 10)).toBe(70)
    })
})
```

### 5. mocking은 경계에서만

mock은 아래 같은 경계에서 우선 사용합니다.

- 네트워크 요청
- 브라우저 전역 API
- 시간/랜덤 값
- 저장소/DB
- 라우팅
- 분석 이벤트 전송

반대로 아래는 가능한 실제 구현을 사용합니다.

- 순수 유틸 함수
- 단순 계산 함수
- 간단한 mapper/converter
- 의존성 없는 validator

### 6. 파라미터화 테스트 우선 고려

```typescript
describe("string validation", () => {
    it.each([
        ["", false],
        ["   ", false],
        [null, false],
        [undefined, false],
        ["valid", true],
    ])("should return %s when input is %s", (input, expected) => {
        expect(isValidString(input)).toBe(expected)
    })
})
```

### 7. 비동기 테스트는 성공/실패 모두 검증

```typescript
it("should fetch data successfully", async () => {
    mockApiClient.get.mockResolvedValue({ id: 1, name: "test" })
    const result = await service.fetchData()
    expect(result).toEqual({ id: 1, name: "test" })
})

it("should handle errors appropriately", async () => {
    mockApiClient.get.mockRejectedValue(new Error("Network Error"))
    await expect(service.fetchData()).rejects.toThrow("Network Error")
})
```

### 8. 테스트 데이터는 factory로 관리하되 의도를 숨기지 않기

```typescript
export const createTestChapter = (overrides?: Partial<ConceptEnhancementChapterDto>) => {
    return createMock<ConceptEnhancementChapterDto>({
        type: ConceptEnhancementChapterType.Test,
        completedAt: new Date(),
        conceptEnhancementProblems: [
            {
                submittedAction: { evaluation: Evaluation.Correct },
            },
        ],
        ...overrides,
    })
}
```

### 9. 테스트하지 않을 것 (anti-pattern)

아래는 테스트 작성 대상에서 제외합니다.

- **프레임워크 기본 동작 재검증**: React가 props를 전달하는지, useState가 값을 저장하는지
- **단순 getter/setter**: 값을 저장하고 반환하는 것 외에 로직이 없는 경우
- **단순 위임(pass-through)**: 다른 함수를 그대로 호출만 하는 경우
- **타입 시스템이 보장하는 것**: TypeScript가 컴파일 타임에 보장하는 타입 일치 여부

```typescript
// Bad — 프레임워크 기본 동작을 재검증
it("should pass label prop to child", () => {
    render(<Button label="저장" />)
    expect(screen.getByText("저장")).toBeInTheDocument() // React가 당연히 렌더링함
})

// Good — 컴포넌트의 실제 동작(조건부 비활성화)을 검증
it("should disable button when loading is true", () => {
    render(<Button loading={true}>저장</Button>)
    expect(screen.getByRole("button")).toBeDisabled()
})
```

### 10. 모듈 레벨 mock은 마지막 수단

`jest.mock()` / `vi.mock()` 파일 상단 선언은 모든 테스트에 전역으로 영향을 줍니다.
아래 순서로 먼저 시도하고, 불가능할 때만 모듈 레벨 mock을 사용합니다.

1. **의존성을 파라미터로 주입** — 가장 우선
2. **테스트별 spy** (`vi.spyOn`, `jest.spyOn`)
3. **fake/stub 객체 직접 생성** — interface를 만족하는 단순 객체
4. **모듈 레벨 mock** — 위 방법이 모두 불가능할 때만

```typescript
// Bad — 모듈 전체를 파일 상단에서 mock
vi.mock("../api/userApi")

it("should fetch user", async () => {
    (userApi.getUser as Mock).mockResolvedValue({ id: 1 })
    // ...
})

// Good — 의존성을 주입받아 테스트별로 제어
it("should fetch user", async () => {
    // Given
    const fakeApi = { getUser: vi.fn().mockResolvedValue({ id: 1 }) }
    const service = new UserService(fakeApi)

    // When
    const result = await service.fetchUser(1)

    // Then
    expect(result).toEqual({ id: 1 })
})
```

### 11. 테스트 전 코드 계약 분석

테스트를 작성하기 전에, 대상 코드의 공개 계약을 먼저 정리합니다.
이 분석이 테스트 주제 선정의 근거가 됩니다.

- **입력은 무엇인가?** — 파라미터, props, 상태
- **출력/부작용은 무엇인가?** — 반환값, 렌더링, 상태 변경, 외부 호출
- **어떤 조건에서 다른 결과가 나오는가?** — 분기점

이 3가지 질문에 답할 수 없다면, 테스트보다 **코드 설계를 먼저 명확히** 해야 합니다.

---

## 최종 선언 규칙

테스트 관련 요청을 처리할 때는 반드시 아래를 전제로 합니다.

1. 테스트 이름은 요구사항을 드러내야 한다
2. 테스트는 독립적으로 실행 가능해야 한다
3. Given-When-Then 구조를 지켜야 한다
4. 순수 함수는 직접 테스트하고 경계값을 빠뜨리지 않는다
5. mocking은 경계에서만 한다
6. 반복 데이터는 factory로 관리하되 의도를 숨기지 않는다
7. 비동기 테스트는 성공과 실패를 모두 검증한다
8. 테스트하지 않아야 할 것을 구분한다
9. 모듈 레벨 mock은 마지막 수단이다
10. 테스트 전에 대상 코드의 공개 계약을 먼저 분석한다
11. 이후의 구조/내용/설정/설계 분기는 `frontend-test-suite`가 담당한다
