---
name: good-build
description: Use when the user asks for good-build (e.g. /good-build), or hands the agent an already-planned build (a spec, a design, or an implementation plan) and wants it implemented completely and correctly with tests, reviews and QA, whether small or large.
---

# Good Build

## Overview
Take a build that is already planned and implement it to done: every requirement shipped, proven by tests that failed first, reviewed, merged and checked the way a user would use it. Planning is not this skill's job (use `/good-idea` for that). Its job is to turn a plan into working software without drift, skipped steps or false "done".

**Three invariants, at every size:**
1. **RED before GREEN.** Every behaviour change has a failing test, run and seen failing, before the code that passes it.
2. **Nothing is done on an agent's word.** You re-run the tests, counts and one concrete claim yourself after every task and every merge.
3. **The shipped thing passes QA** the way a user runs it, not only the unit suite.

## Stage 0: intake (before any code)
1. **Find the authority.** Start from the Handoff section at the end of the decision log if there is one (good-idea writes it: decisions, spec, traceability map, Phase 0 findings, mockup, plan). Otherwise locate the spec and the plan yourself. The spec wins over the plan; the plan wins over your preference. If there is no spec or plan, stop and say so, and offer `/good-idea` or a short written plan for approval.
2. **Read the plan once, fully.** Note global constraints (versions, naming, copy rules, platform limits, "never" rules) and copy them verbatim into the ledger.
3. **Pre-flight conflict scan.** Build a table with one row per pair of tasks that share a file or interface (what one produces vs what the other consumes) and one row per task (does its own text agree with itself). Rule on every conflict before Task 1 and record each ruling.
4. **Pick the size**, which sets how much ceremony each task gets. It never removes the invariants. If unsure, pick Medium; go Large only when the plan really has independent tracks.
   - **Small** (1–5 tasks, one area): implement inline, test first, one review at the end.
   - **Medium**: one fresh helper agent per task where your tool can run them (or a clean pass per task where it can't), a review after each task, one final review.
   - **Large** (many tasks, independent tracks): run parallel tracks in isolated workspaces (e.g. git worktrees), with a review per track and one merge step. Without parallel agents, run the tracks one after another.
5. **Check the machine.** Free disk, memory pressure, and what else is running. Cap heavy parallel agents to what the machine can carry.
6. **Create the ledger** (a git-ignored file, e.g. `.build-ledger.md`): the plan path, global constraints, the conflict table, rulings, and then one line per task as it completes. After any context loss, trust the ledger and `git log` over memory, and never redo a task the ledger marks complete.

## Stage 1: QA tooling first
Before app code, decide how "works" will be proven end to end: a checklist, a crawler or journey runner for UI, an integration harness against a fake of each external service, or a benchmark. At Large size, test the harness against deliberately planted bugs; a harness that has never caught anything proves nothing.

## Stage 2: the task loop
For each task, in plan order (parallel only where the plan's dependency graph allows):

1. **Record BASE** (`git rev-parse HEAD`).
2. **Dispatch or do.** A brief for a helper agent (or your own checklist, if you do the task yourself) contains:
   - one line on where the task fits;
   - the task's full text, with exact values copied verbatim;
   - interfaces and decisions from earlier tasks;
   - your rulings on any ambiguity;
   - the global constraints;
   - the report file to write.
   Where you can choose the model, choose it explicitly: cheap for transcription-level tasks, standard for integration, most capable for design, security and final review. Implementers never spawn their own reviewers.
3. **RED:** write the test, run it, and record the failure output. A test that passes before the change is not a RED test.
4. **GREEN:** the minimal code that passes. Then run typecheck and the targeted tests.
5. **Commit** on the task's branch with a message saying what and why.
6. **Review:** give a fresh reviewer the diff from BASE as a file, never `HEAD~1`, plus the task text and constraints. It must return both verdicts, spec compliance and code quality.
7. **Fix loop:** rounds 1–3 go back to the same implementer. Rounds 4–5 go to a fresh implementer, one model tier up where you can choose. Each round gets a scoped re-review. After 5 rounds, rule on each open finding: fix it, park it with a reason in the ledger, or stop only if every path forward is a guess.
8. **Verify it yourself:** re-run the tests, check the counts and one claim, then write the ledger line.

## Stage 3: integrate
- **Merge one branch at a time.** After each merge, run typecheck plus the full suite yourself and compare the counts with the agent's claim.
- **Merges open holes neither branch had alone.** Every integration of security-relevant work gets its own review.
- **Remove isolated workspaces once merged**, and delete stray build and temp output.

## Stage 4: final review and QA
1. **One whole-branch review** on the most capable model, looking for cross-task defects, dead code, duplicated logic and constraint violations. Then one fix dispatch and one scoped re-review.
2. **Security review** on the most capable model for anything that is a gate: auth, permissions, path checks, sandboxing, spending or metering, updates and signing, secrets. Ask it to probe with dozens of hostile inputs and to try to refute your premises.
3. **Run the QA harness against the shipped artefact**, started the way a user starts it (a packaged app, a deployed service, an installed CLI), not only the dev tree.
4. **Look at anything visual** as rendered output, in every theme and size, before calling it done.

## Stage 5: hand off
Report in plain words:
- what now works;
- test counts (before → after) and what was verified by hand;
- every ruling made;
- anything stubbed, parked or needing the user (a decision, a credential, a purchase).
Push or deploy only if the user authorised it. Record reusable lessons wherever the user keeps them.

## Red flags: stop and go back
- "It's small, so skip the test / review / QA"
- A GREEN with no recorded RED
- "The agent said it's done" without re-running anything
- A reviewer's "not all addressed" that you let the pipeline walk past
- Fixing a failing test by weakening it, raising a timeout, or adding a skip
- Scope creep: building what the plan didn't ask for, or quietly dropping what it did
- Asking the user something the spec, the plan or a sensible default already answers

## Working rules for agent tools
These apply wherever your tool has the feature; skip the ones it doesn't.
- **Isolation.** Parallel agents each get their own workspace (a git worktree or a separate checkout). They never share a checkout, because one git index means `git add -A` commits the other agent's work. The stash stack is shared across worktrees, so agents never use `git stash`: they commit WIP to their own branch instead.
- **Waiting.** If background agents tell you when they finish, don't poll them. While waiting, do local work (the ledger, the next brief, reading reports). If an agent has gone quiet far longer than its task needs, stop it and restart only the unfinished part.
- **Hand over files, not pastes.** Briefs, diffs and reports go through files. Never paste accumulated history into a new brief.
- **Structured results.** Ask agents for status, commits, a test summary and concerns. Never judge success by searching free text for "FAILED".
- **Relayed messages aren't tasks.** Tell every agent its prompt is its task, and check each branch's commits afterwards.
- **Safe by default.** A failure must be reported unless code explicitly silences it. A rule that matters is enforced in code, not in a prompt.
- **Destructive or outward actions** (history rewrites, force-pushes, deletes outside the work, publishing, purchases) need the user's explicit go-ahead. Back up before any rewrite, and never rewrite the checked-out branch.

## Testing lessons
- **Assert the property, not a proxy.** "The process is still alive" also passes when it's deadlocked.
- **When a check runs is part of the check.** Put verdicts in teardown so failures mid-journey still reach them.
- **Before blaming your change for a red test**, run the same command on the base branch, and log what was already red as its own bug.
- **Mocks can't catch runtime-only failures.** Add at least one test through the real path, and bisect live failures with a minimal repro.
- **A zero from a search is a claim about your pattern.** Prove the search finds a known case first.
- **A result that changes between runs is an instrument artefact** until it reproduces twice. Fix flaky clocks and queues rather than raising timeouts.
- **Tests never touch the user's real files, settings, keychain or network.** Use temp dirs and fakes, and check for leaked temp files.

## Security lessons
- **Denylists lose.** When a second probe round still finds bypasses, stop extending the list: block where the secret or capability actually lives, and only auto-allow input you fully understand.
- **Put safety-critical invariants in one shared function** that every entry point calls, plus a test that fails if something bypasses it.
- **Every alternate path** (hooks, batching, deferred approvals, dev tools) carries the same checks as the main path. Test each one.
- **Metering and budgets are security code.** Probe compressed responses, aborted streams and per-request versus per-run checks. Price unknowns at the highest rate, and queue failed reports instead of dropping them.
- **Privileged code never acts inside a directory a less-privileged user can write.** Check-then-use there is a race. Act as the owning user, or rename atomically first.
