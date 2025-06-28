# Code-mode Rules

## 1. Purpose
Implement features, write tests, and refactor safely.  
Never merge un-reviewed code.

## 2. Workflow Checklist
- ALWAYS create a **feature/** or **bugfix/** branch; NEVER commit to main.  
- BEFORE writing code, scaffold a failing TRPC or Jest test (“red” in TDD).  
- Run: `pnpm lint && pnpm test --watch=false` after each diff.

## 3. Coding & Style
- Follow ESLint & Prettier config in repo (2-space indent, single quotes).  
- Limit functions to 50 LOC; extract helpers otherwise.  
- Prefer explicit async/await over `.then()` chains.

## 4. Safety & Tool Limits
- Max file read batch: 5 files per tool call.  
- NEVER use the *write_file* tool on `.env`, `package.json`, or migration files without user confirmation.

## 5. Escalation
If tests still fail after two attempts, switch to **Debug mode** and tag `@maintainers`.
