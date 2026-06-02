# Type Safety Checklist

The audit rubric for `type-checker`. Each item is a checkable assertion against the implemented code. Prefer compiler evidence (`tsc --noEmit`) first; use this list for what the compiler permits but shouldn't.

## 1. Compiler clean

- [ ] `tsc --noEmit` (or the project typecheck script) passes with **zero** errors.
- [ ] No `// @ts-ignore` / `// @ts-expect-error` used to hide a real error (each remaining one is justified in a comment).
- [ ] `tsconfig` has `strict: true` (or the relevant flags: `strictNullChecks`, `noImplicitAny`, `noUncheckedIndexedAccess`). Flag if disabled.

## 2. `any` and `unknown`

- [ ] No explicit `any` in app code. Replace with the real type, a generic, or `unknown` + narrowing.
- [ ] No **implicit** `any` (untyped params, untyped `catch` bindings, untyped array/object literals that widen badly).
- [ ] External/untrusted data (`fetch` JSON, `localStorage`, `params`, env) enters as `unknown` and is validated/narrowed (e.g. zod) before use — not cast straight to a type.

## 3. Type assertions

- [ ] `as` used only where genuinely unavoidable; not to silence an error. Each is justified.
- [ ] No `as unknown as X` double-casts (a hard smell — the types are actually incompatible).
- [ ] No `as` on `null`/`undefined` to dodge null checks.
- [ ] DOM/event casts are the narrowest correct type, not a broad assertion.

## 4. Null / undefined handling

- [ ] Every nullable value (`T | null | undefined`, optional props, `find()`, `Map.get()`, array index under `noUncheckedIndexedAccess`) is guarded before use.
- [ ] Guards use narrowing / optional chaining / nullish coalescing — not non-null `!`.
- [ ] `!` non-null assertions are absent or each individually justified (rare).
- [ ] Optional props have sensible defaults or explicit handling of the absent case.
- [ ] Async results check for the not-yet-loaded (`undefined`) state.

## 5. Modeling

- [ ] Finite states are **union types**, not loose `string`/`boolean` bags (`status: 'idle' | 'loading' | 'error' | 'done'`).
- [ ] Domain types come from `ddd-architecture` and are **reused**, not re-declared locally; DTO ↔ domain mapping is typed at the boundary.
- [ ] Function signatures are explicit at module boundaries (exported functions/components have typed params and return where non-trivial).
- [ ] Generics are constrained (`<T extends …>`) rather than left open and then cast.
- [ ] Discriminated unions used for variant data instead of optional-field grab-bags.

## 6. React-specific

- [ ] Props typed precisely (unions for variants); no `any`/`object` props.
- [ ] Event handlers use correct event types (`React.ChangeEvent<HTMLInputElement>`), not `any`.
- [ ] `ref` typed to the right element; generics on `useState`/`useRef` where inference is insufficient (`useState<User | null>(null)`).

## Output format

Report each violation as `file:line — [category] issue → sound fix`, with severity (error / warning). End with: compiler pass/fail, count by category, and the top fixes to apply before the code is type-safe. Never propose `any`/`!`/`as` as the fix — that's what is being flagged.
