# Button consolidation POC — final manifest

Branch `feature/button-poc` off `main@32f10014`. Companion doc:
[button-consolidation.html](./button-consolidation.html) · running log:
[button-risk-log.md](./button-risk-log.md).

## 1. Created

| Path                                                     | What                                                                                                                                                                    |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `assets/packages/ui/recipes/button.json`                 | Shared class recipe (base, 4 sizes, 7 variants incl. new `ghost`) — single styling source for both stacks                                                               |
| `lib/lightning_web/components/ui/button.ex`              | Canonical HEEx button (`button/1`, `button_link/1`, `simple_button_with_tooltip/1`), reads recipe at compile time with `@external_resource` + recipe⇄attr compile guard |
| `assets/packages/ui/docs/poc/button-risk-log.md`         | Running risk log (source of truth for this POC)                                                                                                                         |
| `assets/packages/ui/docs/poc/rendered-classes-after.txt` | Rendered class-string evidence (canonical output)                                                                                                                       |
| `assets/packages/ui/docs/poc/button-consolidation.html`  | Companion document                                                                                                                                                      |
| `assets/packages/ui/docs/poc/button-manifest.md`         | This file                                                                                                                                                               |

## 2. Moved / consolidated

| From → To                                                                                                                                                                 | Call sites                                                                            | Commit     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ---------- |
| `new_inputs.ex:120-308` `button`/`button_link`/`simple_button_with_tooltip` → `ui/button.ex` (verbatim move; classes now recipe-driven)                                   | 163 `<.button>` + 12 `<.button_link>` + 1 `simple_button_with_tooltip`, all unchanged | `950585c1` |
| `assets/js/collaborative-editor/components/Button.tsx` hard-coded classes → recipe import                                                                                 | 11 `<Button>` usages across 5 files, API unchanged                                    | `950585c1` |
| `live_helpers.ex` `<NewInputs.button>` → `<UI.Button.button>` (qualified)                                                                                                 | 1                                                                                     | `950585c1` |
| `lightning_web.ex` — `import LightningWeb.Components.UI.Button` added at all 5 NewInputs import sites; `workflow_live/edit.ex` (frozen) +1 import line (compile-required) | —                                                                                     | `950585c1` |
| `storybook/common/button.story.exs` — stale story (nonexistent `Common.button/1`) → canonical button with theme/size/state variations                                     | —                                                                                     | `950585c1` |
| `form.ex:10 submit_button` → `<.button type="submit" theme="primary">`                                                                                                    | 1 (project settings Save; census "3" = open+close tag+@spec)                          | `fc92ebd5` |
| `backup_codes_live/index.html.heex` raw buttons (Print Codes, Generate new codes) → `<.button theme="secondary" size="lg">`                                               | 2                                                                                     | `b08465fe` |
| `components/user_deletion_modal.ex` raw Cancel → `<.button theme="secondary" size="lg">`                                                                                  | 1                                                                                     | `b08465fe` |
| `ai_assistant/component.ex` sort-toggle + message-copy → `<.button theme="ghost">`                                                                                        | 2                                                                                     | `df8aae47` |

## 3. Removed

| What                                                                                                                                                                                                                           | Where it was                                               | Commit     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- | ---------- |
| `@button_themes`, `@button_sizes`, `button/1` (2 clauses), `button_link/1`, `button_base_classes/0`, `button_size_classes/1`, `button_theme_classes/2`, `simple_button_with_tooltip/1`, `tooltip_when_disabled/1` (−297 lines) | `lib/lightning_web/components/new_inputs.ex:13-308`        | `950585c1` |
| `submit_button/1` (+ attrs/spec)                                                                                                                                                                                               | `lib/lightning_web/live/components/form.ex:5-41`           | `fc92ebd5` |
| unused `import LightningWeb.Components.Form`                                                                                                                                                                                   | `lib/lightning_web/live/project_live/form_component.ex:16` | `fc92ebd5` |
| `button_loader/1` (dead — 0 references)                                                                                                                                                                                        | `lib/lightning_web/components/loaders.ex:29-52`            | `bb130b8a` |
| Hard-coded variant class strings                                                                                                                                                                                               | `assets/js/collaborative-editor/components/Button.tsx`     | `950585c1` |

## 3b. Added in the hardening round (review feedback)

| Path                                                             | What                                                                                                                                               |
| ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `assets/package.json`                                            | npm workspaces (`packages/*`)                                                                                                                      |
| `assets/packages/ui/{package.json,tsconfig.json}`                | `@openfn/ui` workspace package (CVA + react-aria-components deps)                                                                                  |
| `assets/packages/ui/src/button/Button.tsx`                       | Canonical React Button: CVA over the recipe, ALL 7 variants + 4 sizes, iconLeft/iconRight, react-aria base, type-required aria-label for icon-only |
| `assets/packages/ui/src/button/SplitButton.tsx`                  | SplitButton (react-aria MenuTrigger) — consolidation target for the 3 bespoke split buttons                                                        |
| `assets/packages/ui/src/button/Button.test.tsx`                  | 11 tests: recipe contract, behavior, icons, axe (vitest-axe)                                                                                       |
| `assets/packages/ui/src/button/{Button,SplitButton}.stories.tsx` | Storybook stories w/ play() interaction tests                                                                                                      |
| `assets/packages/ui/.storybook/`                                 | Storybook 9 react-vite config, a11y addon at error level                                                                                           |
| `assets/packages/ui/README.md`                                   | Run/test/coverage/change-workflow docs                                                                                                             |
| `test/lightning_web/components/ui/button_test.exs`               | HEEx twin component tests (7)                                                                                                                      |
| `lib/lightning_web/components/ui/button.ex`                      | + `icon`/`icon_right` attrs                                                                                                                        |
| DELETED: `assets/js/collaborative-editor/components/Button.tsx`  | replaced by `@openfn/ui` import at all 5 consumers                                                                                                 |

## 3c. Feature parity round (icons, split button, a11y, i18n)

| Path                                                     | What                                                                                                                                                                |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lib/lightning_web/components/ui/button.ex`              | `:inner_block` slot relaxed to optional; runtime accessible-name guard (raises without `aria-label` when icon-only); icon margins now conditional on label presence |
| `lib/lightning_web/components/ui/split_button.ex`        | NEW — HEEx twin of `SplitButton.tsx`, built on `Phoenix.LiveView.JS` + existing `phx-click-away`/`role="menu"` conventions                                          |
| `test/lightning_web/components/ui/button_test.exs`       | +7 tests: icon-only render/raise/tooltip-insufficient, icon margin conditional                                                                                      |
| `test/lightning_web/components/ui/split_button_test.exs` | NEW — 8 tests incl. a structural regression guard for the escape-binding fix                                                                                        |
| `storybook/common/split_button.story.exs`                | NEW — primary/themes/disabled variations                                                                                                                            |

## 3d. Bug fixes found during live-browser review (Switches 8, 9, 11, 12)

Not POC-scope changes, but real bugs surfaced by actually loading the components
in a browser rather than trusting class-string tests — logged here because they
touch files this POC also modified.

| Path                                        | What                                                                                                                                                                               | Switch |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `lib/lightning_web/storybook.ex`            | `otp_app: :lightning_web` → `:lightning`; `js_path`/`js_script_type` corrected — phoenix_storybook 500'd on `main`                                                                 | 8      |
| `assets/css/storybook.css`                  | Runtime `@import url(...)` for Inter/Fira Code fonts (esbuild-hashed paths) + `!important` overrides for phoenix_storybook's higher-specificity font rules                         | 9      |
| `assets/css/storybook.css`                  | Added `@config '../tailwind.config.ts'` — heroicons plugin was never registered for this stylesheet, so `hero-*` classes rendered with zero matching CSS (invisible, not erroring) | 11     |
| `lib/lightning_web/components/ui/button.ex` | Icon spans: `inline-block align-middle` → `self-center` — `vertical-align` is a no-op on flex items, so icon-only buttons rendered 2px off vertical-center vs React                | 12     |

## 4. Deferred / skipped (with owners)

`cancel_button` (`live/components/credentials.ex:71`, 12 usages): **kept** —
inventory misclassified it; it already delegates to
`<.button theme="secondary">` (composition, not duplicate). React `nakedClose`
variant: kept React-local (1 usage; fold into a future close/icon treatment). No
`loading` state built (button_loader was dead; Figma loading state is a Phase 0
gate).

Remaining **61** raw `<button>`s deferred BY OWNING COMPONENT (full reasoning in
the risk log, Switch 6): modal-close X ×27 → `ui/modal.ex` close slot;
table-action/icon-button ×9 → out-of-scope utility; link-styled ×~6 → link
pattern; input-attached show/copy ×3 → secret-reveal/Field; alert dismiss ×3 →
`ui/alert.ex`; MFA switches ×2 → toggle; credential env tab bar ×2 → Tabs
organism; radio-cards ×2 → RadioCardGroup; circular retry/cancel ×2 →
icon-button follow-up; banner internals ×2 → Banner; sandbox action ×1 → sandbox
organism; legacy/frozen ×2; tokens copy pill ×1 → CopyButton; dev harness ×1.

## 5. Verification greps (run these; expected results as of `908c6be9`)

```bash
# eliminated implementations — expect 0 hits each
grep -rn 'submit_button' lib
grep -rn 'button_loader' lib assets storybook
grep -rn 'NewInputs\.button' lib
grep -rn 'def button' lib/lightning_web/components/new_inputs.ex

# canonical is the only definition — expect only ui/button.ex
grep -rn 'def button\b' lib

# raw <button> count in live/**: was 67, now 61, all dispositioned (Switch 6 table)
grep -rc '<button' lib/lightning_web/live --include='*.ex' --include='*.heex' | awk -F: '{s+=$2} END {print s}'

# CI gate candidates (ban regressions)
test "$(grep -rn '<button' lib/lightning_web/live --include='*.ex' --include='*.heex' | wc -l)" -le 61
grep -rn 'inset-ring inset-ring-gray-300' assets/js && exit 1 || true   # React secondary drift
```
