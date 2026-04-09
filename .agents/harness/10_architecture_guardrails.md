# Architecture Guardrails

## Fixed Project Architecture

The architecture is fixed and must be preserved:

- State: `BLoC`
- DI: `GetIt`
- Navigation: `auto_route`
- Backend/infra: `Firebase`
- Modeling: `freezed` for immutable data/state unions where code generation is needed
- Functional flow: custom `Result<TSuccess, TFailure>` as primary success/failure transport

## Dependency Direction

Keep this dependency direction:

`UI/Widgets -> Bloc -> Domain contracts -> Data implementations -> Firebase/External`

Do not create reverse dependencies.

## Layer Rules

- Presentation layer contains widgets, pages, bloc, listeners.
- Domain contracts (interfaces, failures, entities) stay framework-light.
- Data layer owns Firebase SDK calls and DTO mapping.
- UI must not call Firebase SDK directly.
- Bloc must not depend directly on other Bloc instances for business flows; share repositories/services instead.
- Do not propagate raw exceptions into UI states; map exceptions to typed failures and return `Result`.
- Widget classes should stay presentational; BLoC owns business state and transitions.
- Do not compose reusable widget blocks via `_build*` widget methods; use widget classes.

## Multi-Developer Feature Rule

When several developers work on one feature, split by layers with explicit ownership:

- Domain owner defines contracts first (`entities`, repository interfaces, failures, result contracts).
- Data owner implements contracts second (datasources, repository impl, exception-to-failure mapping).
- Presentation owner finishes third (pure bloc only, then screen integration).

The implementation order is mandatory: `domain -> data -> presentation`.
Parallel work is allowed only after domain contracts are agreed and stable.

## Error and Failure Contracts

- Exception handling is mandatory at layer boundaries (data/repository/bloc handlers).
- Feature-level custom exceptions must implement the app exception contract (`AppException`) directly or via `BaseAppException`.
- Feature-level custom failures must implement the shared failure interface (`Failure<TType>`).
- Use feature mappers (for example `ExceptionToFailureMapper`) to convert errors into feature failures.

## Functional Style Contract

- Prefer pure transformations and explicit data flow.
- Prefer `Result` + `fold`/`foldAsync` over control flow by thrown exceptions across layers.
- Keep side effects isolated to infrastructure/data boundaries.

## DI Rules (GetIt)

- Register dependencies at composition root (`lib/injection_container/injection_container.dart`).
- Avoid ad-hoc registrations inside feature code.
- Prefer constructor injection.

## Routing Rules (auto_route)

- Route declarations live in `lib/config/router/router.dart`.
- Generated route files (`*.gr.dart`) are never edited manually.
- Access control stays in guards (`AuthGuard`, `GuestGuard`), not in random UI branches.

## Constants and Tokens

- Do not keep reusable constants inline in feature code.
- Put business/domain constants in `lib/core/constants/`.
- Put UI tokens in `lib/config/theme/` (`app_colors`, `app_spacing`, `app_text_styles`, `ui_constants`).

## Local Storage Policy

- For simple key-value persistence, use `shared_preferences`.
- For relational/structured offline storage, use `sqflite`.
- Choose the smallest persistence mechanism that satisfies feature requirements.

## BLoC Rules (DCM-aligned recommendations)

- Keep state immutable.
- Keep events and state transitions explicit and deterministic.
- Model loading/success/failure paths explicitly.
- Avoid boolean-flag state soup when state variants are clearer.
- Keep event handlers focused; extract logic when handlers become large.

## Feature-Local UI Composition Pattern

For a logically single feature component that has internal subparts:

- Place the root component in `widgets/<component_name>.dart`.
- Place internal subparts in `widgets/components/*.dart`.
- Wire files through `part` in root and `part of` in subfiles.
- Keep internal subpart classes private (`_ComponentPart`) when they are not reused outside that component.
