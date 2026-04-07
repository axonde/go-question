---
paths:
  - "**/*.dart"
  - "test/**/*.dart"
---

# Testing Policy (Project Rules)

## Current Policy

Use TDD workflow, but prioritize tests for critical behavior first.

- RED: write failing test for critical behavior.
- GREEN: minimal implementation.
- REFACTOR: cleanup with tests still green.

## What Is Critical Right Now

At minimum, cover:

- Authentication and session transitions
- Route guard behavior (`AuthGuard`, `GuestGuard`)
- BLoC/Cubit transitions for key user flows
- Repository mapping logic that can break production behavior

## Review/Test Alignment

If code changes critical behavior and no test is added, explain why explicitly.
Bug fixes should include a regression test whenever practical.

## Quality Gate Command

- `flutter test`

(Architecture/security reviews are separate mandatory gates.)
