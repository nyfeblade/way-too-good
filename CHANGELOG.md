# Changelog

## 1.2.0 (2026-10-22)
- Each skill names a fallback for checklists, helper agents, parallel work, model choice, sources, a design surface, and background waits, so a harness without that feature still runs the step.
- `install.sh` copies the canonical skill folders into the directory each harness documents, for one harness or all of them. It does not delete user files or overwrite an existing instruction file.
- Pointer files for AGENTS.md, CLAUDE.md, GEMINI.md, Copilot instructions, and Cursor rules are generated from skill frontmatter. `scripts/wtg_skills.py check` fails if they drift.

## 1.1.1 (2026-09-26)
- way-too-good names the build ledger `.build-ledger.md`, the same path good-build and the gate script use.
- README: why the skills exist, the Standard default, the good-idea → good-build handoff, and how to run the gate script.

## 1.1.0 (2026-09-26)
- **Scale:** if unsure, pick Standard (good-build: Medium) and move up only when a gate fails or a real unknown appears. Full needs the user's explicit OK, recorded in the decision log.
- **Handoff:** good-idea ends by writing a Handoff section in the decision log that names the spec, traceability map, Phase 0 findings, mockup and plan by path; good-build starts from it.
- **Gate script:** plain example defaults (`docs/spec/*trace*.md`, `docs/qa*.md`, `.build-ledger.md`), and the traceability check accepts a glob.
- **README:** a note that the marketplace install needs the repo to be public, and how versions are numbered.

## 1.0.0 (2026-09-26)
- way-too-good (the full pipeline), good-idea (planning only) and good-build (building from a plan), in the open Agent Skills format with tool-neutral wording, packaged as a Claude Code plugin.
