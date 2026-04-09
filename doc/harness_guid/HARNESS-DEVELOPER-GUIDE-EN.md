# Harness Developer Guide (go-question)

This guide explains how the team should use the project harness with any coding model.

## 1) Harness Entry Points

- `AGENTS.md` (thin root contract)
- `.agents/harness/harness_index.md` (canonical runtime load order)
- `.agents/rules/*` (mandatory rules)
- `.agents/skills/*` (task-scoped playbooks)

Architecture baseline:

- Flutter + Dart
- BLoC + GetIt + auto_route + Firebase
- `freezed` for immutable/codegen models
- custom `Result<TSuccess, TFailure>` for functional success/failure flow

## 2) Session Bootstrap Prompt (Model Context)

Use this at the start of a new model session.

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

## 4) Feature Workflow (Most Important)

For one feature, delivery order is mandatory:

1. Domain layer
- define/confirm entities, repository interfaces, failure types, and result contracts
- lock business logic contracts first

2. Data layer
- implement datasource + repository according to domain contracts
- add explicit exception-to-failure mapping
- use `shared_preferences` or `sqflite` when local storage is needed

3. Presentation layer
- implement BLoC/Cubit over ready domain/data contracts
- connect bloc to already prepared UI screen
- if screen is absent, create a minimal page scaffold and wire bloc flow

## 5) Multi-Developer Mode (Same Feature)

If multiple developers work on one feature, split ownership by layers:

- Developer A: domain
- Developer B: data
- Developer C: presentation

Rules:

- handoff order is `domain -> data -> presentation`
- final presentation integration starts only after domain contracts are agreed
- each layer owner keeps interfaces explicit and stable

## 6) UI Composition Rules (Mandatory)

- Do not create reusable widget UI via `_build*` methods.
- Widgets must be classes; prefer `StatelessWidget` whenever possible.
- Keep widgets dumb/presentational.
- Business state and transitions are controlled by BLoC.
- For a logical feature-local composite component, use:
  - root file in `widgets/`
  - internal subparts in `widgets/components/`
  - `part` in root + `part of` in subfiles
  - private classes for internal-only subparts

## 7) Standard Workflow (End-to-End)

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

## 8) Git and GitHub Workflow

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

## 9) Context Control During Long Tasks

If the model starts drifting:

1. Ask it to restate active constraints from `AGENTS.md` and `.agents/harness/harness_index.md`.
2. Ask it to list touched files and why each file is needed.
3. Ask it to continue with minimal change surface.

Reset prompt:

```text
Pause and realign with repository harness.
Restate active constraints and quality gate.
Then continue with minimal, architecture-safe edits only.
```

## 10) Definition of Done

A task is done only when all are true:

- requested behavior is implemented
- architecture contract is preserved
- security review completed
- quality gate results are reported honestly
- commit history is cohesive and rollback-safe
- PR scope is one logical feature/fix

## 11) Quick Daily Checklist

- Context loaded?
- Scope clear?
- Critical-path tests updated?
- Analyze/test/format executed?
- Commits clean and conventional?
- PR coherent and from named branch?
