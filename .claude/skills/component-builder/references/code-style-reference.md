# Code Style Reference

Concrete TSX style for authored components. The aim is code that reads like the rest of the codebase: predictable shape, typed cleanly, no magic values. This covers *style*; structure/purity is in `component-authoring-guide.md`, composition depth in `vercel-composition-patterns`.

**First rule:** match the surrounding code. If the project already has a consistent idiom (arrow vs function, `type` vs `interface`, import order), follow it over anything below.

## Component declaration

- Prefer a named function declaration for the component; export it explicitly.

```tsx
export function CartItem({ item, onRemove }: CartItemProps) {
  // ...
}
```

- Arrow-function components are fine if that's the codebase norm — be consistent, don't mix.
- One primary component per file (small private subcomponents below it are okay).

## Typing props

- Use `type` for props by default (unions/intersections compose cleanly); use `interface` if the codebase standardizes on it or you need declaration merging.
- Extend native element props when wrapping one element:

```tsx
type CartItemProps = {
  item: CartLineItem;          // reuse domain type from ddd-architecture
  onRemove: (id: string) => void;
} & Omit<React.ComponentProps<"li">, "onChange">;
```

- Variants as unions: `variant: "primary" | "secondary" | "danger"`.
- Reuse domain types — don't redefine entity shapes locally (per `ddd-architecture`).

## Defaults

- Default via destructuring, not `defaultProps`:

```tsx
function Button({ size = "md", intent = "primary", ...rest }: ButtonProps) {}
```

## Conditional rendering

- Early-return for whole-component branches (loading/empty/error):

```tsx
if (isLoading) return <Skeleton />;
if (items.length === 0) return <EmptyState />;
```

- Inline: ternary for either/or; `&&` only when the left side is a real boolean. Guard against `0 && <X/>` rendering `0` — use `items.length > 0 && …` or a ternary.
- Don't nest ternaries deeply; extract a variable or a small subcomponent.

## Lists & keys

- Stable, unique key (entity id). Never the array index for reorderable/insertable lists.
- Extract the row into a named component when the map body grows beyond a few lines.

## Imports

- Order: external packages → internal aliases (`@/…`) → relative → styles/types. Keep one consistent grouping (let the linter sort).
- Respect FSD import direction; no upward imports.
- Type-only imports use `import type { … }`.

## No magic values

- No raw colors/spacing/sizes — reference tokens via Tailwind utilities (`text-body-md`, `bg-primary`) per `figma-to-tsx`/`design-system-spec`.
- No unexplained literals in logic; name them (`const MAX_ITEMS = 50`).

## Comments

- Comment **why**, not **what**. Match the file's existing comment density — don't add narration the codebase doesn't use.
- Prefer self-explanatory names over comments.

## Accessibility in markup

- Use the semantic element first (`button`, `a`, `nav`, `label`); reach for ARIA only to fill gaps. Associate labels and errors with inputs. Follow `web-design-guidelines`.

## Do / Don't

```tsx
// ❌ booleans for variants, index key, derived state via effect, magic color
function Tag({ isError, isWarning, items }: Props) {
  const [label, setLabel] = useState("");
  useEffect(() => setLabel(items.join(", ")), [items]);
  return items.map((t, i) => <span key={i} style={{ color: "#dc2626" }}>{t}</span>);
}

// ✅ variant union, stable key, derive in render, token utility
function Tag({ variant = "error", items }: Props) {
  const label = items.join(", ");
  return (
    <ul aria-label={label}>
      {items.map((t) => (
        <li key={t.id} className={cn("text-body-sm", tag({ variant }))}>
          {t.name}
        </li>
      ))}
    </ul>
  );
}
```

## Output

A component that is consistent with the codebase, cleanly typed, free of magic values and impurity, and ready for `frontend-test-principles` to test.
