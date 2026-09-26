# way-too-good

Three [Claude Code](https://claude.com/claude-code) skills for building software that is seriously good, not just finished.

| Skill | Use it when | What you get |
|---|---|---|
| **`/way-too-good`** | You have an idea (or a product to clone) and want it taken all the way to a working, tested build. | The full pipeline: discover → research → spec → mockup → prove the unknowns → QA tooling → plan → build → hand off. |
| **`/good-idea`** | You want the thinking done properly, and something else (you, another tool, another team) will write the code. | An approved spec and mockup, a traceability map, and every risky unknown proven or given a fallback. Stops before code. |
| **`/good-build`** | You already have a spec or plan and want it implemented completely and correctly. | Every task built test-first, reviewed, merged and checked the way a user would run it. No planning, no drift, no false "done". |

`good-idea` + `good-build` together cover the same ground as `way-too-good`, split at the point where a plan exists.

## Install

In Claude Code:

```
/plugin marketplace add nyfeblade/way-too-good
/plugin install way-too-good@way-too-good
```

Or copy any of the folders in [`skills/`](skills) into `~/.claude/skills/`.

## How they work

All three share a few rules that don't bend with project size:

- **Depth may shrink, proof may not.** Each skill scales its ceremony to the job (Fast / Standard / Full, or Small / Medium / Large), but the invariants stay: unknowns are proven in the real environment before anything is built on them, every behaviour change has a test that was seen failing first, and the finished thing passes QA the way a user runs it.
- **Nothing is done on an agent's word.** Tests, counts and at least one concrete claim are re-checked after every task and every merge.
- **Every stage leaves an artifact on disk** (a decision log, research notes, a spec, plans, a build ledger), so work survives lost context and can be resumed instead of redone.
- **Security-relevant work gets its own review** on the most capable model, probed with hostile inputs, and denylists are replaced with fail-closed designs when bypasses keep turning up.

`way-too-good` also ships `check-gates.sh`, which reports which stage artifacts exist for a project so you can see where a build stands.

The lessons in these skills come from real builds. They are kept general: no project names, no stack assumptions.

## Licence

[MIT](LICENSE)
