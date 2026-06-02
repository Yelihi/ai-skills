# Design Tokens Reference

Design tokens are the single source of truth for visual decisions. Every component spec references tokens, never raw values. This reference defines the token taxonomy, the two-layer (primitive → semantic) model, and naming conventions.

## The Two-Layer Model

Never let components reference raw values or even raw primitive scales directly. Use two layers:

1. **Primitive (global) tokens** — the raw palette/scale. Context-free. `blue-500: #3b82f6`, `space-4: 16px`. These are the design decisions' raw material.
2. **Semantic (alias) tokens** — intent-based, mapped to primitives. `color-bg-primary`, `color-text-muted`, `space-inline-sm`. Components reference **only these**.

Why: theming (light/dark, brand variants) swaps the semantic→primitive mapping without touching components. A component says `color-bg-danger`; the theme decides that's `red-600` in light and `red-400` in dark.

```
primitive:  red-600 = #dc2626
semantic:   color-bg-danger = {light: red-600, dark: red-400}
component:  Button[variant=danger] → background: color-bg-danger
```

## Token Categories

### Color
- **Primitive**: full ramps per hue (e.g. `gray-50…950`, `blue-50…950`, plus brand). 11-step ramps are a common default.
- **Semantic**: by role × state.
  - Surfaces: `bg-base`, `bg-subtle`, `bg-muted`, `bg-emphasis`, `bg-inverse`
  - Text: `text-base`, `text-muted`, `text-subtle`, `text-on-emphasis`, `text-link`
  - Border: `border-base`, `border-muted`, `border-emphasis`
  - Intent: `bg/text/border-{primary,success,warning,danger,info}`
  - Interaction states: `-hover`, `-active`, `-disabled`, `-focus`
- **Theming**: define each semantic token per theme (light/dark). Ensure contrast meets WCAG AA (see `web-design-guidelines`).

### Typography
- **Primitive**: `font-family-{sans,serif,mono}`, font-size scale (`text-xs…text-9xl` or numeric `font-size-100…`), `font-weight-{400…700}`, `line-height-{tight,normal,relaxed}`, `letter-spacing-*`.
- **Semantic / type styles**: composite tokens bundling size+weight+line-height+tracking → `heading-1`, `heading-2`, `body-md`, `body-sm`, `label`, `code`, `caption`. Components reference these type styles, not individual axes.

### Spacing
- **Primitive**: a single consistent scale, usually 4px-based: `space-0,1,2,3,4,6,8,12,16…` (= 0,4,8,12,16,24,32,48,64px). One scale for margin/padding/gap.
- **Semantic** (optional but useful): `space-inline-sm`, `space-stack-md`, `space-section-lg` for rhythm consistency.

### Radius
`radius-{none,sm,md,lg,xl,full}`. Semantic: `radius-control` (inputs/buttons), `radius-card`, `radius-pill`.

### Shadow / Elevation
`shadow-{xs,sm,md,lg,xl}` mapped to elevation levels. Semantic: `elevation-card`, `elevation-popover`, `elevation-modal`. Keep a small, intentional set.

### Border width
`border-width-{0,1,2}`. Most systems need very few.

### Motion
- **Primitive**: `duration-{75,150,200,300,500}ms`, `easing-{linear,in,out,in-out,emphasized}`.
- **Semantic**: `motion-fade`, `motion-slide`, `motion-expand` bundling duration+easing. Always honor `prefers-reduced-motion` (see `web-design-guidelines`).

### Z-index
A named, ordered scale to prevent stacking wars: `z-base,dropdown,sticky,overlay,modal,popover,toast,tooltip`.

### Breakpoints
`bp-{sm,md,lg,xl,2xl}` (e.g. 640/768/1024/1280/1536). Define mobile-first. Components reference these for responsive specs.

## Naming Conventions

- Pattern: `category-role-variant-state` → `color-bg-primary-hover`, `space-inline-sm`.
- Be consistent: pick one casing (kebab for CSS vars / Tailwind, camel for JS objects) and one ordering.
- Semantic names describe **intent**, never appearance: `color-text-danger`, not `color-text-red`.
- Avoid component-specific tokens unless a component truly needs bespoke values; prefer composing from semantic tokens.

## Delivery Format (match the styling decision)

- **Tailwind** → tokens in `tailwind.config` theme (colors, spacing, fontSize, etc.) + CSS variables for theming.
- **vanilla-extract** → `createThemeContract` + `createTheme` for primitive/semantic layers (type-safe).
- **CSS Modules / plain CSS** → CSS custom properties on `:root` and `[data-theme]`.
- **CSS-in-JS** → a theme object passed via provider.

Tools like Style Dictionary can generate all formats from one source if multi-platform is needed.

## Output

Produce:
1. **Primitive token tables** per category.
2. **Semantic token map** (role → primitive, per theme).
3. **Type styles** (composite typography tokens).
4. **Theming strategy** (light/dark/brand, reduced-motion).

Every component spec (`component-spec-template.md`) must reference these tokens by name.
