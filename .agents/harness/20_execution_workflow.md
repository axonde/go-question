# Execution Workflow

Follow this sequence for each task.

## 1) Analyze Scope

- Identify target feature(s).
- Identify affected layers (presentation/domain/data/router/di).
- Read existing nearby implementation patterns first.

## 2) Plan Minimal Change Set

- Define smallest safe edit surface.
- Identify risks: auth, routing, DI, Firebase, state transitions.
- If new dependencies are needed, pause and request developer approval before editing `pubspec.yaml`.

## 3) TDD for Critical Paths

- Use RED -> GREEN -> REFACTOR for critical behavior.
- Current policy: prioritize tests for critical scenarios (not blanket coverage expansion).

## 4) Implement

- Keep architecture boundaries intact.
- Apply const-first and constants extraction rules.
- Keep changes cohesive with current codebase style.
- Use `freezed` and `Result` patterns consistently with existing code.
- Add explicit exception-to-failure handling, do not leave unhandled exception paths.

## 5) Review

- Mandatory architecture/code review.
- Mandatory security review.
- Focus on logic, cohesion, and compatibility with existing project patterns.

## 6) Quality Gate

Run and report:

1. `flutter analyze`
2. `flutter test`
3. `dart format --set-exit-if-changed lib test`

If a command fails, report the exact failure and stop claiming production-ready status.

## 7) Commit and PR Hygiene

- Create cohesive, rollback-safe commits.
- Use Conventional Commits for non-WIP commits.
- Keep one PR as one logical feature/fix whenever possible.
- Open PR from a named branch (`feat/*`, `fix/*`, `refactor/*`, etc.), not from `main`.
