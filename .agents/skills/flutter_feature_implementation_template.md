# Flutter Feature Implementation Template (go-question)

Use this template for new or refactored features in this project.

## 1) Required Stack

- State: `BLoC/Cubit`
- DI: `GetIt`
- Routing: `auto_route`
- Backend: `Firebase`

Do not introduce parallel architecture patterns unless explicitly requested.

## 2) Recommended Feature Layout

```text
lib/features/<feature_name>/
  data/
    models/
    repositories/
    source/
  domain/
    entities/
    repositories/
    errors/
    services/
  presentation/
    bloc/ or cubit/
    pages/
    widgets/
      <logical_component>.dart
      components/
        _<logical_component>_fields.dart
        _<logical_component>_actions.dart
        _<logical_component>_header.dart
    validators/
```

Use existing local conventions if a feature already has a known structure.

## 3) Implementation Flow

1. Define/confirm domain contracts and failure mapping.
2. Implement data source + repository implementation.
3. Wire dependency registration in `lib/injection_container/injection_container.dart`.
4. Implement BLoC/Cubit events/states/transitions.
5. Integrate BLoC with ready UI screen; if no screen exists, build a minimal page scaffold.
6. Add tests for critical behavior (TDD).

### Multi-Developer Layer Split

When a feature is developed by multiple developers:

- Developer A (domain): contracts first.
- Developer B (data): repository/datasource implementation second.
- Developer C (presentation): bloc + screen wiring third.

Do not start final presentation integration before domain contracts are agreed.

## 4) Rules During Implementation

- Keep state immutable.
- Keep side effects in data/repository layer.
- Keep UI free from direct Firebase calls.
- Use `const` wherever possible.
- Extract reusable constants to `lib/core/constants/` or theme token files.
- Do not create reusable widget trees via `_build*` methods; extract widget classes.
- Prefer `StatelessWidget` for dumb/presentational UI parts.
- Keep business behavior controlled by BLoC.
- For feature-local internal subcomponents, use `part`/`part of` with private classes.

## 5) Definition of Done

- Architecture and security review completed.
- Quality gate completed:
  1. `flutter analyze`
  2. `flutter test`
  3. `dart format --set-exit-if-changed lib test`
