# Accessibility Audit Checklist (WCAG)

The audit rubric for `a11y-checker`. Each item is a checkable assertion against the implemented UI, aligned to WCAG 2.1 AA. Use an automated checker (axe / eslint-plugin-jsx-a11y / Lighthouse) as evidence where available; this list covers what tools miss and what to verify manually. Broad UI/UX review → `web-design-guidelines`.

## 1. Semantics

- [ ] Native elements used for their role: `button` for actions, `a[href]` for navigation (never a clickable `div`).
- [ ] Landmarks present: `header`, `nav`, `main`, `footer`; one `main` per page.
- [ ] Headings form a logical outline (`h1` → `h2` → …), no levels skipped for styling.
- [ ] Lists use `ul`/`ol`/`li`; tables use `table`/`th[scope]` with real headers.
- [ ] ARIA roles only fill gaps; no role that contradicts the native element (`<button role="link">` is a smell).

## 2. Keyboard

- [ ] Every interactive element is focusable and operable by keyboard.
- [ ] Activation keys correct: Enter/Space for buttons, Esc closes overlays, arrows navigate menus/tabs/radios.
- [ ] Logical tab order matches visual order; no positive `tabindex`.
- [ ] No keyboard traps (focus can always move out, except intentional modal focus trap).
- [ ] Custom widgets implement the expected keyboard interaction pattern (APG).

## 3. Focus management

- [ ] Visible focus indicator on all focusable elements; `outline: none` always has a replacement (`focus-visible` ring).
- [ ] Opening a dialog/menu moves focus into it; closing returns focus to the trigger.
- [ ] Modals trap focus while open.
- [ ] Route/content changes move focus appropriately (e.g. to heading) — no lost focus.
- [ ] No focus on non-interactive elements without reason.

## 4. ARIA & screen reader

- [ ] Icon-only / unlabeled controls have `aria-label` or visually-hidden text.
- [ ] State attributes present and updated: `aria-expanded`, `aria-selected`, `aria-checked`, `aria-current`, `aria-pressed`.
- [ ] Relationship attributes: `aria-controls`, `aria-describedby`, `aria-labelledby` point to real IDs.
- [ ] Async/dynamic updates announced via `aria-live` (polite/assertive) or a status region.
- [ ] No redundant ARIA duplicating native semantics; no `aria-hidden` on focusable content.

## 5. Perceivable

- [ ] Text contrast ≥ 4.5:1 (≥ 3:1 for large text); UI component/icon contrast ≥ 3:1.
- [ ] Meaning never by color alone (error also has icon/text; links distinguishable beyond color).
- [ ] Images: meaningful → descriptive `alt`; decorative → `alt=""`; complex → described.
- [ ] Content reflows / remains usable at 200% zoom and on small viewports; touch targets ≥ 44×44px.
- [ ] No content flashes more than 3×/sec.

## 6. Forms

- [ ] Every input has an associated `<label>` (or `aria-label`/`aria-labelledby`).
- [ ] Required/invalid states use `aria-required` / `aria-invalid`.
- [ ] Error messages are programmatically associated (`aria-describedby`) and announced.
- [ ] Inputs have appropriate `type`/`autocomplete`; grouped controls use `fieldset`/`legend`.

## 7. Motion

- [ ] Animations/transitions respect `prefers-reduced-motion` (reduced/none).
- [ ] No essential information conveyed only through motion.
- [ ] Auto-playing/looping motion can be paused/stopped.

## Output format

Report each violation as `file:line — [category] WCAG concern → fix`, with severity (blocker = a user group can't use it; improvement = friction). Group by category. End with the verdict and the must-fix blockers. General (non-a11y) UX issues get a "→ web-design-guidelines" pointer; missing component-level a11y specs get a "→ design-system-spec" pointer.
