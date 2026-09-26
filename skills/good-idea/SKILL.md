---
name: good-idea
description: Use when the user asks for good-idea (e.g. /good-idea), wants help deciding what to build, or wants an idea or a product to clone researched, specced, mocked up and proven before any building starts, especially when uncertainty, unknown internals, or cost of rework is high.
---

# Good Idea

## Overview
The planning half of a serious build: from a vague idea to an approved spec whose risky unknowns have been proven. It stops before implementation plans and code. **Stage count is fixed; stage depth is adaptive.** Every stage leaves an artifact on disk, runs in order, and passes its gate at the chosen depth before the next begins.

**Depth may shrink. Proof may not.** Two invariants hold at every depth:
1. Every real unknown is proven in the target environment before the idea is called ready (Stage 9).
2. The user approves the idea, the scale, every open decision and the mockup explicitly.

## Conventions (map these to your project)
Name artifacts by role, and record the concrete locations in the decision log at the start:

| Role | What it holds | Example location |
|---|---|---|
| **Decision log** | goal, scale, constraints, every decision (date · decision · why · who) | `docs/decisions.md` |
| **Research folder** | numbered research notes and any source archive | `research/<topic>/` |
| **Spec** | the numbered requirements: the authority everything later argues from | `docs/spec/` |
| **Traceability map** | UI ↔ requirement ↔ build phase | alongside the spec |
| **Findings** | Phase 0 results: each unknown PASS, or its fallback | `docs/spec/phase0-findings.md` |

Project decisions go in the decision log. Assistant memory holds only lasting, cross-project preferences, never project state.

## Stage 1: declare the scale
Recommend a scale in one sentence; the user has the final say. Record it.

| Scale | Signals |
|---|---|
| **Fast** | small, familiar platform, low risk |
| **Standard** | a meaningful product, moderate uncertainty, known platform |
| **Full** | ambitious or novel, cloning or reverse-engineering, unknown platform behaviour, high cost of rework |

Move up if uncertainty appears midway. Never move down past a gate that has already failed.

## The stages

| # | Stage | Artifact | Fast | Standard | Full |
|---|---|---|---|---|---|
| 0 | **Discover** | the idea, in the decision log | 1 question + the idea | goal questions (one at a time, plain chat) + a short R&D sprint | + parallel research agents + stress-test the lead idea; stop agents on a pivot |
| 1 | **Frame + scale** | decision log | goal, what "done" means, scale | + constraints, out of scope for v1 | + platform, budget/plan limits, public vs personal |
| 2 | **Research** | research folder | targeted notes | 4 tracks (features/logic, UI, reception and competitors, platform/SDK), claims sourced | + verify ≥3 key claims yourself |
| 3 | **Internals** | research folder | only the relevant unknowns | detailed behaviour | exhaustive rundown + an indexed source archive; behaviour only, never leaked or reconstructed code |
| 4 | **Ground truth** | research folder | the evidence supplied | screenshot teardown | full teardown; text/accessibility reads first; ask for ONE specific screenshot, never bulk capture |
| 5 | **Spec** | spec | concise requirements | numbered requirements with sources and mechanisms, labelled IDENTICAL / ADAPTED / DECISION NEEDED | + data model, limits, build order; the user settles every decision |
| 6 | **Gap engineering** | spec § Original designs | decide inline | original designs for the real unknowns | every unknown → a design with constants, real prompts and evals; the user's principles enforced in code, not prose |
| 7 | **Mockup** | a design canvas or playable page | the key screen | baseline → user notes → multi-screen | the complete interaction set; the user approves explicitly |
| 8 | **Traceability** | traceability map | critical paths | all UI ↔ requirement ↔ phase | bidirectional and exhaustive; 0 MISSING |
| 9 | **Phase 0** ★ | findings | real unknowns proven | real unknowns proven | real unknowns proven; each PASSes or has a fallback |

★ = invariant: the same gate at every scale.

**Done** = the user has approved the spec and mockup, traceability has no MISSING rows, and every unknown has a PASS or a fallback. Hand off to a build process (e.g. `/way-too-good` from Stage 10, or writing an implementation plan).

## Start
1. Create one todo per stage (0–9), with the titles verbatim.
2. Before closing a stage, confirm its artifact exists and read it against the declared scale.

## Red flags: stop and go back
- Skipping a stage instead of running it lighter
- "It's small, so skip Phase 0" (proof never shrinks)
- Full depth on a small tool: the process becomes the project
- "The agent said it's done" without checking one claim, a count or a size
- A spec requirement with no source, or a "DECISION NEEDED" the user never settled
- A premise handed down as fact: ask the reviewer or researcher to prove it before building on it

## Common mistakes
- **Research stays private.** Copied research, look-alike assets or text lifted from the reference never ship; do an IP review before anything goes public
- **Confirm who a feature or removal is for.** Owner-only and public builds may need different answers (a sign-in the owner may use personally but may not ship); settle it in the decision log at Stage 1
- **Visual choices get a playable side-by-side page**, in light and dark and at real sizes, not a description. When another tool designs a competing option, give it the brief and constraints only, never your concepts
- **A zero from a search is a claim about your pattern.** Prove the search can find a known case before reporting "there are none"
- **A finding that changes between runs is an instrument artefact** until it reproduces twice
- **Verify discovery on the real machine with every workaround removed**; a pinned setting hides the bug and its siblings
- **Prompt-only rules for costly behaviour don't hold**: design them to be enforced in code
- **Cost-conscious evidence**: text over images, one specific screenshot over bulk capture, notifications over polling
