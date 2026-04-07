# Operating Principles

## Mission

Build and evolve the codebase safely, with predictable quality and architecture consistency.

EN (primary): Follow project constraints first, then optimize implementation details.
RU (secondary): Сначала соблюдаем архитектурные ограничения проекта, потом оптимизируем детали.

## Core Defaults

- Inspect code before making assumptions.
- Prefer minimal, targeted changes over wide refactoring.
- Preserve current architecture unless explicitly requested.
- Prefer existing project patterns over introducing new frameworks.

## Non-Negotiables

- Review is mandatory for every meaningful change.
- Security review is mandatory for every meaningful change.
- Do not hardcode secrets, credentials, or sensitive tokens.
- Use `const` wherever possible.
- Do not keep magic constants inline; extract them to constants/theme tokens.
- New project dependencies require explicit developer approval before editing `pubspec.yaml`.

## Strictness Behavior

- `standard` by default: balanced speed and safety.
- `strict` when risk is elevated: auth, guards, DI wiring, Firebase integration, data contracts.

## Reliability Behavior

- Never report checks as passed when they were not run.
- If blocked, report blocker + safest next step.
