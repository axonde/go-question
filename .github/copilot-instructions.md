---
paths:
  - "**/*.dart"
  - "pubspec.yaml"
  - "analysis_options.yaml"
  - "firebase.json"
---

# Copilot Instructions for go-question

## Quick Start for AI Agents

This file is the **entry point** for all AI-assisted work. Read it first, then load the full harness.

### 1. Load the Harness (in order)

1. **Root contract**: [AGENTS.md](/AGENTS.md)
2. **Harness**: [.agents/harness/harness_index.md](/.agents/harness/harness_index.md)
   - [Operating Principles](/.agents/harness/00_operating_principles.md)
   - [Architecture Guardrails](/.agents/harness/10_architecture_guardrails.md)
   - [Execution Workflow](/.agents/harness/20_execution_workflow.md)
   - [Output Contract](/.agents/harness/30_output_contract.md)
3. **Rules**: [.agents/rules/](/.agents/rules/)
   - [Coding Style](/.agents/rules/coding-style.md)
   - [Patterns](/.agents/rules/patterns.md)
   - [Testing](/.agents/rules/testing.md)
   - [Security](/.agents/rules/security.md)
   - [Git & GitHub](/.agents/rules/git-github.md)
4. **Skills** (if relevant): [.agents/skills/](/.agents/skills/)

### 2. Project Stack (TL;DR)

| Component | Choice | Why |
|-----------|--------|-----|
| **State** | BLoC + flutter_bloc | Structured, testable state |
| **DI** | GetIt | Lightweight, explicit |
| **Navigation** | auto_route | Type-safe, generated routes |
| **Data Modeling** | freezed, Result<TSuccess, TFailure> | Immutable types, functional error handling |
| **Backend** | Firebase (Auth, Firestore) | Managed backend |
| **Persistence** | shared_preferences (key-value), sqflite (relational) | Lightweight local storage |

**Architecture**: Presentation → Domain Contracts → Data Implementations → Firebase

### 3. Quality Gate (Mandatory)

Run in this order before marking as done:

```bash
flutter analyze
flutter test
dart format --set-exit-if-changed lib test
```

**Every production-ready change requires**:
- ✅ Code/architecture review
- ✅ Security review

## Key Rules at a Glance

### Non-Negotiables
- ✅ Use `const` wherever possible
- ✅ Extract magic constants to `lib/core/constants/` or `lib/config/theme/`
- ✅ Never hardcode secrets, credentials, or tokens
- ✅ New `pubspec.yaml` dependencies require explicit developer approval
- ❌ No hardcoded exceptions crossing layer boundaries; map to typed `Failure<T>`

### Dependency Direction
```
Widgets/Pages  
  ↓  
BLoC  
  ↓  
Domain Contracts (interfaces, entities, failures)  
  ↓  
Data Implementations (repositories, datasources)  
  ↓  
Firebase/External Services
```

### Feature-First Organization

```
lib/features/<feature>/
├── domain/          # Business contracts (interfaces, entities, failures)
├── data/            # Implementations (repos, datasources, mappers)
└── presentation/    # BLoC, listeners, screens
```

**Delivery order for one feature** (especially multi-developer):
1. **Domain**: Define contracts first
2. **Data**: Implement data layer
3. **Presentation**: Wire BLoC and UI

### Error Handling

- ✅ Handle exceptions explicitly at layer boundaries
- ✅ Feature exceptions must implement `AppException` or `BaseAppException`
- ✅ Feature failures must implement `Failure<TType>`
- ✅ Use mappers (e.g., `ExceptionToFailureMapper`) to convert errors

### Testing
- Red → Green → Refactor for critical paths
- Prioritize: Auth transitions, Route guards, BLoC flows, Repository mapping
- Command: `flutter test`

## Execution Checklist

When starting work:

1. **Read** AGENTS.md and this file
2. **Scan** [.agents/harness/](/.agents/harness/) in order to understand current constraints
3. **Identify** target feature(s), affected layers, and risks
4. **Execute** changes following layer-first order (domain → data → presentation)
5. **Run** quality gate: `flutter analyze`, `flutter test`, `dart format --set-exit-if-changed lib test`
6. **Review** architecture, security, and output per [Output Contract](/.agents/harness/30_output_contract.md)

## Strictness Profile

- **Default**: `standard` — balanced speed and safety
- **Escalate to `strict`** for: auth, guards, routing, DI, Firebase data model, risky refactors

## Feature-Specific Guidance

### 🔐 Auth Feature (`lib/features/auth/`)

**Strictness**: `strict` — Authentication is security-critical.

Key rules:
- All auth exceptions must map to typed failures (use `ExceptionToFailureMapper`)
- Session state must be immutable (use `freezed`)
- Never store raw tokens in plaintext local storage
- Validate Firebase Auth state before privileged actions
- Tests required: login/logout transitions, session refresh, error mapping
- Security review mandatory

See: [Quickstart: Firebase Auth Flow](#quickstart-firebase-auth-flow)

### 🚏 Routing & Guards (`lib/config/router/`)

**Strictness**: `strict` — Routing controls access and deep links.

Key rules:
- Route declarations only in `lib/config/router/router.dart`
- Route guards (`AuthGuard`, `GuestGuard`) must validate state before allowing navigation
- Deep-link arguments must be validated before use
- Guards should reject navigation silently or redirect to safe fallback, not throw
- Tests required: guard transitions, deep-link validation
- Security review mandatory

See: [.agents/rules/patterns.md](/.agents/rules/patterns.md) for guard examples

### 🧩 BLoC Feature (Any New Feature)

**Strictness**: `standard` — Apply layer-first pattern.

Key rules:
- Start with domain layer (contracts)
- Implement data layer (exception mapping)
- Finish with presentation layer (BLoC + UI)
- Use immutable state with `freezed`
- One BLoC per cohesive responsibility
- Events represent user intents, states represent data
- Map exceptions to typed failures with a mapper
- Tests required: state transitions, error paths

See: [Quickstart: Add a BLoC Feature](#quickstart-add-a-bloc-feature)

### 🔥 Firebase Integration

**Strictness**: `strict` — Backend data access is critical.

Key rules:
- All Firebase calls only in data layer (datasources, repositories)
- Exception handling mandatory at Firebase boundaries
- Do not expose raw `DocumentSnapshot` to presentation layer
- Map to immutable domain entities with mappers
- Security rules must align with client-side access patterns
- Tests required: Firebase call mocking, error handling

See: [Guide: Firebase Data Connect & Firestore](../doc/guides/firebase-data-connect.md)

## Languages

- **Primary**: English
- **Secondary**: Russian (for clarifications only)

## Git & PR Policy

- Follow [Git & GitHub Rules](/.agents/rules/git-github.md)
- Use **Conventional Commits**: `feat:`, `fix:`, `refactor:`, `test:`, `chore:`
- PR = **one logical feature/fix** from a named branch (`feat/*`, `fix/*`, etc.)
- Evidence required: Quality gate checks + architecture/security review

## Common Commands

```bash
# Fetch dependencies
flutter pub get

# Code generation (freezed, auto_route, json_serializable, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Code generation in watch mode
flutter pub run build_runner watch --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Format code
dart format lib test
dart format --set-exit-if-changed lib test  # CI-like check

# Run the app (debug)
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

## Project Structure

```
lib/
├── config/              # App theme, router, constants
│   ├── router/          # auto_route declarations
│   └── theme/           # app_colors, app_spacing, app_text_styles, ui_constants
├── core/                # Shared utilities, exceptions, failures
│   ├── constants/       # Domain constants
│   ├── exceptions/      # AppException, BaseAppException
│   ├── failures/        # Failure<T> interface
│   ├── models/          # Shared data types
│   └── utils/           # Helpers
├── features/            # Feature modules
│   ├── auth/            # Feature: Authentication
│   ├── events/          # Feature: Events
│   ├── friends/         # Feature: Friends
│   ├── home/            # Feature: Home
│   ├── profile/         # Feature: User Profile
│   ├── score/           # Feature: Scoring
│   └── settings/        # Feature: Settings
└── injection_container/ # GetIt DI setup
test/                    # Unit and widget tests
```

## Harness Principles

- **Thin AGENTS.md**: Policy root only
- **Detailed .agents/harness/**: Executable rules
- **Rules in .agents/rules/**: Coding standards and workflows
- **Skills in .agents/rules/**: Task-scoped playbooks

Code changes should follow the harness, not override it.

---

## Quickstart: Add a BLoC Feature

For a new feature inside `lib/features/<feature>/`:

1. **Domain layer** (`domain/`)
   ```
   domain/
   ├── entities/          # Immutable data models (freezed)
   ├── failures/          # Feature-specific failures (Failure<YourType>)
   ├── repositories/      # Repository interfaces
   └── usecases/          # Business logic (optional)
   ```
   
2. **Data layer** (`data/`)
   ```
   data/
   ├── datasources/       # Firebase/local storage calls
   ├── repositories/      # Repository implementations
   └── mappers/           # DTO → Entity, Exception → Failure
   ```

3. **Presentation layer** (`presentation/`)
   ```
   presentation/
   ├── bloc/              # BLoC with events/states
   ├── screens/           # UI widgets/pages
   └── widgets/           # Reusable feature components
   ```

**Minimal test coverage**: Repository mapping + BLoC state transitions + critical error paths.

See: `.agents/harness/20_execution_workflow.md` for detailed flow.

---

## Quickstart: Firebase Auth Flow

Auth feature structure:

1. **Domain** defines:
   - `User` entity (id, email, etc.)
   - `AuthRepository` interface (signUp, signIn, signOut, currentUser)
   - `AuthFailure` (invalid credentials, network error, etc.)

2. **Data** implements:
   - `FirebaseAuthDataSource` (calls firebase_auth)
   - Exception → AuthFailure mapping
   - `AuthRepositoryImpl` (wraps datasource, handles errors)

3. **Presentation** wires:
   - `AuthBloc` with events (SignIn, SignOut, CheckSession)
   - `AuthState` (authenticated, unauthenticated, loading, error)
   - Screen listeners dispatch events and respond to state

**Security checks**:
- Never store raw tokens in shared_preferences
- Use Firebase Session Cookies or in-memory token refresh
- Clear local data on sign-out
- Validate session before privileged actions

See: `test/features/auth/` for example tests.

---

## Quickstart: Add Custom Constants

Avoid magic numbers and hardcoded strings:

**Domain/business constants** → `lib/core/constants/`
```dart
// lib/core/constants/app_constants.dart
const maxRetries = 3;
const sessionTimeout = Duration(minutes: 30);
```

**UI design tokens** → `lib/config/theme/`
```dart
// lib/config/theme/app_spacing.dart
const singleSpacing = 8.0;
const doubleSpacing = 16.0;
```

Always extract before using in 2+ places.

---

## Quickstart: Map Exceptions to Failures

Pattern for data layer:

```dart
// domain/failures/my_failure.dart
sealed class MyFailure extends Failure<MyFailure> {
  const MyFailure();
  factory MyFailure.fromException(Exception e) { ... }
}

// data/mappers/exception_to_failure_mapper.dart
class ExceptionToFailureMapper {
  static MyFailure map(Exception e) => MyFailure.fromException(e);
}

// data/repositories/my_repository_impl.dart
Future<Result<MyData, MyFailure>> fetchData() async {
  try {
    final data = await datasource.getData();
    return Result.success(data);
  } catch (e) {
    return Result.failure(ExceptionToFailureMapper.map(e));
  }
}
```

Never let raw exceptions cross to BLoC/presentation.

---

**Last updated**: 2026-04-08  
**For questions**: Refer to [AGENTS.md](/AGENTS.md) and harness files above.
