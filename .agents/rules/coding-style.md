---
paths:
  - "**/*.dart"
  - "**/analysis_options.yaml"
  - "**/pubspec.yaml"
---

# Dart/Flutter Coding Style (Project Rules)

## Effective Dart Baseline

Follow Effective Dart conventions for naming, readability, and API design.
Use `dart format` as the single formatting source of truth.

## Formatting

- Format gate: `dart format --set-exit-if-changed lib test`
- Keep trailing commas for multi-line collections/arguments.
- Keep imports clean and ordered.

## Const and Immutability

- Prefer `final` for locals and fields when reassignment is not needed.
- Use `const` constructors and `const` literals wherever possible.
- Prefer immutable state/value objects.

## Constants Policy

- No magic constants in feature logic or widget trees.
- Move reusable constants to:
  - `lib/core/constants/` for business/app constants
  - `lib/config/theme/` for design tokens
- Keep one-off local constants local only when truly single-use and readability improves.

## Flutter UI Rules

- Avoid inline hardcoded colors/sizing when a theme token already exists.
- Prefer small reusable widgets over very large `build()` methods.
- Use `context.mounted` checks after `await` before UI actions.

## Async and Error Handling

- Await futures explicitly or mark fire-and-forget with intent.
- Map infrastructure exceptions to domain/presentation-safe messages.
- Avoid broad catch blocks without specific handling intent.
- Do not leave exception paths unhandled in production code paths.
- Prefer returning the project's `Result<TSuccess, TFailure>` for recoverable flows.
- Keep thrown exceptions for boundary/infrastructure failures, then map them to typed failures.
