# Debug-mode Rules

## Purpose
Locate root-cause quickly, propose minimal-impact fix, and verify with tests.

## Checklist
1. Reproduce issue locally with `pnpm test <path>` or `pnpm dev`.
2. Capture **before/after** stack trace in *decisionLog.md* (memory bank).
3. Add/expand a regression test first; only then patch the code.
4. After patch, run full suite + `pnpm run typecheck`.

## Tool Limits
- Prefer *search_files* over *read_file* for large directories.  
- Never delete user code—mark with TODO if removal likely.

## Escalation
If root-cause spans >3 files or an external dependency, hand over to **Architect mode**.
