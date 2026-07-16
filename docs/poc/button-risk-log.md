# Button consolidation POC — running risk log

> Source of truth for the POC. The HTML companion doc is generated from this at
> the end. Branch: `feature/button-poc`. Started 2026-07-15.

## Roles served

**The UX designer (Tyrell)** wants exactly one Button component per stack,
matching the Figma "Buttons" set (indigo primary, white/ring secondary, danger).
Every button in the app should be an instance of it. Variant and size names
match Figma vocabulary, with one deliberate exception: Figma's `Warning` maps to
code's `danger` (naming alignment is a known Phase 0 gate; we use `danger` and
log the divergence).

**The engineers** care about: (X) zero behavioral or visual regressions on 175
call sites, especially form submission semantics (`type="submit"`,
`phx-disable-with`, changeset flows) and LiveView test coverage; (Y) reviewable
diffs — mechanical, batched, one concern per commit, no drive-by refactors; (Z)
no new maintenance burden — the React and HEEx buttons must not drift (the
shared recipe exists to prove this), and the public API must be small and
stable.

When these conflict, the conflict and the judgment call are recorded below.

## Baseline

- Branch created off `main` at 32f10014.
- `mix test` baseline: PENDING (first run hit a stale crc32cer CMake cache from
  a previous checkout path; fixed with
  `mix deps.get && mix deps.compile crc32cer`; rerun in progress).
- Environment note (not a POC change): `deps/crc32cer` had a stale cache
  pointing at `/Users/tyrell/Code/Projects/lightning`; cleaned.

## Census (fan-out) — commands recorded

| #   | Implementation                         | Location                                                                                              | Call sites                                                                                                                                     | Grep command                                                              | Disposition                                                                                                                                                                                                                                     |
| --- | -------------------------------------- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `<.button>` (canonical winner)         | `lib/lightning_web/components/new_inputs.ex:120,139` (themes :229-264, sizes :225-227, base :221-223) | **163** `<.button\b` (incl. 9 doc examples in moduledoc → ~154 real)                                                                           | `grep -rn '<\.button\b' lib --include='*.ex' --include='*.heex' \| wc -l` | Move to `ui/button.ex`, recipe-backed; API preserved                                                                                                                                                                                            |
| 1a  | `<.button_link>`                       | same file, :171                                                                                       | **12**                                                                                                                                         | `grep -rn '<\.button_link\b' lib \| wc -l`                                | Moves with it                                                                                                                                                                                                                                   |
| 1b  | `simple_button_with_tooltip`           | same file, :271                                                                                       | 1 external usage (`ai_assistant/component.ex:702`)                                                                                             | `grep -rn 'simple_button_with_tooltip' lib \| grep -v new_inputs`         | Moves with it (internal delegation target)                                                                                                                                                                                                      |
| 2   | `submit_button`                        | `live/components/form.ex:10`                                                                          | **3**, all in `project_live/form_component.html.heex`                                                                                          | `grep -rn 'submit_button' lib \| grep -v def`                             | DELETE + migrate 3 call sites. ⚠️ Styling differs from canonical primary: `hover:bg-primary-700` (vs 500), `font-medium` (vs semibold), `px-4` (vs px-3), `focus:ring` (vs focus-visible:outline). Migration = small intentional visual change. |
| 3   | `cancel_button`                        | `live/components/credentials.ex:71`                                                                   | 12                                                                                                                                             | `grep -rn 'cancel_button' lib \| grep -v def`                             | **FINDING: inventory misclassified.** It already delegates to `<.button theme="secondary">` + modal-close JS. It is a composition, not a duplicate. No migration; keep.                                                                         |
| 4   | React `Button.tsx`                     | `assets/js/collaborative-editor/components/Button.tsx`                                                | 5 importing files, **11** `<Button` usages                                                                                                     | `grep -rn '<Button\b' assets/js/collaborative-editor \| wc -l`            | Rewire to shared recipe JSON. ⚠️ Secondary variant has ALREADY drifted from HEEx (`inset-ring`+`hover:inset-ring-gray-400` vs `ring-1 ring-inset`+`hover:bg-gray-50`) — live proof the recipe is needed. Unify on HEEx (winning base).          |
| 5   | Raw `<button>` one-offs                | `lib/lightning_web/live/**`                                                                           | **67** across 39 files (top: ai_assistant 7, credential_form 5; incl. `dev/react_live.ex` 1 dev-only, `workflow_live/edit.ex` 1 FROZEN legacy) | `grep -rn '<button' lib/lightning_web/live \| wc -l`                      | Migrate in batches where `<.button>`/ghost/icon variant fits; skip-with-reason where entangled                                                                                                                                                  |
| 6   | Ghost-styled one-offs                  | subset of #5 (e.g. `ai_assistant/component.ex:770,801,871,1377`) + React `nakedClose`                 | counted per batch                                                                                                                              | —                                                                         | Becomes `ghost` variant (classes from most common production pattern)                                                                                                                                                                           |
| 7   | Icon-only one-offs                     | subset of #5 (e.g. `common.ex:507,552` alert dismiss)                                                 | counted per batch                                                                                                                              | —                                                                         | Becomes icon-only support (square padding size)                                                                                                                                                                                                 |
| 8   | `button_loader`                        | `components/loaders.ex:31`                                                                            | **0 usages**                                                                                                                                   | `grep -rn 'button_loader' lib \| grep -v def`                             | **FINDING: dead code.** DELETE. Do NOT build a `loading` state for it (zero demand; Figma loading state is a Phase 0 gate).                                                                                                                     |
| 9   | Petal buttons                          | —                                                                                                     | **0**                                                                                                                                          | `grep -rn 'PetalComponents.*[Bb]utton' lib`                               | None exist. No action.                                                                                                                                                                                                                          |
| —   | Raw `<button>` inside other components | `components/{pills,table,layout_components,viewers}.ex` (6)                                           | 6                                                                                                                                              | `grep -rc '<button' lib/lightning_web/components`                         | DEFER: these are internal mechanics of other components (filter-badge ×, sort header, sidebar toggle, log-viewer controls) — they belong to those components' own consolidation, not Button's.                                                  |

Out of scope (logged, not built): SplitButton, ButtonGroup, `table-action` CSS
utility, CopyButton.

## Pre-existing drift found during census (evidence for the recipe)

1. HEEx secondary:
   `bg-white hover:bg-gray-50 text-gray-900 ring-1 ring-gray-300 ring-inset` —
   React secondary:
   `bg-white text-gray-900 inset-ring inset-ring-gray-300 hover:inset-ring-gray-400`.
   Two different hover behaviors in production today.
2. Disabled cursor: HEEx `disabled:cursor-auto`; React
   `disabled:cursor-not-allowed`; ui-patterns.md mandates not-allowed.
   Divergence carried per-stack for now (preserve production), logged as a
   unification candidate.
3. HEEx button has themes `success`, `warning`, `custom` that the audit and
   Figma don't know about (2×success, 1×warning, 2×custom call sites). Recipe
   carries them; flagged to designer.
4. `<.button>` with NO theme renders a completely unstyled button (attr has no
   default). All real call sites pass a theme (verified — apparent no-theme hits
   were multiline attrs). API hazard, logged.

## Switch log

### Switch 1 — Canonical target built; `<.button>` repointed (entries #1/1a/1b/#4 + recipe)

**Pre-switch risk assessment**

- Business risk: **High exposure, low likelihood.** Every `<.button>` in the app
  (163 refs incl. 12 `button_link`) renders through the new module — a mistake
  breaks save/submit/delete everywhere. Mitigation: implementation is a verbatim
  move; only the class _source_ changed (module attrs → recipe JSON).
  Reversible: single revert.
- Technical risk: **Medium.** (a) import ambiguity (button defined in two
  imported modules) — caught at compile with warnings-as-errors; (b) recipe/attr
  mismatch — added a compile-time guard that raises if recipe keys ≠ attr
  values; (c) class ORDER changes (font/shadow moved from base into variant
  strings so ghost can differ) — class order is irrelevant to CSS; sets verified
  identical by rendering (docs/poc/rendered-classes-after.txt); (d) React JSON
  import — `resolveJsonModule` already on; esbuild bundles JSON natively.
- Rating: **Medium** — wide blast radius but mechanical move with compile-time +
  render-level verification.

**What was done**

- `assets/packages/ui/recipes/button.json` created (encodes CURRENT production
  classes; ghost variant added from the dominant one-off pattern; icon size
  added).
- `lib/lightning_web/components/ui/button.ex` created — verbatim move of
  `button/1`, `button_link/1`, `simple_button_with_tooltip/1` + private
  `tooltip_when_disabled/1` from new_inputs.ex, class helpers now generated from
  the recipe at compile time (`@external_resource` → recipe edits recompile the
  module). Compile-time recipe⇄attr guard.
- `new_inputs.ex`: moved code deleted (−297 lines).
- `lightning_web.ex`: `import LightningWeb.Components.UI.Button` added at all 5
  NewInputs sites.
- `live_helpers.ex`: qualified `<NewInputs.button>` → `<UI.Button.button>` (2
  lines).
- `workflow_live/edit.ex` (FROZEN legacy): one import line added — strictly
  required to compile its 14 existing `<.button>` refs. No other legacy change.
- React `Button.tsx`: variant classes now read the recipe. primary/danger
  byte-compatible. **secondary intentionally unified onto the HEEx
  (winning-base) classes** — hover changes from `inset-ring-gray-400` to
  `bg-gray-50` (the two stacks had already drifted; recipe ends it).
  `nakedClose` kept React-local (1 usage; fold-into-ghost is a follow-up).
  Disabled handling moved from CSS pseudo-classes to conditional class swap
  (same visuals, satisfies the ui-patterns.md disabled:hover rule by
  construction).
- `app.css`: `@source './packages/ui/recipes/*.json'` — VERIFIED Tailwind emits
  classes found only in the JSON (ghost hover classes present in built css).
- Stale storybook story (pointed at nonexistent `Common.button/1`) rewritten
  against the canonical button with theme/size/state variations.

**Verification**

- `mix compile --warnings-as-errors` clean.
- Rendered class strings for primary/secondary/danger/ghost/disabled captured
  (docs/poc/rendered-classes-after.txt) — identical sets to the previous
  implementation.
- `npx tsc --noEmit -p tsconfig.browser.json`: only pre-existing failures in
  untouched `adaptor-docs/*` (verified untouched vs main). Button.tsx clean.
- `npx vitest run` NewRunButton + RunRetryButton (Button consumers): 39/39 pass.
- `mix esbuild default` + `mix tailwind default` green.
- Full `mix test`: see below (baseline had 2 pre-existing failures in
  `Lightning.WebAndWorkerTest` — worker-runtime integration, unrelated to UI).

**Residual risk: Low-Medium.** Visual check in a browser not yet done (no dev
server run); class-set equivalence is strong but not pixel proof. React
secondary hover is an intentional visible change in the collab editor (log to
designer). Accepted for POC; Chromatic-style baseline would close this in the
real programme.

### Switch 2 — `submit_button` deleted, call site migrated (entry #2)

**Pre-switch risk assessment**

- Business risk: **Low.** One real call site (census's "3" was open tag + close
  tag + @spec). It is the SAVE button on the project settings form — submission
  semantics matter (`type="submit"`, `phx-disable-with="Saving"`,
  changeset-driven `disabled`), but `<.button>` passes all three through (`type`
  attr; `phx-*` via `:global`; `disabled` in the include list). Trivially
  reversible.
- Technical risk: **Low.** No JS hooks, no dynamic classes. Deliberate visual
  delta (consolidation, not regression): hover `primary-700`→`primary-500`,
  `font-medium`→`font-semibold`, `px-4`→`px-3`, `focus:ring`→
  `focus-visible:outline`. This is the point of one canonical primary; logged
  for the designer.
- Rating: **Low.**

**What was done**

- `project_live/form_component.html.heex`: `<.submit_button …>` →
  `<.button type="submit" theme="primary" …>` (same bindings).
- `live/components/form.ex`: `submit_button/1` deleted (spec + attrs + def).
- `project_live/form_component.ex`: now-unused
  `import LightningWeb.Components.Form` removed (warnings-as-errors caught it).

**Verification**

- `mix compile --warnings-as-errors` clean.
- `mix test test/lightning_web/live/project_live_test.exs`: 130 tests, 0
  failures.
- `mix test test/lightning_web/live/project_live`: 6 tests, 0 failures.
- Grep gate: `grep -rn 'submit_button' lib` → 0 hits.

**Residual risk: Low.** Submit flow covered by ProjectLiveTest (130 green). The
visual delta on one Save button ships intentionally.

### Switch 3 — `button_loader` deleted (entry #8)

**Pre-switch risk**: **Low** — zero references anywhere in
lib/test/storybook/assets (census + re-verified pre-delete). Dead code removal
only. **Decision**: do NOT add a `loading` state to the canonical button in its
place — zero production demand; Figma's loading state is a Phase 0 gate. YAGNI.
**Verification**: reference grep 0 hits; `mix compile --warnings-as-errors`
clean. **Residual risk: none identified.**
