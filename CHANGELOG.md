# Changelog

## 1.1.0 (2026-09-26)
- **Scale:** if unsure, pick Standard (good-build: Medium) and move up only when a gate fails or a real unknown appears. Full needs the user's explicit OK, recorded in the decision log.
- **Handoff:** good-idea ends by writing a Handoff section in the decision log that names the spec, traceability map, Phase 0 findings, mockup and plan by path; good-build starts from it.
- **Gate script:** plain example defaults (`docs/spec/*trace*.md`, `docs/qa*.md`, `.build-ledger.md`), and the traceability check accepts a glob.
- **README:** a note that the marketplace install needs the repo to be public, and how versions are numbered.

## 1.0.0 (2026-09-26)
- way-too-good (the full pipeline), good-idea (planning only) and good-build (building from a plan), in the open Agent Skills format with tool-neutral wording, packaged as a Claude Code plugin.
