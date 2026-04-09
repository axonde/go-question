# Onboarding Feature

## Overview
This feature handles the first-time user experience by showing a series of onboarding slides. It tracks whether the onboarding has been completed using local storage to ensure it's only shown once per device.

## Architecture
Following Clean Architecture:
- **Domain**: Entities and repository interfaces for onboarding status.
- **Data**: Implementation of the repository using `shared_preferences`.
- **Presentation**: `OnboardingBloc` and UI slides.

## Logic
- Onboarding is required if `is_onboarding_completed` is not found or `false` in local storage.
- It intercepts the Auth flow if not completed.

## TDD Status
- [ ] Domain Layer Tests
- [ ] Data Layer Tests
- [ ] Presentation Layer Tests
