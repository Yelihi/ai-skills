# Component Spec Template

A per-component specification template. Fill one out for each primitive and key composite. Components reference design tokens by name (see `design-tokens-reference.md`) and follow `vercel-composition-patterns` for their props API. The spec is the contract; implementation fills it in.

## Component Hierarchy (classify first)

- **Primitives** — single-purpose, token-driven, no domain knowledge. `Button`, `Input`, `Text`, `Icon`, `Badge`, `Checkbox`. Live in `shared/ui`.
- **Composites** — built from primitives, still domain-agnostic. `Card`, `Modal`, `Dropdown`, `Tabs`, `Toast`, `FormField`. Live in `shared/ui`.
- **Patterns** — composed UI blocks, may know layout/flow but not business logic. `DataTable`, `PageHeader`, `EmptyState`. Often FSD `widgets`.

Specify primitives first; composites depend on them.

## The Template

For each component, fill in:

### 1. Purpose & Anatomy
- **Purpose**: one sentence — what it's for and when to use it (and when not to).
- **Anatomy**: named parts (e.g. Button = container + icon-slot + label). For multi-part components, prefer **compound components** (`Card.Header`, `Card.Body`) per `vercel-composition-patterns`.

### 2. Variants
Explicit, named variants — not boolean flags. Per `vercel-composition-patterns`, avoid boolean-prop proliferation; use a `variant` union.

| Variant axis | Values | Token(s) used |
|--------------|--------|---------------|
| intent | primary / secondary / danger / ghost | `color-bg-*`, `color-text-*` |
| size | sm / md / lg | `space-*`, `text-*`, `radius-control` |
| ... | ... | ... |

Avoid impossible combinations; if two axes conflict, document the rule or split into separate components (explicit-variants rule).

### 3. States
Every interactive component specifies all of:
- `default`, `hover`, `active`, `focus-visible`, `disabled`, `loading`, `error/invalid`, `selected/checked` (as applicable).
- Each state names the token(s) that change (e.g. `hover → color-bg-primary-hover`).
- **Focus** must use a visible focus ring (`-focus` tokens); never remove focus outlines (see `web-design-guidelines`).

### 4. Props API
Design per `vercel-composition-patterns`:
- Prefer **composition / children** over `renderX` props.
- Prefer **explicit variant unions** over multiple booleans.
- Pass through native element props (`...rest`) and `ref` (React 19: ref as prop, no `forwardRef`).
- Controlled vs uncontrolled: specify which, and the `value`/`defaultValue` + `onChange` contract.

| Prop | Type | Default | Notes |
|------|------|---------|-------|
| variant | `'primary' \| 'secondary' \| 'danger' \| 'ghost'` | `'primary'` | |
| size | `'sm' \| 'md' \| 'lg'` | `'md'` | |
| disabled | `boolean` | `false` | also sets aria-disabled |
| ... | | | |

### 5. Accessibility (a11y)
Reference `web-design-guidelines`; specify per component:
- **Role / semantics**: correct native element or ARIA role (`button`, `role="dialog"`, etc.).
- **Keyboard**: full keyboard operation (Enter/Space activate, Esc closes, arrow-key navigation for composites, focus trap for modals).
- **ARIA**: required attributes (`aria-label`, `aria-expanded`, `aria-controls`, `aria-invalid`, `aria-describedby`).
- **Focus management**: focus order, focus return on close, visible focus ring.
- **Contrast**: token choices must meet WCAG AA.
- Prefer a headless primitive (Radix / React Aria) for complex widgets to get a11y correct by default.

### 6. Responsive Behavior
- Behavior per breakpoint (`bp-*` tokens): layout shifts, size changes, touch-target sizing (min 44×44px on touch).
- Mobile-first defaults; specify what changes upward.

### 7. Motion
- Transitions/animations using `motion-*` / `duration-*` / `easing-*` tokens.
- Must respect `prefers-reduced-motion`.

### 8. Usage Examples & Do/Don't
- A canonical usage snippet (composition shape).
- 1–2 do/don't pairs catching the most likely misuse (e.g. "Don't use `Button` for navigation — use a link").

## Filled Example (Button, abbreviated)

```
Purpose: Trigger an action. Use a link, not Button, for navigation.
Anatomy: [icon?] + label, optional loading spinner replacing icon.
Variants: intent(primary/secondary/danger/ghost) × size(sm/md/lg).
States: default, hover (bg→*-hover), active, focus-visible (focus ring),
        disabled (aria-disabled, bg→*-disabled), loading (spinner, aria-busy).
Props: variant, size, disabled, loading, leftIcon?, ...buttonProps, ref.
A11y: native <button>; Enter/Space activate; visible focus ring; aria-busy when loading;
      icon-only requires aria-label.
Responsive: full-width option below bp-sm via composition, not a prop.
Motion: bg transition duration-150 easing-out; none under reduced-motion.
```

## Output

A spec sheet per primitive and key composite, plus the component inventory (hierarchy + where each lives). These become the UI contract checked by `feature-checklist` and built by the implementation harness.
