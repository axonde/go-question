---
paths:
  - "**/*.dart"
---

# Architecture and Patterns (Project Rules)

## Fixed Stack

- BLoC/Cubit for state
- GetIt for DI
- auto_route for routing
- Firebase for backend services
- `freezed` for immutable models/state unions when code generation is appropriate
- Custom `Result<TSuccess, TFailure>` for functional success/failure flows

Do not introduce parallel architecture tracks without explicit approval.

## BLoC/Cubit Rules (DCM-inspired)

- One bloc/cubit = one cohesive feature responsibility.
- Keep states immutable and explicit.
- Represent async lifecycle clearly: loading/success/failure.
- Avoid hidden side effects in state constructors/getters.
- Avoid bloc-to-bloc direct business coupling.
- Keep event handlers focused and readable.

## Layering Rules

- Presentation -> domain contracts -> data implementations.
- Firebase SDK usage belongs to data/core services, not widgets.
- UI must dispatch events/intents, not orchestrate repository internals.
- Repository/domain boundaries should return typed `Result`, not raw thrown errors.

## Exception and Failure Rules

- Handle exceptions explicitly at boundaries.
- Feature-specific exception types must follow app-level contracts (`AppException`/`BaseAppException`).
- Feature-specific failure types must implement `Failure<TType>`.
- Map exceptions with dedicated mapper interfaces (for example `ExceptionToFailureMapper`).

## GetIt Rules

- Register dependencies in composition root only.
- Constructor injection is preferred over service locator calls deep in widgets.

## auto_route Rules

- Route declarations stay centralized.
- Guard logic lives in guards.
- Generated router code is not edited manually.

## Local Persistence Rules

- Use `shared_preferences` for simple key-value storage.
- Use `sqflite` for structured relational local data.
- Do not introduce another local DB dependency without explicit developer approval.

## Dependency Permission Rule

- Adding or changing dependencies in `pubspec.yaml` requires explicit developer approval.

## Consistency Priority

Match existing project patterns unless a task explicitly requires a targeted exception.
When making an exception, document why.
