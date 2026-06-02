# TailwindCSS Conventions

How to write the Tailwind in a converted component so it stays token-driven, readable, and consistent. These conventions assume tokens are defined in `tailwind.config` per the Tailwind delivery section of `design-system-spec/references/design-tokens-reference.md` — that file owns *how tokens are defined*; this file owns *how classes are written*.

## 1. Token-driven config, no arbitrary values

- Every spacing/color/radius/type value must come from a configured token utility (`p-4`, `bg-primary`, `rounded-card`, `text-body-md`).
- **Avoid arbitrary-value classes** (`p-[13px]`, `bg-[#3b82f6]`, `text-[15px]`). An arbitrary value means the token is missing → flag it for `design-system-spec` instead of inlining.
- Rare, justified exceptions (a one-off `grid-template`, a magic aspect ratio) must be commented with why.

## 2. Semantic token utilities over primitives

- Use semantic utilities (`bg-surface`, `text-muted`, `border-base`) so theming swaps work. Avoid primitive scales (`bg-gray-100`) in components.
- Configure semantic tokens as named colors/spacing in `tailwind.config` so `bg-primary` etc. exist as first-class utilities.

## 3. Variants with `cva`, not boolean props

For any component with variants, use `class-variance-authority` (`cva`) to centralize the variant→class map. This keeps the design's variant matrix explicit and avoids boolean-prop proliferation (per `vercel-composition-patterns`).

```tsx
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/shared/lib/cn";

const button = cva(
  "inline-flex items-center justify-center rounded-control font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-focus disabled:opacity-50 disabled:pointer-events-none",
  {
    variants: {
      intent: {
        primary: "bg-primary text-on-primary hover:bg-primary-hover",
        secondary: "bg-surface text-base border border-base hover:bg-subtle",
        danger: "bg-danger text-on-danger hover:bg-danger-hover",
      },
      size: {
        sm: "h-8 px-3 text-body-sm",
        md: "h-10 px-4 text-body-md",
        lg: "h-12 px-6 text-body-md",
      },
    },
    defaultVariants: { intent: "primary", size: "md" },
  },
);

type ButtonProps = React.ComponentProps<"button"> & VariantProps<typeof button>;
```

(The final props-API shape — `...rest`, `ref`, controlled/uncontrolled — is `component-builder`'s job; here just get the class structure right.)

## 4. Merge classes with `cn` / `clsx` + `tailwind-merge`

- Use a single `cn` helper (`clsx` + `tailwind-merge`) so consumer overrides win and conflicting utilities resolve predictably.
- Always allow a `className` passthrough merged last: `cn(button({ intent, size }), className)`.

## 5. Mobile-first responsive

- Write the base (smallest) layout unprefixed; add `sm:`/`md:`/`lg:`/`xl:` for larger screens. Don't write desktop-first with `max-*`.
- Breakpoint prefixes map to the `bp-*` tokens; don't introduce ad-hoc breakpoints.

## 6. States via prefixes, using state tokens

- Interactive states use Tailwind prefixes: `hover:`, `active:`, `focus-visible:`, `disabled:`, `aria-*:`, `data-*:`.
- **Never remove focus rings.** Use a visible `focus-visible:ring-*` with the focus token (see `web-design-guidelines`).
- Respect motion preference: gate animations with `motion-reduce:` or the design's reduced-motion rule.

## 7. Dark mode / theming

- Drive theming through the semantic token layer. Depending on the project's strategy, dark mode resolves via `dark:` variants or a `[data-theme]` attribute that remaps token values — match whatever `design-system-spec` chose. Don't hardcode a second palette inline.

## 8. No inline styles

- Don't use the `style` prop for values that have a token/utility. Inline styles bypass the token system and the merge logic.
- Genuine dynamic values (a computed transform, a CSS variable set from data) are the only allowed `style` use — and prefer setting a CSS custom property that a utility reads.

## 9. Keep class lists legible

- Order roughly: layout → box model → typography → color → states. (Use the Tailwind Prettier plugin / class sorter to enforce.)
- When a class list gets long or repeats across siblings, extract it: a `cva` slot, a small wrapper component, or a shared constant. Repetition is a refactor signal.

## 10. Don't reinvent design-system components

- If the design uses a Button/Input/Card that already exists, import it — don't restyle a raw element with the same utilities. Re-creation drifts from the spec and duplicates the token mapping.

## Output

Token-driven Tailwind: configured utilities only, variants via `cva`, merged with `cn`, mobile-first, accessible focus/motion, no inline styles, no arbitrary values left unflagged. Anything that *forced* an arbitrary value is reported as a missing token for `design-system-spec`.
