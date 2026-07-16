# Button consolidation POC — final manifest

Branch `feature/button-poc` off `main@32f10014`. Companion doc:
[button-consolidation.html](./button-consolidation.html) · running log:
[button-risk-log.md](./button-risk-log.md).

## 1. Created

| Path                                        | What                                                                                                                                                                    |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `assets/packages/ui/recipes/button.json`    | Shared class recipe (base, 4 sizes, 7 variants incl. new `ghost`) — single styling source for both stacks                                                               |
| `lib/lightning_web/components/ui/button.ex` | Canonical HEEx button (`button/1`, `button_link/1`, `simple_button_with_tooltip/1`), reads recipe at compile time with `@external_resource` + recipe⇄attr compile guard |
| `docs/poc/button-risk-log.md`               | Running risk log (source of truth for this POC)                                                                                                                         |
| `docs/poc/rendered-classes-after.txt`       | Rendered class-string evidence (canonical output)                                                                                                                       |
| `docs/poc/button-consolidation.html`        | Companion document                                                                                                                                                      |
| `docs/poc/button-manifest.md`               | This file                                                                                                                                                               |

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
