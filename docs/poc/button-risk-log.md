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

### Switch 4 — Batch A: 3 secondary-lookalike raw buttons (subset of entry #5)

**Sites**: `backup_codes_live/index.html.heex` (Print Codes; Generate new backup
codes), `components/user_deletion_modal.ex` (Cancel). **Pre-switch risk: Low** —
the hand-rolled classes were byte-for-byte the canonical secondary/lg set
(`px-3.5 py-2.5 font-semibold shadow-xs ring-1 ring-inset ring-gray-300 hover:bg-gray-50`);
layout extras kept as class overrides; `onclick`/`phx-click` pass through
`:global`. **Verification**: compile clean; backup_codes (16) + profile (49) +
ai_assistant (25) + user_live (25) LiveView tests green; class-set equivalence
by inspection (exact-string match). **Residual: none identified** —
byte-equivalent.

### Switch 5 — Batch B: 2 ai-assistant ghost buttons (subset of entries #5/#6)

**Sites**: `ai_assistant/component.ex` sort-toggle and message-copy.
**Pre-switch risk: Low-Medium** — deliberate consolidation deltas: sort
px-3→px-2.5 (size sm), focus:ring-2-indigo → focus-visible:outline-gray-400;
copy base color text-gray-400 → ghost text-gray-600. Both retain
phx-click/phx-hook/aria-label through `:global`. **Verification**: compile
clean; ai_assistant LiveView tests 25/25. **Residual: Low** — small visible
deltas ship intentionally (unification); flagged to designer.

### Switch 6 — Disposition of the remaining 61 raw `<button>`s: DEFER by owning component

The census's biggest finding: most raw buttons are not Button one-offs — they
are the anatomy of OTHER components. Migrating them into `<.button>` would bloat
the Button API (padding-less sizes, close variants, switch styling) without
consolidating anything real. Each category is deferred to its owning component's
consolidation, per the master inventory sheet:

| Category                                           | Count  | Evidence / examples                                                                                                   | Owner (deferred to)                                                                                 |
| -------------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Modal close X (identical class string)             | **27** | `grep -rn 'rounded-md bg-white text-gray-400 hover:text-gray-500 focus:outline-none' lib/lightning_web/live \| wc -l` | `ui/modal.ex` — add a close-button slot; kills all 27 at once (React twin: Button.tsx `nakedClose`) |
| `table-action` / `icon-button` utility buttons     | 9      | collection_live/components.ex:112,121; run_live/index.html.heex:631; workorder_component.ex:249 …                     | table-action utility (explicitly out of POC scope)                                                  |
| Link-styled buttons                                | ~6     | ai_assistant:770,871; credential_form:989,936; oauth.ex:321; credential_picker:68 (already uses `.link` utility)      | Link/typography pattern                                                                             |
| Input-attached show/copy (rounded-r-lg, w-[100px]) | 3      | webhook_auth_method_form_component.ex:530,575; workflow_live/components.ex:392                                        | Field addon / secret-reveal pattern                                                                 |
| Alert/flash dismiss (colored)                      | 3      | github_sync_modal.ex:104; common.ex:507,552                                                                           | `ui/alert.ex`                                                                                       |
| MFA toggle switches (role="switch")                | 2      | profile mfa_component.html.heex:15; project settings.html.heex:621                                                    | `ui/field.ex` toggle                                                                                |
| Credential environment tab bar                     | 2      | credential_form_component.ex:826,854                                                                                  | Tabs organism (inline-editable tabs, already in inventory)                                          |
| Radio-card selectors                               | 2      | credential_form_component.ex:1080; new_workflow_component.ex:436                                                      | RadioCardGroup                                                                                      |
| Circular icon retry/cancel (rounded-full bordered) | 2      | ai_assistant:1223,1235                                                                                                | icon-button follow-up; distinctive pattern — flag designer                                          |
| Banner internals                                   | 2      | book_demo_banner.ex:117,139                                                                                           | Banner / extension surface                                                                          |
| Sandbox parameterized action button                | 1      | sandbox_live/components.ex:617 (takes @button_class)                                                                  | sandbox action-cluster organism                                                                     |
| Legacy editor (FROZEN)                             | 2      | workflow_live/edit.ex:1074; workflow_live/components.ex:108 (legacy-upgrade nag)                                      | dies with legacy sunset                                                                             |
| Tokens copy pill                                   | 1      | tokens_live/index.html.heex:48                                                                                        | CopyButton (out of POC scope)                                                                       |
| Dev harness                                        | 1      | dev/react_live.ex                                                                                                     | dev-only                                                                                            |

**Consequence for the full plan**: the Phase 5 "67 raw buttons" line item is
~90% NOT Button work. The one-off cleanup phases should be re-cut per OWNING
component, and the modal-close slot alone (one Modal change) retires 27
one-offs.

## Final verification (end of run)

- `mix test` (full, post-everything): **4306 tests, 2 failures** —
  `Lightning.WebAndWorkerTest` (pre-existing; fails identically on main;
  worker-runtime integration) and `Lightning.VersionControlTest` (flaky under
  full-suite parallelism; passes standalone 21/21; GitHub-mock timing, unrelated
  to UI).
- `npx vitest run` (full): 210 failures across 12 files — **all pre-existing**:
  the biggest failing file (ChatInput, 63) fails identically on `main`, and none
  of the failing areas import Button (verified). Known-affected consumer tests
  (NewRunButton/RunRetryButton, 39) pass.
- `npx tsc -p tsconfig.browser.json`: only pre-existing `adaptor-docs` errors
  (untouched).
- Grep gates: `submit_button` 0 · `button_loader` 0 · `def button` only in
  `ui/button.ex` · raw `<button>` in live/\*\* = 61, all dispositioned.

### Switch 7 — POC hardened to the plan's full DoD (review feedback round)

Review feedback (Tyrell): the first pass under-delivered against the plan's own
definition of done. Addressed:

- **(A) File structure**: real `@openfn/ui` npm workspace (`assets/package.json`
  workspaces + `packages/ui/{package.json,tsconfig.json}`), Button moved to
  `packages/ui/src/button/`, 5 collab-editor imports now `from '@openfn/ui'`,
  old `collaborative-editor/components/Button.tsx` deleted.
- **(B) CVA**: `buttonVariants = cva(...)` built FROM the recipe JSON; the
  enabled/disabled swap modeled as a `vstate` dimension + compound variants so
  hover can't leak into disabled (guideline) and classes stay byte-equal to
  HEEx.
- **(C) Full variant surface**: React Button now exposes ALL 7 recipe variants +
  4 sizes (was 3 variants, hardcoded md). Recipe-contract tests fail if either
  side drops a variant.
- **(D) Missing variants**: `iconLeft`/`iconRight` props (React, aria-hidden
  decoration) + `icon`/`icon_right` attrs (HEEx); icon-only mode requires an
  accessible name AT THE TYPE LEVEL; **SplitButton built** (react-aria
  MenuTrigger; consolidation target for SaveButton/RunRetryButton/
  new_credential_menu_button — those 3 call sites migrate in a follow-up batch,
  not force-migrated here).
- **(E) Testing**: `packages/ui/src/button/Button.test.tsx` — recipe-contract,
  behavior (press/keyboard/submit/disabled), icon semantics, axe (vitest-axe)
  incl. open-menu SplitButton. 11 tests. HEEx twin:
  `test/lightning_web/components/ui/button_test.exs` — 7 tests. Coverage 92.3%
  stmts / 100% funcs (uncovered = deprecated nakedClose branch).
- **(F) Storybook**: Storybook 9 (react-vite) at `packages/ui/.storybook` with
  a11y addon at error level; Button + SplitButton stories incl. play()
  interaction tests; `npx storybook build` green.
- **(G) i18n**: no English defaults anywhere (nakedClose's 'Close panel' default
  REMOVED — InspectorLayout now passes the app-level string; SplitButton
  `menuLabel` required).
- **(H) a11y**: react-aria-components as the behavior base (Button press
  semantics, MenuTrigger focus/dismiss); axe tests; decorative icons
  aria-hidden; required accessible names.
- **(I) Docs**: `packages/ui/README.md` — run/test/coverage/change-workflow.

**Judgment calls this round**

1. The app's legacy `tailwind.config.ts` uses `__dirname` (not ESM-safe) so
   Storybook can't load it → the package is now **self-contained**: inline SVG
   icons instead of hero-_ classes inside package components; stories use
   `@heroicons/react`. Right property for a publishable package anyway. The app
   keeps using hero-_ everywhere else.
2. Storybook's vite must not inherit the app's v3-era `.postcssrc` — overridden
   in `viteFinal` (documented in main.ts).
3. `aria-busy` on loading was dropped: react-aria filters it, and busy semantics
   belong with the (Phase-0-gated) spinner treatment.
4. Storybook 10 requires vitest 4 (repo has vitest 3) — pinned Storybook 9.1.20,
   matching the plan.
5. Behavior change to note for review: onClick now runs through react-aria's
   press system (fires on Enter/Space + click, NOT on disabled). Consumer tests
   (39) + new tests (50 incl. 11 new) green.

**Verification**: browser tsc error count identical to main (467 — diffed lists,
zero new); ui package tsc clean; vitest 50/50 across package + consumers;
`mix test` ui/button (7/7) + compile --warnings-as-errors; `mix esbuild default`

- `mix tailwind default` green (workspace resolution + recipe/src @source
  verified); `storybook build` green.

**Residual risk: Low-Medium** — same pixel-check caveat as Switch 1, plus the
nakedClose visual (inline SVG x-mark replaces hero-x-mark span: same 24×24
heroicon path, stroke-width 1.5 — visually identical by construction but
unverified in-browser).

### Switch 8 — phoenix_storybook was broken on main; fixed (found during review)

Opening /storybook 500'd with
`LightningWeb.Storybook.asset_hash/1 is undefined`. Pre-existing (nobody had
opened it in a long time — consistent with the stale story found in the census).
Three stacked bugs, all in configuration:

1. `storybook.ex` declared `otp_app: :lightning_web` — the app is `:lightning`,
   so `:code.priv_dir/1` failed and phoenix_storybook never generated the
   `asset_hash/1` functions at compile time → UndefinedFunctionError.
2. `js_path` pointed at `/assets/storybook.js` but esbuild outputs
   `/assets/js/storybook.js` (outdir preserves the `js/` prefix).
3. Two follow-on issues once it booted: `assets/js/storybook.js` was a stub (app
   hooks like Tooltip unregistered → console error on the disabled-with-tooltip
   story) and `assets/css/storybook.css` had no `@theme` color aliases or
   `@source` directives — so `bg-primary-600` didn't exist in the storybook
   build and the **Primary button rendered invisible** (verified with a browser
   screenshot). Fixed: hooks registered (`js_script_type: "module"` since the
   bundle is ESM), CSS mirrors the primary/secondary aliases and scans
   `components/ui` + recipes + stories.

Verified in-browser: /storybook/common/button renders all 6 themes correctly, no
console errors. Risk: Low (dev-only surface).

### Switch 9 — phoenix_storybook wasn't loading Inter/Fira Code fonts (found during review)

Reviewer flagged: buttons rendered but with the wrong typeface (system sans, not
Inter). Root cause chain, worked through empirically with the browse skill
(screenshots + `getComputedStyle` at each ancestor):

1. `storybook.css`'s `@theme` block set `--font-sans`/`--font-mono` but the
   actual `@font-face` rules for 'Inter var'/'Fira Code VF' live in
   `assets/fonts/inter.css`/`fira-code.css`, linked directly in the real app's
   `root.html.heex` — a layout phoenix_storybook never uses.
2. First fix attempt (`@import '../fonts/inter.css';`, a Tailwind _local-file_
   import) was wrong: Tailwind inlines the file's raw `url('Inter-Thin.woff2')`
   paths, but esbuild's asset pipeline copies+hashes those files elsewhere
   (`Inter-roman.var-WIJJYAE4.woff2` etc.) — the inlined urls 404'd. Fixed by
   using a **runtime** `@import url('/assets/fonts/inter.css')` against the
   already-built, correctly-hashed file instead (same file `root.html.heex`
   links to) — and moving it before `@import 'tailwindcss'`, since `@import`
   must be the first rule(s) in a stylesheet per the CSS spec; Tailwind doesn't
   reorder a runtime url() import that follows it.
3. Even with fonts loading (verified via `network` — 200s on the actual woff2
   files), the button still rendered in the wrong font. Traced the ancestor
   chain with `getComputedStyle` at every level (html → body → sandbox div →
   button) and found phoenix_storybook's own bundled `phoenix_storybook.css`
   (deps/phoenix_storybook/priv/static/css/) declares
   `.psb html.psb { font-family: ui-sans-serif, ... }` (compound-class selector,
   higher specificity than Preflight's plain `html, :host`) AND
   `.psb-sandbox { font-family: serif, ... }` directly — a third-party
   dependency's CSS we don't control silently winning the cascade. Fixed with
   explicit, equally-targeted `!important` overrides on
   `html.psb`/`.psb html.psb`/`body.psb`/`.psb body.psb` and `.psb-sandbox`
   (using the concrete `var(--font-sans)` value, not `inherit` — an `inherit`
   attempt on `.psb-sandbox` still resolved to an intermediate wrapper div that
   phoenix_storybook itself re-declares with its own default stack).

**Verified in-browser** (browse skill): fresh navigation, cleared console — zero
errors; `getComputedStyle` on the actual rendered `<button>` and the
code/`<pre>` panel both resolve to `"Inter var", ui-sans-serif, ...` and
`"Fira Code VF", ui-monospace, ...` respectively; screenshot shows visibly
correct Inter letterforms (compare `docs/poc/` screenshots before/after).

**Judgment call**: `!important` against a vendored dependency's CSS is generally
something to avoid, but phoenix_storybook exposes no head-injection hook or
theme API to fix this cleanly (checked: no `:head_tags`/layout override option
in 0.9.2). Logged as a should-revisit if/when phoenix_storybook adds such a
hook, or when Phase 1's token pipeline makes `storybook.css` generated from the
same source as `app.css` (at which point this whole file, and thus this
override, may simplify or disappear).

**Residual risk: Low** — dev-only surface, cosmetic, now verified end-to-end in
a real browser rather than by test assertion alone.

### Switch 10 — HEEx feature parity: icon-only buttons + SplitButton + a11y/i18n

Reviewer asked: bring the HEEx side to parity with React on icons, split
buttons, a11y, and i18n. Gaps found and closed:

**Icon-only buttons (a11y + i18n parity with React's discriminated union).**
`ui/button.ex`'s `:inner_block` slot was `required: true`, so icon-only buttons
(no visible label) were impossible — a real feature gap, not a styling one.
Changed to optional, with a runtime guard: no `:inner_block` content AND no
`aria-label` in `:rest` raises `ArgumentError` at render time with a corrective
example. This is the closest HEEx equivalent to React's `ButtonIconOnly` type
(`children?: undefined; 'aria-label': string`) — HEEx has no static type
checker, so the guarantee moves from compile-time (TS) to render-time (raise),
same as the recipe⇄attr guard already in this module. A tooltip is explicitly
NOT accepted as a substitute for `aria-label` (matches React; tooltip content
isn't reliably exposed as the accessible name to screen readers). Icon margins
are now conditional on whether a label is present (was always applied, causing
lopsided padding on icon-only buttons) — matches React's `children != null`
check exactly. 7 new tests in `button_test.exs` (recipe-driven variant/size
coverage, icon-only render + raise + tooltip-is-not-enough, icon margin
conditional).

**SplitButton — new `ui/split_button.ex`.** Was entirely missing; is the
consolidation target (per the master inventory) for the collab-editor
SaveButton, RunRetryButton, and HEEx `new_credential_menu_button`. Built from
the codebase's OWN existing conventions rather than new JS:
`Phoenix.LiveView.JS` (`show`/`hide`/`set_attribute`/`focus`/`focus_first`),
`phx-click-away`, `role="menu"` — the same primitives already used by
`LightningWeb.Components.Common.simple_dropdown/1`. Two real bugs found and
fixed while verifying this in a live browser (not by test assertion — see
below):

1. `simple_dropdown/1` (pre-existing, common.ex:648) hardcodes
   `aria-expanded="true"` — never toggles. Logged as a pre-existing bug in
   frozen/adjacent code (out of POC scope to fix); my new component uses
   `JS.set_attribute` on both open AND close so `aria-expanded` is genuinely
   accurate.
2. **Escape-to-close was silently broken across multiple instances on one
   page.** First attempt used `phx-window-keydown` (global — fires for every
   mounted split button regardless of which is open; whichever registered last
   won the focus-restore race, stealing focus into the WRONG instance's
   trigger). Second attempt used plain `phx-keydown` on the menu `<div>` (should
   be instance-scoped) — but LiveView's JS client (`live_socket.js` `bind/2`)
   checks `event.target.getAttribute(binding)` directly with NO
   ancestor/bubbling lookup for the non-window variant, so it silently never
   fired once focus moved onto a `role="menuitem"` button via `JS.focus_first`.
   Fixed by moving the binding onto each menu item button (the element that's
   actually `document.activeElement`). Verified with two split-button instances
   open/closed independently in a real browser via the browse skill: opening one
   doesn't affect the other; Escape closes only the open one and returns focus
   to ITS OWN trigger. A structural regression test now asserts `phx-keydown`
   lives on the item buttons, not the wrapper div (the actual bug can't be
   caught by ExUnit alone — it's client-JS event-target semantics — so the test
   locks down the _shape_ of the fix, and the module doc records the full story
   for the next person who's tempted to "simplify" it back onto the div).

`menu_label` (trigger's accessible name) and `:item` labels are
`attr required: true`/slot content with no defaults — HEEx's compiler enforces
this at every call site, which is arguably a stronger guarantee than React's
type-level requirement (TS can be bypassed with `as any`; a missing required
HEEx attr fails `mix compile`). 8 new tests in `split_button_test.exs` covering
rendering, full a11y wiring
(`aria-haspopup`/`aria-expanded`/`aria-controls`/`role`), item semantics, and
the escape-binding regression guard.

Storybook: added `storybook/common/split_button.story.exs` (primary, per-theme,
disabled variations) — following the correct `%Variation{slots: [...]}` API
discovered by reading an official phx.gen.storybook template example, not the
`<:item>`-in-`template/0` approach I tried first (which phoenix_storybook's
`template/0` mechanism doesn't support the way I initially assumed).

**Verified**: `mix compile --warnings-as-errors` clean; 17/17 new + existing
`ui/` tests; full `mix test` — 5 failures, ALL confirmed pre-existing flakiness
by rerunning standalone (95/95 pass in isolation;
`AiAssistantChannelTest`/`Lightning.SessionTest`/`GithubClientTest` are
timing-sensitive GenServer/channel races unrelated to this work; only
`WebAndWorkerTest` reliably fails, as already documented in Switch 1).
Live-browser verification via the browse skill: icon-only button renders with
correct `aria-label` and no lopsided margin; split button opens, closes on
click-away, closes on Escape with correct focus-return, and two simultaneous
instances don't cross-contaminate — screenshots in this session's tool output,
not committed to the repo (transient verification artifacts, not documentation).

**Residual risk: Low.** The Escape fix is now a structural (not behavioral)
regression test — a future refactor could still silently reintroduce the
`phx-window-keydown` or wrapper-div mistake if the module doc isn't read;
accepted, since fully behavioral testing of client-JS interactions is outside
ExUnit's reach without introducing Wallaby/Playwright, which is out of scope for
this POC.

### Switch 11 — SplitButton's chevron icon wasn't rendering in phoenix_storybook (found by the reviewer, live)

Reviewer navigated to `/storybook/common/split_button` in the connected browser
and spotted the trigger segment's chevron-down icon missing.

**Root cause**: `assets/css/storybook.css` never included
`@config '../tailwind.config.ts'` — the directive that registers the heroicons
Tailwind plugin (turns `hero-*` classes into real CSS, a mask-image data URI per
icon). Without it, `hero-chevron-down` existed in the rendered HTML with zero
matching CSS — invisible, not erroring. Confirmed via build output:
`grep -c hero-chevron-down` was 4 in `priv/static/assets/app.css` and 0 in
`priv/static/assets/storybook.css` before the fix. This had been latent since
Switch 9 (the font fix) — the Button story never exercises an icon variant, so
nothing surfaced it until SplitButton's chevron.

**Fix**: added `@config '../tailwind.config.ts'` to `storybook.css`. Safe here
specifically because this stylesheet builds via the native Tailwind CLI
(`mix tailwind storybook`), the same mechanism as the working `app.css` — the
`__dirname is not defined` failure from Switch 9 was a Vite/ESM-only problem,
and only applies to the _React_ Storybook's
`assets/packages/ui/.storybook/preview.css`, which deliberately omits this line
for that reason (now documented in a comment on both files so nobody "fixes" one
by copying the other's config).

**Verified**: `mix tailwind storybook` rebuild, `hero-chevron-down` now 4 rules
(parity with app.css); reloaded in the live browser via the browse skill —
chevron renders on all 7 variants (primary, 5 themes, disabled), zero console
errors.

**Residual risk: none** — purely additive CSS registration, verified visually
end-to-end.
