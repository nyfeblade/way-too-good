---
name: way-too-good
description: Use when the user invokes /way-too-good, wants help deciding what to build, or wants an app or a faithful clone of an existing product researched, specced, mocked up, proven, planned and built end to end, especially when uncertainty, unknown internals, or cost of rework is high.
---

# Way Too Good

## Overview
An operating procedure for building something seriously good with agents. **Stage count is fixed; stage depth is adaptive.** Every stage leaves an artifact on disk, runs in order, and passes its gate at the chosen depth before the next begins.

**Depth may shrink. Verification may not.** Three invariants hold at every depth:
1. Every real unknown is proven in the target environment before anything is built on it (Stage 9).
2. Every task shows a failing test (RED output recorded) before the passing one (GREEN).
3. The finished product passes QA before handoff.

Violating the letter of the pipeline is violating its spirit.

## Conventions (map these to your project)
The skill names artifacts by role, not by path. At the start, pick concrete locations and record them in the decision log:

| Role | What it holds | Example location |
|---|---|---|
| **Decision log** | goal, scale, constraints, every decision (date · decision · why · who) | `docs/decisions.md` |
| **Research folder** | numbered research notes and any source archive | `research/<topic>/` |
| **Spec** | the numbered requirements: the authority every later stage argues from | `docs/spec/` |
| **Traceability map** | UI ↔ requirement ↔ phase | alongside the spec |
| **Plans** | one plan per phase | `docs/plans/` |
| **Build ledger** | per-plan progress, rulings, review results (the recovery map) | a git-ignored working folder |
| **Gate check** | a script or checklist that confirms each stage's artifact exists | this skill's `check-gates.sh`, or your repo's equivalent |

Use your toolchain's equivalents for planning, TDD and agent orchestration: skills, subagents, worktrees and workflow runners where available, or plain sessions and branches where not.

## Stage 1: declare the scale
Assess the project and **recommend** a scale with one sentence of reasoning. The user has the final say. Record it in the decision log.

| Scale | Signals |
|---|---|
| **Fast** | small, familiar platform, low risk, about a day |
| **Standard** | a meaningful product, moderate uncertainty, known platform |
| **Full** | ambitious or novel, reverse-engineering or cloning, unknown platform behavior, high cost of rework |

> e.g. "This looks like **Full**: it reproduces an existing product and depends on unverified platform behavior. **Standard** works if behavioral fidelity doesn't matter."

Move up a scale if uncertainty appears midway. Never move down past a gate that has already failed.

## The pipeline

| # | Stage | Artifact | Fast | Standard | Full |
|---|---|---|---|---|---|
| 0 | **Discover** | the idea, in the decision log | 1 question + the idea | goal questions (one at a time, plain chat) + an R&D sprint | + parallel research agents + stress-test the lead idea; stop agents on a pivot |
| 1 | **Frame + scale** | decision log | goal, done, scale | + constraints, out of scope for v1 | + platform, budget/plan limits, public vs personal |
| 2 | **Research** | research folder | targeted notes | 4 tracks (features/logic, UI, reception and competitors, platform/SDK), claims sourced | + you verify ≥3 key claims yourself |
| 3 | **Internals** | research folder | only the relevant unknowns | detailed behavior | exhaustive rundown + an indexed archive of the source documents; behavior only, never leaked or reconstructed code |
| 4 | **Ground truth** | research folder | the evidence supplied | screenshot teardown | comprehensive teardown; text/accessibility reads first; ask for ONE specific screenshot, never bulk capture |
| 5 | **Spec** | spec | concise requirements | numbered requirements with sources and mechanisms, labeled IDENTICAL / ADAPTED / DECISION NEEDED | + data model, limits, build order; the user settles every decision |
| 6 | **Gap engineering** | spec § Original designs | decide inline | ORIGINAL designs for real unknowns | every unknown → a design with constants, real prompts, evals; the user's principles enforced in code |
| 7 | **Mockup** | a design canvas | the key screen | baseline → user notes → multi-screen | complete interaction set, faithful to the reference when cloning; the user approves explicitly |
| 8 | **Traceability** | traceability map | critical paths | all UI ↔ requirement ↔ phase | bidirectional and exhaustive; 0 MISSING |
| 9 | **Phase 0** ★ | findings doc | real unknowns proven | real unknowns proven | real unknowns proven; each PASSes or has a fallback |
| 10 | **QA tooling** ★ | a QA harness | a QA checklist + crawler | a project fuzz tool (crawler + journeys) | + self-tested against planted bugs, before any app code |
| 11 | **Plan** | plans | short task list | a written implementation plan | + one plan per phase, written in chunks; grep-verify |
| 12 | **Build** ★ | commits + build ledger | RED → GREEN | one fresh agent per task + per-task review + TDD | + pre-flight conflict scan, rulings in the ledger, fuzz gate (critical/high = 0) |
| 13 | **Hand off + learn** | the draft + a skill edit | what works, what's stubbed | + every ruling made | + update THIS skill with general lessons |

★ = an invariant stage: its gate is the same at every scale.

## Start
1. Create one todo per stage (0–13), with the stage titles verbatim.
2. Before closing a stage, run the gate check and read its result against the declared scale.
3. **Decisions vs. memory:** project decisions go in the decision log, because the project's files are its source of truth. Assistant memory holds only cross-project, lasting preferences ("prefers monochrome UI," budget, how they like to be asked). Never project state.

## Red flags: stop and go back
- Skipping a stage instead of running it at a lighter depth
- "It's small, so skip Phase 0 / the tests / QA" (invariants never shrink)
- Full depth on a small tool: the process becomes the project
- "Summaries are enough" at Full depth
- "The agent said it's done" without checking sizes, counts, TODOs, or one claim

## Common mistakes
**Process**
- **Fix the class, then ship the guard that would have caught it.** One selector defined twice, one unsafe lookup, one silent write failure — each is a family. Find its siblings, fix them together, and leave a test that fails on the next one. A guard with exceptions is a guard the next instance hides behind — but the cure is not "never exempt anything". A **skip list** (names the rule ignores) rots; a **declaration list** does not: each entry carries a reason saying what makes this case correct, the test measures that reason where it can, and a stale-entry check fails when an entry stops being needed. Adding to it is then a visible claim a reviewer can refuse, not a way out. And a guard that fires on correct code earns a skip list within a week, so pin the correct cases it nearly flagged as must-NOT-fire assertions
- **Make the safe behaviour the one you get by forgetting.** A failure that must be handled at each call site will be missed at some of them; a failure reported by default, with silence requiring an explicit opt-out a reader can see, cannot rot
- **Keep the app and its backend in step.** Shipping a rebuilt front end against a stale service wastes the user's testing time on bugs that were already fixed, and every report from that session has to be re-examined afterwards
- Trusting agent reports unverified: re-run the suite and the count yourself after every merge
- **A workaround pinned in the user's settings is not a fix, and it hides siblings.** Pinning one engine's paths made it work on one machine while the same wrong-root lookup silently disabled two other engines that had no pin. Remove the pin, fix the lookup, and check every caller of the same assumption
- History rewrites or purges without a backup: copy affected files outside the repo first, never rewrite the checked-out branch blind, and never garbage-collect in the same step
- Name clashes with the platform's built-in tools (Phase 0 catches them)
- Prompt-only rules for costly behavior: enforce them in code
- Bulk capture or polling that burns tokens: text over images, notifications over polling
- Publishing copied research or look-alike assets: research stays private; IP review before any release
- **"Remove X" can mean "for everyone" or "for other people".** When the owner and the public need different builds (e.g. a sign-in method the owner may use personally but may not ship), confirm which build a removal applies to before building. Keep the variants as separate branches, and add a guard test to the stripped one that fails if the removed path comes back
- **Go public from a cleaned tree with fresh history**, never by flipping the private repo's visibility. First audit for secrets, personal data (names, emails, home paths, real-looking test fixtures), internal security notes and any copied third-party material, then show the owner the final file list and README
- **Visual choices (icons, launch animations) get a playable side-by-side page**, in light and dark and at real sizes, not a description. To compare against another tool's designs, give it the brief and constraints only, never your concepts, or you get copies instead of an independent option

**Orchestrating agents**
- Serial task loops are slow: once the plan's dependency graph shows independent tracks, run them in parallel (an isolated workspace per track, a review per track, one merge step), keeping the dependent tail sequential
- A reviewer marking findings "not all addressed" won't stop an automated pipeline from advancing: read every re-review result, and send a load-bearing open finding to a dedicated root-cause agent
- Agents can hang silently. On every check-in, look at how long each running agent has gone without output; past a threshold (e.g. 30 minutes), stop it and restart only the unfinished tasks
- Resuming a parallel run from a cache replays only the unchanged prefix of calls, and parallel tracks interleave differently each run. Restart unfinished work as a new, scoped run instead of resuming the whole thing
- Never judge an agent's result by searching its free text for words like "FAILED": ask for structured output
- An agent can mistake a user message relayed mid-launch for its task: tell every agent explicitly that its prompt is its task, and verify each branch's commits afterwards
- Git's **stash stack is shared across worktrees**, so parallel agents can pop each other's work in progress. Tell them never to stash; commit to their own branch instead
- Two agents in **one checkout share one git index**, so `git add -A` by either one silently commits the other's staged work into the wrong branch. Disjoint file lists do not protect them. Give every concurrent agent its own worktree, or sequence them; if a shared tree is unavoidable, require explicit pathspecs on every add and commit. A suite run in a shared tree also measures both agents' work, so it gates neither branch
- **A tracking row's status is itself data that goes stale.** A row reading "fixing, branch X" long after X merged hides both a finished fix and, often, an unfinished one — the check that catches it ("did that branch land, and did it land everything?") costs one command and twice found work left outside a consolidation. Audit the log against the repo, not only the repo against the log
- **A consolidation is not done while call sites remain outside it**, and nothing fails when they are left out — that is what makes it a silent class. After replacing N hand-rolled copies with a primitive, count what still bypasses it and ship the guard that refuses the next one, or the primitive becomes merely the most popular of several designs
- Parallel worktrees each carry their own dependency tree, so **the machine's own indexing and scanning become the bottleneck** long before the agents do. Remove a worktree once its branch is merged, and check what is actually consuming the machine before blaming the work
- When an audit finds many defects, **converting them into fixes has to keep pace with finding them**, or the log becomes a monument. Spend some ticks fixing rather than discovering
- A second audit can **refute the first**, and the better-sourced one wins. When the product is a clone, check the specification before "fixing" an inconsistency: reproducing the original's own inconsistency is the clone working correctly, and an audit that tidies it is the defect

**Testing**
- Mocked tests can't catch failures that only happen in the real runtime (e.g. a schema the real SDK can't serialize, so every tool on that server silently vanishes). Add one test through the real path, and bisect live failures in the target environment with a minimal repro
- **Assert the property, not a proxy for it.** A smoke check that asserts "the process is still alive" passes most reliably when the process has deadlocked — the exact failure it was meant to catch. Before trusting a check, ask which failures make it pass
- **WHEN a check runs is part of the check.** An assertion on the last line of a long journey is skipped by exactly the failures it exists to catch: the app fails quietly at step 12, the journey dies at a locator timeout at step 30, and the line never executes — so it catches only loud failures, and names the whole journey instead of the action. Move the verdict into teardown (a fixture, an `afterEach`, an `afterAll` for a serial file), where it runs whether the body passed, failed or timed out, and attach the in-flight step name to what it reports. Moving a verdict later also changes what it *sees*, so state the boundary: "recording stops when the journey asks the app to quit" keeps normal-shutdown noise from becoming a nondeterministic failure
- **Before blaming your change for a red test, check out the base branch's version of those files over your branch and run the same command.** A suite that is rarely run is usually already red, and the failures you "caused" are often waiting for you. Record the base's failures with their exact errors, log them as their own bug rather than fixing them inside a test-integrity change, and only then claim your numbers did not go down — and re-measure the base itself, because it may have moved since the task was written
- The **shipped artefact is a different runtime** from the tree it was built from: paths resolve differently inside an archive, a spawned binary may not be executable, a hoisted dependency may not be bundled, permissions and code identity differ. Test what you ship, driving it the way a user starts it, and assert it reaches a usable state
- **A zero from a search is a claim about your pattern, not about the code.** An unquoted glob the shell expanded, a regex metacharacter taken literally (`pgrep -f 'App (Renderer)'`), a line-oriented grep over multi-line JSX — each returns a confident, clean zero. Before reporting "there are none", prove the search can find one: run it against a case you know exists
- A finding that **changes between runs is an instrument artefact** until it reproduces. Animations caught mid-transition, a disk filling up, a shared machine under load — all produce confident, wrong findings. Reproduce twice before reporting, and freeze the variables the instrument itself introduces
- A suite that answers differently for identical code **can't gate anything, in either direction**. Chase the cause: a deadline that measures wall-clock on a shared machine, an fsync queued behind every other worker, a test counting something the environment created. Raising a timeout hides it; fixing the clock or the fsync removes it
- **Audits that only measure contracts can't see "looks wrong."** Every CSS assertion can pass while a field renders crushed. Anything whose defect is visual needs rendered output that someone actually looks at
- **Verify discovery against the real machine with every workaround removed.** A finder unit-tested with its own path assumption passes forever while the installer puts the thing somewhere else; one run against the real disk, no pinned settings, finds it in seconds
- **Audit a benchmark's scorer before trusting its zeros, and pin every knob on both arms.** A keyword rule read "the old code couldn't handle X" as the agent giving up and hid a false "done"; one runner's effort level was left at its own default. Both made a revert blame the wrong change. Re-run the baseline without the change before attributing a regression to it
- When you delegate a review, **ask it to prove your premise before building on it** — and treat a subagent refuting you as the system working. Premises handed down as fact are the most expensive kind of error, because everything downstream inherits them

**Security**
- A fix to a safety gate (command review, permissions, path checks) gets its own security review on the most capable model, probing with dozens of bypass inputs (globs, variables, `~`, `..`, wrappers, comment injection). The implementer's own tests cover only the inputs it thought of
- When a second probe round still finds bypasses, stop extending the denylist and make the gate fail closed: only fully understood input is auto-allowed, and anything opaque is escalated
- "Always allow" on a user's real computer must be an allowlist (plain ASCII arguments, no shell metacharacters, paths inside roots the user chose), never a denylist of dangerous paths. Filesystems fold Unicode (ſ→s, the Kelvin sign → k), accept `//`, `/./` and globs, and may be case-insensitive, so path denylists always leak. Compare canonical, case-folded real paths
- When a bypass class keeps coming back (e.g. repo config that makes a tool run programs), guard the step where the attacker sets it up (review writes to that config) instead of blocking each payload by name
- Merging two phases can open holes neither had alone (a new feature that skips an earlier phase's hardening). Every integration merge gets its own security review. Put safety-critical invariants (environment pins, review routing) in ONE shared function every entry point calls, never copy them per feature
- Every alternate approval path (hooks, deferred, batched) must carry the same binding (content hashes, enriched previews) as the main path. Test each path, not just the common one
- A root-owned helper must validate its arguments as root, then drop to the target user before touching any path a lower-privileged user can write. Running mkdir, write, chown, mv or rm as root in such a directory gives away root through symlinked temp files and swapped directories. Create temp files exclusively and publish with no-follow, no-directory semantics
- Anything a privileged process deletes or copies must live where a less-privileged user can't write. Checking a path and then using it is racy when a lower-privileged user owns a parent directory
- **Metering and budgets are security code: probe them like a gate.** "Spend never happens without asking" failed three ways a first review missed: compressed responses the meter couldn't read, aborted streams that never reported, and a budget checked once per run instead of per request. Price unknown models at the highest known rate, and queue failed usage reports instead of dropping them
- **Sign what an update claims to be, not only its bytes.** Sign `name|version|hash`, so an old signed artefact can't be replayed under a newer tag. Verify before unpacking, on a private copy (not a path someone else can swap), and keep the signing key outside the repo with a backup plan
