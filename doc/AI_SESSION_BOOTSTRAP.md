# AI Session Bootstrap Template for go-question

> **Copy this template into a new Copilot/Claude conversation at the start of a coding session to establish context and constraints.**

---

## Setup Instructions

### Step 1: Paste This Prompt into a New Conversation

```text
I'm working in the go-question repository (Flutter + Dart, BLoC + Firebase architecture).

Please load the project governance and constraints:

1. Read .github/copilot-instructions.md (this is the entry point)
2. Load AGENTS.md
3. Scan .agents/harness/harness_index.md and follow its load order:
   - .agents/harness/00_operating_principles.md
   - .agents/harness/10_architecture_guardrails.md
   - .agents/harness/20_execution_workflow.md
   - .agents/harness/30_output_contract.md
4. Scan .agents/rules/ for all 5 rule files (coding-style, patterns, testing, security, git-github)
5. If the task involves specific skills, load from .agents/skills/

Before telling me you're ready, summarize:
- Active architecture constraints (what stack + patterns I must preserve)
- Quality gate (the 3 mandatory checks I must run)
- Strictness profile (when to escalate to strict mode)
- Git/PR policy (branch naming, commit style, PR structure)

Then confirm you're ready to assist with go-question work.
```

### Step 2: Verify Understanding

The AI should confirm by summarizing:

✅ **Architecture**: BLoC + GetIt + auto_route + Firebase, freezed, custom Result pattern  
✅ **Quality Gate**: `flutter analyze`, `flutter test`, `dart format --set-exit-if-changed lib test`  
✅ **Strictness**: Default=standard, escalate to strict for auth/guards/routing/DI/Firebase/risky refactors  
✅ **Git Policy**: Conventional Commits, feature branches (feat/*, fix/*), one PR = one logical change  

---

## Task Input Template

Once the AI has loaded the harness, provide your task using this structure:

```text
Task: <what you want to build or fix>

Context:
- Feature/module: <which feature the task touches>
- Problem or goal: <clear objective>
- Related files/patterns: <if known>

Constraints:
- Architecture must remain: BLoC + GetIt + auto_route + Firebase
- Follow layer-first delivery: domain → data → presentation (if applicable)
- Use Result<Success, Failure> for error handling
- Extract all constants to lib/core/constants/ or lib/config/theme/
- Use const wherever possible
- No hardcoded secrets/credentials
- Dependencies require explicit approval before pubspec.yaml edits

Definition of Done:
- Behavior: <what the user will observe>
- Tests: <critical paths to test>
- Quality gate: all 3 checks passing

Output needed:
- Files changed
- Risks/assumptions
- Suggested conventional commit title(s)
- If applicable: screenshot or behavior description
```

---

## Example: Add a New BLoC Feature

Here's a concrete task setup:

```text
Task: Add a "Friends List" feature to display connected users

Context:
- Feature: friends (new module under lib/features/friends/)
- Goal: Users can view their list of friends with basic info (name, status)
- Related: Uses existing User entity from auth feature, Firebase Firestore

Constraints:
- Standard strictness (no auth/routing involved yet)
- Layer-first: domain → data → presentation
- Must use BLoC + freezed state
- Map Firestore exceptions to typed failures
- End-to-end tests for happy path + error case

Definition of Done:
- Users can navigate to friends screen
- Screen displays a paginated list of friends
- Error states show retry button
- BLoC tests cover state transitions and error mapping
- Repository tests verify Firestore call + exception mapping

Quality Gate:
- flutter analyze passes
- flutter test passes (new + modified tests)
- dart format passes
```

---

## Common Session Commands

Once in a session, you can ask the AI to:

- **Run the quality gate**: "Run the quality gate: flutter analyze, flutter test, dart format --set-exit-if-changed lib test"
- **Explain a pattern**: "Show me how exception mapping works in this codebase"
- **Generate a file**: "Create the domain layer for a new feature called notifications"
- **Review architecture**: "Does this design follow the harness constraints?"
- **Suggest commits**: "What Conventional Commits should I use for these changes?"
- **Test critical paths**: "Write BLoC tests for the auth flow"

---

## Quick Reference: Key Files

| File | Purpose |
|------|---------|
| `.github/copilot-instructions.md` | AI entry point + quickstarts |
| `AGENTS.md` | Thin root contract |
| `.agents/harness/harness_index.md` | Load order for harness system |
| `.agents/harness/00_operating_principles.md` | Mission, core defaults, non-negotiables |
| `.agents/harness/10_architecture_guardrails.md` | Fixed stack, dependency direction, layer rules |
| `.agents/harness/20_execution_workflow.md` | Step-by-step execution sequence |
| `.agents/harness/30_output_contract.md` | Response structure and reporting |
| `.agents/rules/coding-style.md` | Dart/Flutter style, const rules, constants policy |
| `.agents/rules/patterns.md` | BLoC, DI, routing, error handling patterns |
| `.agents/rules/testing.md` | Testing policy, critical paths, command |
| `.agents/rules/security.md` | Secrets, Firebase safety, input validation |
| `.agents/rules/git-github.md` | Conventional Commits, branch naming, PR policy |

---

## Strictness Escala Flow

When you encounter work that involves **strictness escalation**, the AI will shift to `strict` mode:

| ✅ Standard (default) | 🔴 Escalate to Strict |
|---|---|
| Features, new BLoC, layouts | **Auth flows** |
| Data model changes | **Route guards** |
| Business logic | **DI wiring** |
| State transitions | **Firebase data contracts** |
| | **Risky refactors** |

In strict mode, the AI will:
- Ask clarifying questions upfront
- Require explicit tests for all paths
- Flag security risks immediately
- Require manual security review before shipping

---

## Examples in Codebase

- **BLoC pattern**: `lib/features/auth/presentation/bloc/`
- **Domain contract**: `lib/features/auth/domain/`
- **Data layer**: `lib/features/auth/data/`
- **Exception mapping**: See `lib/features/auth/data/mappers/`
- **Tests**: `test/features/auth/`

---

**Last updated**: 2026-04-08  
**For debug**: Check that terminal cwd is the project root before running commands.
