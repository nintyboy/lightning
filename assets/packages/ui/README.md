# @openfn/ui

Lightning's design system package (POC stage). Canonical React components + the
**shared class recipes** that keep the React and HEEx implementations of each
primitive visually identical.

## What's here

```
packages/ui/
├── recipes/            # shared class recipes — SINGLE styling source per component
│   └── button.json     #   read by BOTH lib/lightning_web/components/ui/button.ex
│                       #   (compile time) and src/button/Button.tsx (import)
├── src/
│   ├── index.ts        # public API
│   └── button/
│       ├── Button.tsx           # CVA variants over the recipe + react-aria Button
│       ├── SplitButton.tsx      # primary action + attached menu (react-aria MenuTrigger)
│       ├── Button.stories.tsx   # Storybook stories incl. play() interaction tests
│       ├── SplitButton.stories.tsx
│       └── Button.test.tsx      # vitest unit + behavior + axe a11y tests
└── .storybook/         # Storybook 9 (react-vite builder, a11y addon = error level)
```

Conventions baked in:

- **Styling lives in the recipe, not the component.** CVA models variants; the
  enabled/disabled swap is a CVA `vstate` dimension so hover styles can never
  leak into disabled states, and rendered classes match the HEEx twin exactly.
- **Behavior comes from react-aria** (`react-aria-components`): press/keyboard
  semantics, menu focus management, dismissal.
- **i18n**: components ship NO user-facing English. Icon-only buttons and the
  SplitButton menu trigger require an accessible name at the type level.
- **Self-contained**: package-internal icons are inline SVG (no dependency on
  the app's `hero-*` Tailwind plugin), so the package renders correctly in
  Storybook and stays publishable.

## Run

```bash
# Storybook (from assets/packages/ui)
npm run storybook            # dev server on :6006
npm run build-storybook      # static build → storybook-static/

# In-app: the mix esbuild/tailwind pipeline resolves @openfn/ui via the npm
# workspace symlink — no extra build step. `mix esbuild default` just works.
```

## Test

```bash
# from assets/
npx vitest run packages/ui                    # unit + behavior + axe tests
npx vitest run --coverage packages/ui \
  --coverage.include='packages/ui/src/**' \
  --coverage.exclude='**/*.stories.tsx' --coverage.exclude='**/index.ts'

# HEEx twin (from repo root)
mix test test/lightning_web/components/ui/button_test.exs
```

Current coverage (2026-07-16): statements 92.3% (Button.tsx 87%, SplitButton.tsx
100%), functions 100%. Uncovered lines are the deprecated `nakedClose` branch.

## Changing a component's styling

1. Edit `recipes/<component>.json` only.
2. `mix compile` — the HEEx twin recompiles via `@external_resource`; a
   compile-time guard fails the build if recipe keys and the HEEx attr values
   disagree.
3. `npx vitest run packages/ui` — the recipe-contract test fails if the React
   side stops exposing any recipe variant/size.
4. Storybook + visual regression are the human check.

## What changed in the button POC (summary)

See `docs/poc/button-manifest.md` for the verifiable list and
`docs/poc/button-consolidation.html` for the full story. Headlines: one
canonical Button per stack; 2 duplicate HEEx implementations deleted; React
secondary drift killed by the recipe; ghost variant + icon size formalized;
`iconLeft`/`iconRight` (React) and `icon`/`icon_right` (HEEx) added; SplitButton
added as the consolidation target for the three bespoke split buttons in the
inventory.
