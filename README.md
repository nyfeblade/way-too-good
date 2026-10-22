# way-too-good

Three agent skills for building software that is seriously good, not just finished. They use the open [Agent Skills](https://agentskills.io) format (a folder with a `SKILL.md`), so the same file works in any harness that loads skills. They don't depend on any other skill or plugin.

Why they exist: agent-built software usually fails in the same few ways. The agent says "done" when it isn't, risky assumptions are never tested in the real environment, and safety checks become ever-growing blocklists that something slips past. These skills turn those failures into steps that can't be skipped.

| Skill | Use it when | What you get |
|---|---|---|
| [**`/way-too-good`**](skills/way-too-good/SKILL.md) | You have an idea (or a product to clone) and want it taken all the way to a working, tested build. | The full pipeline: discover → research → spec → mockup → prove the unknowns → QA tooling → plan → build → hand off. |
| [**`/good-idea`**](skills/good-idea/SKILL.md) | You want the thinking done properly, and something else (you, another tool, another team) will write the code. | An approved spec and mockup, a traceability map, and every risky unknown proven or given a fallback. Stops before code. |
| [**`/good-build`**](skills/good-build/SKILL.md) | You already have a spec or plan and want it implemented completely and correctly. | Every task built test-first, reviewed, merged and checked the way a user would run it. No planning, no drift, no false "done". |

[`good-idea`](skills/good-idea/SKILL.md) + [`good-build`](skills/good-build/SKILL.md) together cover the same ground as [`way-too-good`](skills/way-too-good/SKILL.md), split at the point where a plan exists. good-idea ends by writing a **Handoff** section in the decision log that names every file by path (decisions, spec, traceability map, Phase 0 findings, mockup, plan), and good-build starts from it, so the two can run in different tools or sessions.

## Install

The folders in [`skills/`](skills) are the only copy of each procedure. [`install.sh`](install.sh) copies those folders into the directory the harness actually loads. It does not use sudo, it does not delete files, and running it again is safe: an unchanged skill is left as it is, and a note you added beside `SKILL.md` stays. Re-running does replace `SKILL.md` and `check-gates.sh` with this repo's versions.

```bash
./install.sh                  # personal skills, for harnesses detected on this machine
./install.sh --all            # personal skills, every harness in the table
./install.sh --scope project  # this repository, for harnesses detected here or on this machine
./install.sh --provider cursor
./install.sh --provider claude,windsurf --scope project
./install.sh --list           # paths, no writes
./install.sh --dry-run
```

If nothing is detected, it installs the universal `~/.agents/skills/<name>/` layout and says so. `--dest` changes where files are written (your home for `--scope user`, the repo for `--scope project`). Detection still looks at your real home directory, your `PATH`, and, for a project install, marker directories already in that repo.

On Windows, or anywhere without bash: `python3 scripts/wtg_skills.py install` with the same flags.

A harness that scans more than one of these directories can list a skill twice. The copies are the same file. Prefer one row of the table when that harness's notes say it also reads another tree.

### Claude Code plugin

Claude Code can also load this repo as a plugin. Run these one at a time:

1. Add the marketplace:

   ```
   /plugin marketplace add nyfeblade/way-too-good
   ```

2. Then install the plugin:

   ```
   /plugin install way-too-good@way-too-good
   ```

`./install.sh --provider claude` is the other way: it copies the three folders into `~/.claude/skills/` or, with `--scope project`, into `.claude/skills/`.

### Claude apps (claude.ai / desktop)

Zip one skill's folder and upload it under Settings → Capabilities → Skills. There is no API for that upload.

### Pointer files

Skills are the procedure. `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, Copilot's instruction file, and Cursor rules are only pointers, rendered from each skill's name and description. They are not a second copy of the procedure.

```bash
./install.sh --with-instructions --scope project
```

That writes a missing pointer and leaves an existing `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, or `.cursor/rules/*.mdc` alone. The rendered files in [`generated/`](generated) are the same text. Do not edit them by hand; `python3 scripts/wtg_skills.py update` rewrites them.

### Compatibility

Personal paths are under your home directory. Project paths are under the repository. `<name>` is `way-too-good`, `good-idea`, or `good-build`.

<!-- compatibility:start -->
| Harness | Personal | Project | Notes |
| --- | --- | --- | --- |
| [Universal (.agents)](https://agentskills.io/specification) | `~/.agents/skills/<name>/` | `.agents/skills/<name>/` | Shared tree. Also read by Codex, Goose, OpenCode, Junie, Roo Code, Factory Droid, Cursor, Gemini CLI, Copilot, and Grok. |
| [Claude Code](https://code.claude.com/docs/en/skills) | `~/.claude/skills/<name>/` | `.claude/skills/<name>/` | Personal skills do not load in Cowork or Claude Code cloud sessions. A plugin install is also supported. |
| [OpenAI Codex](https://learn.chatgpt.com/docs/customization/overview) | `~/.agents/skills/<name>/` | `.agents/skills/<name>/` | Current personal directory. Codex still reads legacy ~/.codex/skills; this installer does not write it. |
| [Cursor](https://cursor.com/docs/skills) | `~/.cursor/skills/<name>/` | `.cursor/skills/<name>/` | Also loads .agents, .claude, and .codex skill trees. Cloud Agents need a skill committed in the repo. |
| [Gemini CLI](https://geminicli.com/docs/cli/skills/) | `~/.gemini/skills/<name>/` | `.gemini/skills/<name>/` | In one scope, .agents/skills wins over .gemini/skills. GEMINI.md is always-on context, not the skill. |
| [GitHub Copilot](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-skills) | `~/.copilot/skills/<name>/` | `.github/skills/<name>/` | Also reads .agents/skills and .claude/skills. Copilot Chat on github.com does not load skills. |
| [Windsurf / Devin Desktop](https://docs.windsurf.com/windsurf/cascade/skills) | `~/.config/devin/skills/<name>/` and `~/.codeium/windsurf/skills/<name>/` | `.devin/skills/<name>/` and `.windsurf/skills/<name>/` | Devin Desktop prefers .devin/skills and ~/.config/devin/skills. Legacy Windsurf paths are still read, and both are written. |
| [Grok](https://docs.x.ai/build/features/skills-plugins-marketplaces) | `~/.grok/skills/<name>/` | `.grok/skills/<name>/` | Grok Build reads this tree, plus .agents, .claude, and .cursor. Grok Bot's in-chat library is separate. |
| [Google Antigravity](https://antigravity.google/docs/skills/) | `~/.gemini/config/skills/<name>/` and `~/.gemini/antigravity-cli/skills/<name>/` | `.agents/skills/<name>/` | App and IDE use the config directory. The CLI uses antigravity-cli. Legacy ~/.gemini/antigravity/skills is not written. |
| [Cline](https://docs.cline.bot/customization/skills) | `~/.cline/skills/<name>/` | `.cline/skills/<name>/` | Also reads .claude/skills. Enable Skills in settings. A personal skill overrides a project skill of the same name. |
| [Continue](https://github.com/continuedev/continue/pull/9353) | `~/.continue/skills/<name>/` | `.continue/skills/<name>/` | Also reads .claude/skills. The Continue CLI imports personal skills to ~/.continue/skills. |
| [Factory Droid](https://docs.factory.ai/harness/skills) | `~/.factory/skills/<name>/` | `.factory/skills/<name>/` | Also reads .agents/skills and .agent/skills. |
| [Goose](https://github.com/aaif-goose/goose/blob/main/documentation/docs/guides/context-engineering/using-skills.md) | `~/.agents/skills/<name>/` | `.agents/skills/<name>/` | Same directory as the universal install. Legacy ~/.config/goose/skills is not written. |
| [Junie](https://junie.jetbrains.com/docs/agent-skills.html) | `~/.junie/skills/<name>/` | `.junie/skills/<name>/` | Also reads .agents/skills. A project skill wins over a personal skill of the same name. |
| [Kiro](https://kiro.dev/docs/skills/) | `~/.kiro/skills/<name>/` | `.kiro/skills/<name>/` | Custom agents load skills only when their resources list includes them. Web and mobile do not load personal skills. |
| [OpenCode](https://opencode.ai/docs/skills/) | `~/.config/opencode/skills/<name>/` | `.opencode/skills/<name>/` | Also reads .agents/skills and .claude/skills. |
| [Qwen Code](https://qwenlm.github.io/qwen-code-docs/en/users/features/skills/) | `~/.qwen/skills/<name>/` | `.qwen/skills/<name>/` | Personal and project skill directories, plus skills bundled by a Qwen extension. This installer uses the directories. |
| [Roo Code](https://docs.roocode.com/advanced-usage/available-tools/skill) | `~/.roo/skills/<name>/` | `.roo/skills/<name>/` | Also reads .agents/skills. A project skill overrides a personal skill of the same name. |
<!-- compatibility:end -->

Paths were taken from each harness's own docs (linked in the table), checked against the Agent Skills spec. A few notes that don't fit in a cell:

- **Codex** documents `~/.agents/skills` as the current personal directory. `~/.codex/skills` still works and is not what this installer writes. Global Codex instructions stay in `~/.codex/AGENTS.md`, which is only touched with `--with-instructions` when that file is absent.
- **Cursor** also loads `.agents/skills`, `.claude/skills`, `.codex/skills`, and the same directories under your home. Skills in `~/.agents/skills` are not copied to Cloud Agents. Commit a project skill for those.
- **Gemini CLI** treats `.agents/skills` as an alias that wins over `.gemini/skills` in the same scope. Some consumer Gemini CLI accounts moved to Antigravity CLI in 2026; install the one you actually run.
- **Antigravity** has two personal directories (App and IDE, and the CLI). `--provider antigravity` writes both. The legacy `~/.gemini/antigravity/skills` directory is still read by the IDE and is not written.
- **GitHub Copilot** loads skills in the cloud agent, the Copilot CLI, VS Code agent mode, code review, and the Copilot app. Copilot Chat on github.com uses `.github/copilot-instructions.md` and does not load skills; the pointer file is for that surface.
- **Cline** also reads `.claude/skills` and `.clinerules/skills`. Turn Skills on. A personal skill overrides a project skill of the same name.
- **Continue** loads `.continue/skills` and `.claude/skills`. The personal path is the one the Continue CLI's import command writes (`~/.continue/skills`). The table links the vendor change that added this, because that is the source that states the paths.
- **Goose**'s current docs name `.agents/skills` and `~/.agents/skills`. Older `~/.config/goose/skills` and `.goose/skills` directories still load and are not written.
- **Kiro** custom agents do not load skills unless their `resources` include a `skill://` entry. Kiro Web and mobile do not load personal skills.
- **Grok Build** reads `~/.grok/skills` and `.grok/skills`, and also `.agents`, `.claude`, and `.cursor`. Grok Bot's in-chat skill library is saved from the product, not by copying a folder.
- **Roo Code** also searches `.agents/skills`. A project skill overrides a personal one.
- **Junie** also reads `.agents/skills`. A project skill wins over a personal one of the same name.
- **Windsurf / Devin Desktop** prefers `.devin/skills` and `~/.config/devin/skills`. The Windsurf paths `.windsurf/skills` and `~/.codeium/windsurf/skills` are still read. `--provider windsurf` writes both pairs, because the current docs list both. A root `AGENTS.md` is always on.
- **OpenCode** also reads `.agents/skills` and `.claude/skills`, walking up to the git root.

### What this does not install

- **Classic Aider** has no skill directory in its docs. Pass the `SKILL.md` with `--read`. Forks that grow a skill folder are a different product.
- **Amp, Kilo Code, Warp, Zed, Devin, and Amazon Q** are not given a private path here. Where one of them documents `.agents/skills`, the universal install is the one to use. This repo does not claim a path that was only listed by a third-party catalog.
- **claude.ai upload** stays a manual zip, as above.
- There is no uninstall command. Remove the skill folder yourself if you want it gone. The installer will not delete it for you.

### Check

`python3 scripts/wtg_skills.py check` (or [`scripts/check.sh`](scripts/check.sh)) validates every skill's frontmatter, checks the procedures still name their fallbacks, and fails if [`generated/`](generated) or the table above disagrees with [`scripts/providers.json`](scripts/providers.json). GitHub Actions runs the same command.

## How they work

All three share a few rules that don't bend with project size:

- **Depth may shrink, proof may not.** Each skill scales its ceremony to the job (Fast / Standard / Full, or Small / Medium / Large), but the invariants stay: unknowns are proven in the real environment before anything is built on them, every behaviour change has a test that was seen failing first, and the finished thing passes QA the way a user runs it.
- **Nothing is done on an agent's word.** Tests, counts and at least one concrete claim are re-checked after every task and every merge.
- **Right-sized by default.** When unsure, the skills pick the middle size (Standard for way-too-good and good-idea, Medium for good-build) and move up only when a gate fails; the heaviest depth, Full, needs your explicit OK.
- **Every stage leaves an artifact on disk** (a decision log, research notes, a spec, plans, a build ledger), so work survives lost context and can be resumed instead of redone.
- **Security-relevant work gets its own review** on the most capable model available, probed with hostile inputs, and denylists are replaced with fail-closed designs when bypasses keep turning up. A harness that cannot switch models still does that review, in a fresh context.
- **A missing harness feature does not skip the step.** Each skill's Harness capabilities section says what to do instead of a task list, a helper agent, parallel workspaces, a model picker, web access, a design canvas, or a completion signal.

[`way-too-good`](skills/way-too-good/SKILL.md) also ships [`check-gates.sh`](skills/way-too-good/check-gates.sh), which reports which stage artifacts exist for a project so you can see where a build stands:

```
./skills/way-too-good/check-gates.sh <project-folder> <topic>
```

Its paths are defaults; set `WTG_SPEC`, `WTG_PLANS` and the others (listed at the top of the script) to match your project. It needs bash.

The lessons in these skills come from real builds. They are kept general: no project names, no stack assumptions, no vendor tool names.

## Versions

These skills are a working procedure, so a version bump is a release. The version lives in [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) and every change is in [CHANGELOG.md](CHANGELOG.md):

- **Major**: an invariant or a stage gate changes (what must be proven, when, or by whom).
- **Minor**: a new stage option, section or lesson.
- **Patch**: wording and fixes that don't change what the skills require.

## Licence

[MIT](LICENSE)
