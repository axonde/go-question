# go-question

## Disclaimer

This is a fun, creative, non-commercial project for only and only educational (and fan content) purposes. All used images are provided by the [supercell fankit](fankit.supercell.com) and are used under their [policy](https://supercell.com/en/fan-content-policy/).

We respect Supercell's brand and warn you:

This material is unofficial and is not endorsed by Supercell. For more information see Supercell's Fan Content Policy: www.supercell.com/fan-content-policy.
---

---

Go Question is a Flutter mobile application for social event activity: profile management, friends, event discovery/creation, achievements, and notifications.

## Stack

- Flutter + Dart
- BLoC for state management
- GetIt for dependency injection
- auto_route for navigation and guards
- Firebase (Auth + Firestore)
- freezed + Result<TSuccess, TFailure> pattern for immutable/state-safe flows

## Architecture

Feature-first layout under lib/features with strict layer direction:

Presentation -> Domain contracts -> Data implementations -> Firebase/external

Core cross-cutting modules:

- config: theme, router
- core: constants, errors, shared utilities/widgets
- injection_container: DI composition root

## Main Features

- Authentication and session handling
- Profile initialization and editing
- Friends management and requests
- Event search and creation
- Notifications and unread state
- Achievements and leaderboard
- Runtime localization (EN/RU)

## Local Development

### Prerequisites

- Flutter SDK (stable)
- Dart SDK (comes with Flutter)
- Java 17
- Firebase project configuration for local app runs

### Install and run

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Quality Gate

Run in this order before merge/release:

```bash
flutter analyze
flutter test
dart format --set-exit-if-changed lib test
```

## CI and APK Build

CI workflow: [.github/workflows/ci.yml](.github/workflows/ci.yml)

The pipeline builds release APK and uploads it as artifact:

- Artifact name: go-question-apk-release
- File: build/app/outputs/flutter-apk/app-release.apk

Download latest APK artifacts from GitHub Actions:

- https://github.com/axonde/go-question/actions/workflows/ci.yml

## Repository Structure (short)

```text
lib/
	config/
	core/
	features/
	injection_container/
test/
.github/workflows/
```
