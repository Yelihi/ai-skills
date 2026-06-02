# Checklist Template

The master pre-implementation checklist. `feature-checklist` tailors this per feature: fill each item with a concrete, verifiable statement, or mark N/A with a reason. Promote any unresolved upstream decision to a **blocker**. Cut categories that don't apply (and say why) — keep it lean.

Every item must be **verifiable** (checkable true/false by a reviewer), not aspirational.

---

## 0. Blockers (resolve before implementing)
- [ ] All upstream design decisions this feature needs exist (domain types, boundary, state placement, component specs).
- [ ] Any missing decision is listed here explicitly, with who/what resolves it.

## 1. Requirements
- [ ] Feature summary: what it does, for whom, the trigger and the outcome.
- [ ] Acceptance criteria are explicit and testable.
- [ ] In-scope vs out-of-scope stated (no silent scope creep).
- [ ] Open product questions captured.

## 2. Domain & Types (from `ddd-architecture`)
- [ ] Which entities/value objects/workflows this feature touches are named.
- [ ] Domain types reused (not redefined); DTO ↔ domain mapping defined where APIs are involved.
- [ ] Finite states modeled as unions, not boolean bags.
- [ ] New domain concepts (if any) routed back to `ddd-architecture` rather than ad-hoc.

## 3. Server / Client Boundary (from `architecture-design`)
- [ ] What renders on the server vs client is decided; the boundary line is identified.
- [ ] Props crossing the boundary are serializable; no server-only imports in client code.
- [ ] Mutations go through the agreed mechanism (server actions / API), not ad-hoc fetches.
- [ ] The feature lives in the correct FSD slice; import direction respected.

## 4. State (from `spec-advisor` state strategy)
- [ ] Each piece of state is classified: server / client-global / local / URL / form.
- [ ] Each uses the agreed mechanism (no server data in a client store; URL state in search params).
- [ ] Providers/stores mounted at the correct (lowest covering) level.
- [ ] Derived values computed during render, not synced via effects.

## 5. Data Fetching
- [ ] Loading, success, empty, and error states are all defined (not just the happy path).
- [ ] Caching/invalidation strategy on mutations is specified.
- [ ] Parallel vs sequential fetching considered; no unnecessary waterfalls.
- [ ] Optimistic updates / rollback decided where relevant.

## 6. UI & Design System (from `design-system-spec`)
- [ ] All needed components exist in the design system; any new one has a spec first (not invented inline).
- [ ] Tokens used by name — no raw colors/spacing/typography values.
- [ ] Correct variants/states used; no boolean-prop hacks (per composition patterns).
- [ ] Responsive behavior per breakpoint specified.

## 7. Edge Cases & Errors
- [ ] Empty / zero-data state designed.
- [ ] Long content / overflow / truncation handled.
- [ ] Error states: validation errors, network failure, permission/403, not-found/404.
- [ ] Boundary inputs: max length, special characters, large lists, slow network.
- [ ] Concurrency / race conditions (double-submit, stale data) considered.
- [ ] Loading/disabled states prevent invalid interactions.

## 8. Accessibility (per `web-design-guidelines`)
- [ ] Semantic elements / correct roles.
- [ ] Full keyboard operability; visible focus; focus management on open/close.
- [ ] Required ARIA attributes present; form fields labeled and error-associated.
- [ ] Color contrast meets WCAG AA; not color-alone for meaning.
- [ ] Respects `prefers-reduced-motion`.

## 9. Performance
- [ ] No avoidable re-renders (correct memoization/state scoping).
- [ ] Heavy/below-fold work deferred (dynamic import, suspense, lazy).
- [ ] Images/assets optimized; lists virtualized if large.
- [ ] Bundle impact of new dependencies considered.

## 10. Testing (per project test skills)
- [ ] What to unit-test (logic), component-test (behavior), e2e-test (flow) is decided.
- [ ] Tests cover the edge/error cases from §7, not only the happy path.
- [ ] Test data/mocks for server state defined.

## 11. Done Criteria
- [ ] Explicit, verifiable conditions for "complete" (these become the implementation harness's success loop).
- [ ] Each acceptance criterion (§1) maps to a way to verify it.
- [ ] Nothing in Blockers (§0) remains open.

---

## Tailoring Notes
- This is a template, not a fixed form. Cut what doesn't apply (state why); add feature-specific items.
- Phrase items as checkable assertions, not goals: "Show inline Zod error on submit failure" beats "handle errors".
- The output's Done Criteria feed directly into the goal-driven implementation loop.
