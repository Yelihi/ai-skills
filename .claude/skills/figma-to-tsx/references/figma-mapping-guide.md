# Figma → Code Mapping Guide

How to read a Figma node and translate each property into semantic markup + design tokens. The goal is **intent**, not pixel-cloning: a Figma frame describes a layout idea, and your job is to express that idea with tokens and flow layout — not freeze its absolute coordinates.

Tokens referenced here are defined in `design-system-spec/references/design-tokens-reference.md`. When a Figma value has no matching token, **flag it** (see "Missing tokens" below); do not invent an arbitrary value.

## Read structure before style

A Figma node tree is not a DOM tree. Before mapping any style:

1. Identify **semantic roles** — is this group a `nav`, a `button`, a list, a card, a heading? Name the role, pick the right element.
2. Collapse decorative wrapper frames that exist only for Figma grouping.
3. Reuse, don't rebuild — if the node is an instance of a design-system component (Button, Card, Input), map it to that existing component, not fresh markup.

## Layout: Auto-Layout → Flex/Grid

Auto-layout is the single most important signal. Map it, don't approximate it with fixed sizes.

| Figma auto-layout property | Code |
|---|---|
| Horizontal layout | `flex flex-row` |
| Vertical layout | `flex flex-col` |
| Item spacing (gap) | `gap-{token}` (map px → spacing token) |
| Padding | `p-{token}` / `px-`/`py-` (spacing token) |
| Align / justify (packed, space-between, center) | `items-*` / `justify-*` |
| "Fill container" sizing | `flex-1` / `w-full` |
| "Hug contents" sizing | default (auto) — no width class |
| "Fixed" sizing | a width/height token **only if intentional**; prefer hug/fill |
| Wrap | `flex-wrap` |
| Grid (Figma grid layout) | `grid grid-cols-*` + `gap-{token}` |

If a frame is **not** auto-layout but visually a row/column, still express it as flex/grid — absolute coordinates are an artifact of the design tool, not the intended layout.

## Responsive: Constraints → breakpoints

- Figma **constraints** (left/right/center/scale, top/bottom) describe how a node reacts to resizing → translate to mobile-first responsive classes.
- "Left & right" constraint → element stretches → `w-full`.
- "Center" → `mx-auto` or `justify-center` on the parent.
- Multiple frames for the same component (e.g. a "Mobile" and "Desktop" variant) → one component with `sm:`/`md:`/`lg:` prefixes, not two components.
- Default to mobile-first: write the smallest layout unprefixed, layer larger breakpoints on top.

## Color: Fills / Strokes → color tokens

| Figma | Code |
|---|---|
| Solid fill | `bg-{semantic-color-token}` (e.g. `bg-surface`, `bg-primary`) |
| Text fill | `text-{semantic-color-token}` |
| Stroke | `border border-{color-token}` |
| Opacity | `opacity-*` or a token that already encodes it; avoid ad-hoc alpha |
| Gradient | a token-backed gradient utility if one exists; else flag |

Map to the **semantic** token (`bg-primary`, `text-muted`), not the primitive (`bg-blue-500`). A named Figma style (e.g. `color/bg/primary`) usually maps 1:1 to a semantic token — match by name first.

## Typography: Text styles → type tokens

- A Figma **text style** (e.g. `Heading/M`, `Body/Regular`) maps to a composite **type token** (`text-heading-m`, `text-body-md`) — one class, not four separate size/weight/line-height/tracking utilities.
- If only raw values are present (size 16 / weight 500 / lh 24), map to the closest type token and **flag the missing named style**.
- Choose the heading level by document semantics (`h1`/`h2`), not by font size.

## Spacing, Radius, Shadow, Border

| Figma | Code |
|---|---|
| Corner radius | `rounded-{radius-token}` (`rounded-control`, `rounded-card`) |
| Drop/inner shadow | `shadow-{elevation-token}` (`shadow-card`, `shadow-popover`) |
| Stroke width | `border` / `border-2` (border-width token) |
| Gap / padding / margin | spacing token (see Auto-Layout) — never a bare px |

## Variants: Figma component variants → component variants

- A Figma component with variant properties (`intent=primary/danger`, `size=sm/md/lg`) maps to a **variant union** on the component, implemented with `cva` (see `tailwind-conventions.md`) — **not** boolean props (per `vercel-composition-patterns`).
- Each Figma variant combination becomes one entry in the variant config; map its style deltas to token changes (e.g. `intent=danger` → `bg-danger`).
- Boolean-looking states (hover, disabled, focus) are **states**, not variants → map to Tailwind state prefixes (`hover:`, `disabled:`, `focus-visible:`) using the component spec's state tokens.

## Absolute positioning: avoid

- Don't translate Figma x/y into `absolute left-[..] top-[..]`. That reproduces coordinates, not layout, and breaks responsively.
- Use absolute positioning **only** for genuine overlays/badges/layered UI the design intends (a notification dot, a dropdown). Even then, anchor with `relative` parent + token offsets.

## Missing tokens (do not hardcode)

When a Figma value maps to no existing token:

1. Note it in the **Mapping notes / Gaps** output.
2. Use the nearest token and mark it provisional, **or** leave a clear `TODO(design-system-spec): add token for …`.
3. Never silently emit `bg-[#1a2b3c]` / `p-[13px]` as if intentional — arbitrary values are a signal that the design system is missing a decision, which belongs to `design-system-spec`.

## Output of a mapping pass

- Semantic component tree (roles named).
- Per-node style → token mapping.
- A list of: reused design-system components, missing tokens, and nodes better expressed as variants. Hand these to `component-builder` (structure) and `design-system-spec` (tokens).
