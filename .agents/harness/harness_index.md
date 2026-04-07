# Harness Index

This directory contains the universal runtime harness for this project.
It is model-agnostic and designed for mixed-model teams.

## Load Order

1. `./00_operating_principles.md`
2. `./10_architecture_guardrails.md`
3. `./20_execution_workflow.md`
4. `./30_output_contract.md`
5. `../rules/coding-style.md`
6. `../rules/patterns.md`
7. `../rules/testing.md`
8. `../rules/security.md`
9. `../rules/git-github.md`

## Strictness Profile

- Default profile: `standard`
- Escalate to `strict` for auth, security, routing, Firebase data model changes, or risky refactors.

## Runtime Intent

- Keep AGENTS thin.
- Keep executable policy here.
- Keep task-scoped implementation playbooks in `../skills/*`.
