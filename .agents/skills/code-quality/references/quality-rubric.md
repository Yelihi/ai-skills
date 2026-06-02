# Static Quality Rubric

The audit rubric for `code-quality`. Each item is a checkable assertion about the readability and maintainability of the code. Prefer linter evidence (ESLint) first; use this for what lint can't judge. Scope is static quality only — runtime robustness → `code-cleaner`; simplicity philosophy → `karpathy-guidelines`.

## 1. Duplication / DRY

- [ ] No copy-pasted logic blocks that should be one function/hook.
- [ ] No repeated JSX structures that should be one component or a `.map`.
- [ ] Repeated literals/config extracted to a named constant (no magic values scattered).
- [ ] Similar-but-not-identical code: judged — extract only if it's truly the same concept (don't force a wrong abstraction; per `karpathy-guidelines`).
- [ ] Shared logic lives at the right layer (per FSD), not duplicated across slices.

## 2. Naming

- [ ] Names reveal **intent**, not implementation or type (`activeUsers`, not `arr`/`data2`).
- [ ] No misleading names (a `get*` that mutates, a `isX` that isn't boolean).
- [ ] Consistent casing & conventions: `PascalCase` components, `camelCase` vars/functions, `useX` hooks, `handleX`/`onX` handlers, `UPPER_SNAKE` constants.
- [ ] No unexplained abbreviations or single letters (except idiomatic `i`, `e`).
- [ ] Booleans read as predicates (`isLoading`, `hasError`, `canSubmit`).

## 3. Size & complexity

- [ ] Functions/components do one thing; over-long ones are split.
- [ ] Nesting depth is shallow (prefer early return over `if/else` pyramids).
- [ ] Cognitive complexity is reasonable — no sprawling conditionals that need a diagram.
- [ ] Param lists are short; many params → pass an object or compose.
- [ ] A component mixing data-fetching + heavy logic + markup is split by concern.

## 4. Readability

- [ ] Control flow reads top-to-bottom; guard clauses handle edge cases first.
- [ ] No "clever" terse code that hides intent; clarity over brevity.
- [ ] Ternaries not deeply nested; complex conditions named (`const canEdit = …`).
- [ ] Consistent formatting (Prettier); no manual alignment drift.
- [ ] Comments explain **why**, not what; no commented-out code left behind.

## 5. Dead code

- [ ] No unused imports / variables / functions / exports.
- [ ] No unreachable branches or always-true/false conditions.
- [ ] No leftover debug (`console.log`, temporary flags).
- [ ] Flag pre-existing dead code; **don't delete** unrelated dead code unless asked (per `karpathy-guidelines` surgical-change rule).

## 6. Consistency

- [ ] Matches surrounding file/module idioms (import order, function style, file structure).
- [ ] Same problem solved the same way across the codebase (no three different fetch patterns).
- [ ] Public surface (barrel `index.ts`) exposes only what's intended.

## Output format

Report each violation as `file:line — [category] issue → refactor`, with severity (high = maintainability risk, low = nit). Group by category. End with the verdict (lint pass/fail) and the 3–5 highest-leverage refactors. When DRY and simplicity conflict, defer to `karpathy-guidelines` and say so rather than mandating an abstraction.
