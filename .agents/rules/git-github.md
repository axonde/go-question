---
paths:
  - "**/*"
---

# Git and GitHub Rules

## Commit Standard

Use Conventional Commits for all non-WIP commits.

Format:

`<type>(<optional-scope>): <short imperative summary>`

Examples:

- `feat(auth): add email verification retry flow`
- `fix(router): prevent redirect loop for guest guard`
- `refactor(theme): extract repeated spacing constants`
- `test(auth): add regression for sign-out failure mapping`

Recommended types:

- `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `ci`, `build`

## Commit Quality and Size

- Commits must be logically cohesive (one clear intent per commit).
- Commits should be small-to-medium and reviewable.
- Prefer incremental atomic commits over large mixed commits.
- A simple rollback of one commit should not break the codebase.

Exception:

- Large tasks may contain temporary `WIP` commits during implementation.
- Before merge, prefer squashing/reordering into clean logical commits.

## Rollback Safety

Before finalizing a non-WIP commit, ensure the change is safe to revert independently:

- no hidden dependency on unstaged local changes
- no partial migration step without pair step
- no mixed refactor + feature + unrelated formatting in one commit

## Branch Naming

Each PR must come from a named branch, not from `main`.

Branch format:

`<type>/<short-kebab-description>`

Examples:

- `feat/auth-email-verification`
- `fix/profile-immutable-fields`
- `refactor/home-events-layout`

## PR Scope Policy

- Prefer one PR = one complete logical feature/fix.
- Avoid fragmented PRs that split one feature without reason.
- PR may include multiple commits, but all must support one coherent result.

## PR Description Standard

Every PR description must include:

1. Goal and scope (what was changed and why)
2. Architectural impact (if any)
3. Test evidence (`flutter analyze`, `flutter test`, `dart format --set-exit-if-changed lib test`)
4. Risk and rollback notes
5. Screenshots/video for UI changes (if applicable)

## Review Readiness

PR is review-ready only when:

- commit history is readable and coherent
- no obvious mixed concerns
- required quality gates are reported
- security-sensitive changes are explicitly called out
