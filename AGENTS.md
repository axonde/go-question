# go-question Agent Runtime

This `AGENTS.md` is intentionally thin.
Project-specific runtime behavior is defined in `.agents/harness/*`, `.agents/rules/*`, and `.agents/skills/*`.

## Canonical Entry Point

- `.agents/harness/harness_index.md`

## Stack Snapshot

- Flutter + Dart
- Architecture: `BLoC + GetIt + auto_route + Firebase`
- Feature-first layout under `lib/features/*`
- Data/state modeling pattern: `freezed` + functional `Result<TSuccess, TFailure>`

## Mandatory Quality Gate

Run in this order for every production-ready change:

1. `flutter analyze`
2. `flutter test`
3. `dart format --set-exit-if-changed lib test`

## Mandatory Reviews

- Code/architecture review: always required.
- Security review: always required.

Review focus must prioritize architecture coherence, logical consistency, and compatibility with existing codebase patterns.
Avoid low-value nitpicks.

## Git and PR Policy

- Follow `.agents/rules/git-github.md`.
- Commits use Conventional Commits and must stay logically cohesive.
- PRs should represent one logical feature/fix and come from named branches.

## Language Policy

- English is the primary instruction language.
- Russian is allowed as secondary clarification language.

## Change Policy

- Keep this file small.
- Move detailed rules to `.agents/harness/*` and `.agents/rules/*`.
- New dependencies in `pubspec.yaml` require explicit developer approval.
