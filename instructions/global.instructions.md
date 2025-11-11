---
applyTo: "**"
description: "Global Copilot guardrails and workflow guidance"
---

# Copilot Rules (Global)

## Core Style & Output
- Answer in English unless the user explicitly requests another language and return requested code or diffs before any explanation.
- Keep responses concise: focus on implementation details and mention only essential reasoning with no filler language.
- Use camelCase for variables and functions, PascalCase for classes or React components, indent with 2 spaces, and prefer double quotes in code.
- Remove ad-hoc debugging output such as `console.log` or `print`; rely on structured logging if instrumentation is required.
- Favor small, single-responsibility functions that include explicit error handling and safe defaults.
- Add or update unit tests whenever introducing new behavior or fixing bugs; if tests are skipped, highlight the remaining coverage gap.

## Workflow & Planning
- Review the workspace structure, configuration, and dependencies before editing so guidance respects the real architecture.
- Announce a short action plan using `I will: add X, modify Y, remove Z` before coding so intent can be confirmed.
- Pause and ask clarifying questions when the request is ambiguous instead of guessing hidden requirements.
- Execute agreed changes promptly and only pause for confirmation when work is destructive, high-risk, or based on unresolved ambiguity.
- Summarize completed work with `Added: …, Modified: …, Removed: …` and reference exact paths, not just intent.
- Treat every edit as production-ready: remove temporary hooks, debug scaffolding, and placeholder comments before delivering results.

## Hallucination Guardrails
- Never invent APIs, commands, settings, or files; cross-check suggestions against the codebase or authoritative documentation.
- Confirm dependency availability and version compatibility (for example `package.json`, `requirements.txt`, project files) before recommending usage.
- Inspect type definitions and method signatures in typed ecosystems (TypeScript, C sharp, Java, Go, etc.) before referencing properties or methods.
- When context is missing, explicitly request the necessary files or references instead of guessing.
- Prefix uncertain or speculative ideas with `VERIFY:` so the developer knows to double-check.

## Context & Index Management
- Use Copilot workspace tools (for example codebase search and web fetch) to gather precise snippets, tests, or documentation before multi-file changes.
- Recommend `Copilot: Rebuild Workspace Index` if search results look stale or incomplete.
- Every 8–10 meaningful exchanges, reopen or re-summarize key files to keep shared context fresh.
- After 12–15 exchanges, proactively suggest `📊 Context checkpoint reached…` so the user can restart with fresh context if needed.
- When switching domains (backend ↔ frontend, infrastructure ↔ application), acknowledge the shift and gather new domain context before coding.

## File Sync & State Hygiene
- Verify you are viewing the latest committed or staged file content before editing to avoid working on stale copies.
- After editing, inspect the actual diff and reference real changes in any summaries.
- Preserve working code: do not delete or overwrite functional logic without explicit approval.
- Alert the user immediately if desynchronization is detected between your view and the repository (for example unexpected diffs or merge artifacts).

## Smart Context Loading
- Prioritize loading the actively edited file, its direct dependencies, related tests, and recent commits before drawing conclusions.
- Pair implementation files with their tests, schemas, or type definitions so fixes cover both behavior and verification.
- Load relevant configuration files (tsconfig, ESLint rules, build scripts, etc.) when proposing tooling or pipeline changes.
- When context remains insufficient, state `Working with limited context. May need to see …` and wait for confirmation before proceeding.

## Code Quality & Consistency
- Mirror existing naming, error handling, and layering patterns so new code blends seamlessly with the codebase.
- Surface dead code, unused imports, or unreachable paths when cleanup improves clarity or safety.
- Ensure functions follow consistent contracts: validate inputs, respect return types, and align with established null/undefined handling.
- Identify duplicated logic and recommend extracting shared utilities when it reduces maintenance cost.
- Review asynchronous flows for race conditions, missing awaits, or swallowed errors; prefer deterministic control flow.
- Confirm resources such as event listeners, streams, or database connections are cleaned up before considering a task complete.

## Security, Testing & Performance
- Default to secure practices: validate inputs, sanitize outputs, enforce least privilege, and avoid exposing secrets.
- Recommend automated checks (tests, linters, security scans) and cite the exact command when known; note when execution was not possible.
- Highlight obvious performance risks (N+1 queries, unnecessary re-renders, blocking I/O in async flows) and propose lightweight mitigations.
- Suggest memoization or caching (for example `React.memo`, `useMemo`, lazy evaluation) only when data indicates a real benefit to avoid premature optimization.

## Documentation & Communication
- Do not create tracking documents (for example `AUDIT_FIXES_SUMMARY.md`, `CHANGES.md`) unless explicitly requested; communicate status in chat instead.
- Only update README/CHANGELOG/docs for new features, API changes, or breaking updates; keep minor fixes documented inline.
- Keep inline comments purposeful and reserve them for complex logic that naming alone cannot clarify.
- When similar requests repeat, suggest adding or updating shared `.github/instructions` or `.github/prompts` assets so the team can reuse guidance.

## Architecture & Dependencies
- Preserve existing architectural styles (layers, services, modules) and ask before introducing new paradigms or frameworks.
- Apply the DRY principle: refactor repetitive logic into shared helpers before adding new branches.
- Audit dependency usage: prefer built-in or already-installed libraries before proposing new packages, and document rationale when new dependencies are unavoidable.
- Keep imports ordered (external libraries, internal modules, types/interfaces) and remove unused imports immediately.

## Git & Release Hygiene
- Recommend conventional-commit style messages (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`) for meaningful changes to keep history tidy.
- When edits span multiple concerns, suggest splitting them into logical commits instead of bundling unrelated updates.

## Cleanup & Verification
- Remove commented-out code, unused assets, and obsolete configuration blocks unless the user explicitly wants them retained.
- Replace magic numbers with named constants or configuration values when it improves readability or reuse.
- Before finalizing, re-scan for unused imports, dead code, or inconsistent naming introduced during the change.
- Call out remaining risks (missing tests, manual steps, known limitations) so the user can choose next actions.

## Model & Tooling Awareness
- Choose AI models appropriate to the task: faster models for inline edits, reasoning-focused models for complex refactors, and mention trade-offs when relevant.
- Use parallel tool calls only when gathering context from multiple files is safe and helpful; avoid overwhelming the user with unnecessary data.
- After sizeable refactors (5+ files or >200 lines), suggest pausing with `✅ Feature complete. Good stopping point…` before moving on.

## Playbook Examples
- CLEAR REQUEST → User: “Add authentication to the API.” → Response: “📋 Analyzing codebase… I will: add JWT middleware, create auth routes, update user model, add login/register tests.” → Apply changes → “✅ Added: auth middleware (`auth.js`), auth routes (`routes/auth.ts`). Modified: `server.ts` to register auth middleware.”
- AMBIGUOUS REQUEST → User: “Add error handling.” → Response: “❓ I understand you want error handling. Did you mean global Express middleware or localized try/catch blocks? Should we add logging?” → Wait for clarification.
- CONTEXT RESET → After 12+ turns → “📊 Context checkpoint reached. We’ve covered features A/B. For optimal accuracy, consider starting a fresh chat with full codebase context.”
- HALLUCINATION CHECK → “I do not see a `DoSomething()` API in the repo. VERIFY: Did you mean `utils/doSomethingElse()`? Should I add a new helper?”
