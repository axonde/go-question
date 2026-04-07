---
name: go-question-flutter-patterns
description: Project-focused implementation patterns for Flutter with BLoC, GetIt, auto_route, and Firebase.
origin: project
---

# go-question Flutter Patterns

## When to Use

Use this skill when implementing or reviewing code in this project and you need stack-specific guidance.

## Core Pattern Set

1. BLoC/Cubit drives UI state.
2. Repositories hide Firebase/data source details.
3. GetIt handles composition root registration.
4. auto_route centralizes navigation and guards.
5. Constants are extracted and reused via core/theme token files.

## BLoC Pattern

- Keep events explicit and small.
- Keep state immutable.
- Model loading/success/failure transitions.
- Avoid cross-bloc orchestration for core business logic.

## DI Pattern (GetIt)

- Register feature dependencies in `injection_container.dart`.
- Prefer constructor injection in blocs/repositories.
- Keep registration order predictable: state -> repository -> datasource -> external.

## Navigation Pattern (auto_route)

- Keep route declarations in `router.dart`.
- Keep access logic in guards.
- Do not edit generated `router.gr.dart` manually.

## Constants Pattern

- Domain/app constants: `lib/core/constants/`.
- UI constants/tokens: `lib/config/theme/`.
- Avoid inline repeated strings/numbers in widgets and state logic.

## Quality Commands

1. `flutter analyze`
2. `flutter test`
3. `dart format --set-exit-if-changed lib test`
