# Harness Developer Guide (go-question)

This guide explains how the team should use the project harness with any coding model.
EN is primary. RU notes are added for clarity.

## 1) What This Harness Is

This project uses a thin root policy and detailed runtime rules.

Entry points:

- `AGENTS.md` (thin root contract)
- `.agents/harness/harness_index.md` (canonical load order)
- `.agents/rules/*` (mandatory project rules)
- `.agents/skills/*` (task-scoped playbooks)

Architecture contract:

- Flutter + Dart
- BLoC + GetIt + auto_route + Firebase
- `freezed` for immutable/codegen models and state unions
- Functional style with custom `Result<TSuccess, TFailure>`

## 2) Session Bootstrapping (How To Put Model In Context)

Use this at the start of a fresh model session.

```text
Read and follow AGENTS.md in this repository.
Then load and apply rules from:
1) .agents/harness/harness_index.md
2) .agents/harness/* in listed order
3) .agents/rules/*
4) .agents/skills/* only if relevant

Before editing, summarize:
- active architecture constraints
- quality gate
- git/PR policy
Then execute task changes accordingly.
```

## 3) Task Input Template For Team

Use this template when assigning work to a model.

```text
Task:
Context:
- Feature/module:
- Problem or goal:
- Related files:
Constraints:
- Keep architecture: BLoC + GetIt + auto_route + Firebase
- Follow constants policy (no magic constants)
- Use const where possible
- Keep functional flow: Result-based success/failure handling
- Handle exceptions explicitly and map to typed failures
- Feature custom exceptions/failures must implement shared interfaces
Definition of done:
- Behavioral result:
- Tests to add/update (critical-path TDD):
- Quality gate required: flutter analyze, flutter test, dart format --set-exit-if-changed lib test
Output needed:
- Files changed
- Risks/assumptions
- Suggested commit title(s) in Conventional Commits format
```

## 4) Standard Workflow (End-to-End)

1. Load context from `AGENTS.md` + `.agents/harness/harness_index.md`.
2. Analyze scope and impacted layers.
3. Plan minimal safe change set.
4. Apply TDD for critical paths (RED -> GREEN -> REFACTOR).
5. Implement with architecture boundaries preserved.
6. Run mandatory review focus:
   - architecture coherence
   - logic correctness
   - codebase consistency
   - security review
7. Run quality gate:
   - `flutter analyze`
   - `flutter test`
   - `dart format --set-exit-if-changed lib test`
8. Prepare clean commit set (Conventional Commits, cohesive, rollback-safe).
9. Open one logical PR from a named branch.

## 5) Git and GitHub Workflow

Source of truth: `.agents/rules/git-github.md`

### Branch Naming

Use named branches (not `main`):

- `feat/<short-kebab-description>`
- `fix/<short-kebab-description>`
- `refactor/<short-kebab-description>`
- `test/<short-kebab-description>`
- `chore/<short-kebab-description>`

### Commit Naming (Conventional Commits)

Format:

`<type>(<optional-scope>): <short imperative summary>`

Examples:

- `feat(auth): add email verification resend cooldown`
- `fix(profile): make profile widget immutable`
- `refactor(theme): move repeated spacing to ui constants`
- `test(auth): add regression for sign out state reset`

### Commit Shape Rules

- One commit = one intent.
- Keep commits reviewable and not oversized.
- Reverting one recent commit should not break unrelated behavior.
- WIP commits are allowed for large tasks, but final PR history should be clean.
- Dependency changes in `pubspec.yaml` require explicit developer approval.

### PR Rules

- Prefer one PR = one complete logical feature/fix.
- Avoid fragmented PRs for one feature.
- PR must come from a named branch.
- Use template: `.github/pull_request_template.md`.

PR must include:

- scope and result
- architectural impact
- quality gate evidence
- security notes
- rollback notes
- UI evidence if needed

## 6) Context Control During Long Tasks

If model starts drifting:

1. Ask it to restate active constraints from `AGENTS.md` and `.agents/harness/harness_index.md`.
2. Ask it to list touched files and why each file is needed.
3. Ask it to continue with minimal change surface.

Reset prompt:

```text
Pause and realign with repository harness.
Restate active constraints and quality gate.
Then continue with minimal, architecture-safe edits only.
```

## 7) Definition of Done

A task is done only when all are true:

- requested behavior is implemented
- architecture contract is preserved
- security review completed
- quality gate results are reported honestly
- commit history is cohesive and rollback-safe
- PR scope is one logical feature/fix

## 8) Quick Daily Checklist

- Context loaded?
- Scope clear?
- Critical-path tests updated?
- Analyze/test/format executed?
- Commits clean and conventional?
- PR coherent and from named branch?
