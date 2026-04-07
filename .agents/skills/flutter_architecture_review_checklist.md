# Flutter Architecture Review Checklist (Project Skill)

Use this checklist after implementation and before finalizing a task.

## 1) Architecture Coherence

- Does the change preserve `BLoC + GetIt + auto_route + Firebase`?
- Are dependency directions preserved (UI -> state -> domain/data)?
- Are new abstractions consistent with existing project style?

## 2) Logic and Cohesion

- Are state transitions explicit and understandable?
- Is business logic kept outside widgets where possible?
- Is the solution easy to trace end-to-end for this feature?

## 3) Constants and Styling

- Are reusable constants extracted from feature code?
- Are design tokens/theme constants used instead of hardcoded UI values?
- Is const-first applied where possible?

## 4) Routing and DI

- Are route changes centralized and guard-safe?
- Are dependencies registered in the DI composition root?
- Any accidental runtime dependency cycles introduced?

## 5) Security Minimum

- Any hardcoded secret or sensitive token?
- Any unvalidated input/deep-link path?
- Any sensitive data logged or stored insecurely?

## 6) Quality Gate

Run and report:

1. `flutter analyze`
2. `flutter test`
3. `dart format --set-exit-if-changed lib test`
