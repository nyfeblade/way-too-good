# way-too-good

Three agent skills for building software that is seriously good, not just finished. They use the open [Agent Skills](https://agentskills.io) format (a folder with a `SKILL.md`), so they work in any tool that loads skills, and they don't depend on any other skill or plugin.

| Skill | Use it when | What you get |
|---|---|---|
| **`/way-too-good`** | You have an idea (or a product to clone) and want it taken all the way to a working, tested build. | The full pipeline: discover → research → spec → mockup → prove the unknowns → QA tooling → plan → build → hand off. |
| **`/good-idea`** | You want the thinking done properly, and something else (you, another tool, another team) will write the code. | An approved spec and mockup, a traceability map, and every risky unknown proven or given a fallback. Stops before code. |
| **`/good-build`** | You already have a spec or plan and want it implemented completely and correctly. | Every task built test-first, reviewed, merged and checked the way a user would run it. No planning, no drift, no false "done". |

`good-idea` + `good-build` together cover the same ground as `way-too-good`, split at the point where a plan exists.

## Install

**Any tool that supports skills:** copy the folders in [`skills/`](skills) into that tool's skills folder. Each folder is self-contained.

**Claude Code** (as a plugin, all three at once):

```
/plugin marketplace add nyfeblade/way-too-good
/plugin install way-too-good@way-too-good
```

or copy the folders into `~/.claude/skills/` (for you) or `.claude/skills/` (for one project).

(The marketplace commands need the repo to be public. While it's private, copy the folders instead.)

**Claude apps (claude.ai / desktop):** zip one skill's folder and upload it under Settings → Capabilities → Skills.

The skills name features some tools have and others don't (helper agents, parallel workspaces, choosing a model). Where a tool lacks one, the skill says what to do instead.

## How they work

All three share a few rules that don't bend with project size:

- **Depth may shrink, proof may not.** Each skill scales its ceremony to the job (Fast / Standard / Full, or Small / Medium / Large), but the invariants stay: unknowns are proven in the real environment before anything is built on them, every behaviour change has a test that was seen failing first, and the finished thing passes QA the way a user runs it.
- **Nothing is done on an agent's word.** Tests, counts and at least one concrete claim are re-checked after every task and every merge.
- **Every stage leaves an artifact on disk** (a decision log, research notes, a spec, plans, a build ledger), so work survives lost context and can be resumed instead of redone.
- **Security-relevant work gets its own review** on the most capable model, probed with hostile inputs, and denylists are replaced with fail-closed designs when bypasses keep turning up.

`way-too-good` also ships `check-gates.sh`, which reports which stage artifacts exist for a project so you can see where a build stands.

The lessons in these skills come from real builds. They are kept general: no project names, no stack assumptions.

## Versions

These skills are a working procedure, so a version bump is a release. The version lives in [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) and every change is in [CHANGELOG.md](CHANGELOG.md):

- **Major**: an invariant or a stage gate changes (what must be proven, when, or by whom).
- **Minor**: a new stage option, section or lesson.
- **Patch**: wording and fixes that don't change what the skills require.

## Licence

[MIT](LICENSE)
