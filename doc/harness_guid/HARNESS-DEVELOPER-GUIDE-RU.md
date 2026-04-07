# Руководство Для Разработчиков (RU Version)

Этот раздел дублирует правила на русском языке для ежедневной работы команды.

## 1) Что Такое Harness В Этом Проекте

В проекте используется тонкий корневой контракт и подробные правила в `.agents/*`.

Точки входа:

- `AGENTS.md` (корневой короткий контракт)
- `.agents/harness/harness_index.md` (канонический порядок загрузки)
- `.agents/rules/*` (обязательные проектные правила)
- `.agents/skills/*` (task-scoped playbook'и)

Архитектурный контракт:

- Flutter + Dart
- BLoC + GetIt + auto_route + Firebase
- `freezed` для immutable/codegen моделей и union-состояний
- Функциональный стиль с кастомным `Result<TSuccess, TFailure>`

## 2) Как Вводить Модель В Контекст Сессии

Используйте этот текст в начале новой сессии:

```text
Read and follow AGENTS.md in this repository.
Then load and apply rules from:
1) .agents/harness/harness_index.md
2) .agents/harness/* in listed order
3) .agents/rules/*
4) .agents/skills/* only if relevant

Before editing, summarize:
- active architecture constraints
- quality gate
- git/PR policy
Then execute task changes accordingly.
```

Смысл: модель сначала читает обязательные правила, коротко подтверждает ограничения и только потом редактирует код.

## 3) Шаблон Постановки Задачи Для Модели

```text
Task:
Context:
- Feature/module:
- Problem or goal:
- Related files:
Constraints:
- Keep architecture: BLoC + GetIt + auto_route + Firebase
- Follow constants policy (no magic constants)
- Use const where possible
- Keep functional flow: Result-based success/failure handling
- Handle exceptions explicitly and map to typed failures
- Feature custom exceptions/failures must implement shared interfaces
Definition of done:
- Behavioral result:
- Tests to add/update (critical-path TDD):
- Quality gate required: flutter analyze, flutter test, dart format --set-exit-if-changed lib test
Output needed:
- Files changed
- Risks/assumptions
- Suggested commit title(s) in Conventional Commits format
```

## 4) Стандартный Workflow (От Задачи До PR)

1. Загрузить контекст из `AGENTS.md` и `.agents/harness/harness_index.md`.
2. Определить scope и затронутые слои.
3. Составить минимальный безопасный набор изменений.
4. Применить TDD для критичных кейсов (RED -> GREEN -> REFACTOR).
5. Внести изменения, не нарушая архитектурные границы.
6. Выполнить обязательный review-фокус:
   - архитектурная согласованность
   - корректность логики
   - соответствие текущей кодовой базе
   - security review
7. Прогнать quality gate:
   - `flutter analyze`
   - `flutter test`
   - `dart format --set-exit-if-changed lib test`
8. Подготовить чистый набор коммитов (Conventional Commits, логически цельные, rollback-safe).
9. Открыть один логический PR из именованной ветки.

## 5) Git и GitHub Workflow

Источник правил: `.agents/rules/git-github.md`

### Именование Веток

Используйте именованные ветки (не `main`):

- `feat/<short-kebab-description>`
- `fix/<short-kebab-description>`
- `refactor/<short-kebab-description>`
- `test/<short-kebab-description>`
- `chore/<short-kebab-description>`

### Именование Коммитов (Conventional Commits)

Формат:

`<type>(<optional-scope>): <short imperative summary>`

Примеры:

- `feat(auth): add email verification resend cooldown`
- `fix(profile): make profile widget immutable`
- `refactor(theme): move repeated spacing to ui constants`
- `test(auth): add regression for sign out state reset`

### Требования К Коммитам

- Один коммит = одна цель.
- Коммиты должны быть небольшими/средними и удобными для review.
- Откат одного последнего коммита не должен ломать несвязанное поведение.
- WIP-коммиты допустимы для больших задач, но перед merge история должна быть приведена в чистый вид.
- Изменение зависимостей в `pubspec.yaml` только с явного согласия разработчика.

### Требования К PR

- Предпочтительно один PR = одна цельная фича/фикс.
- Не дробить одну фичу на много PR без причины.
- PR должен идти из именованной ветки.
- Использовать шаблон: `.github/pull_request_template.md`.

PR должен содержать:

- scope и результат
- архитектурное влияние
- evidence по quality gate
- security-заметки
- rollback-заметки
- UI-материалы (если применимо)

## 6) Контроль Контекста На Длинных Задачах

Если модель начинает «плыть» по контексту:

1. Попросите ее заново перечислить активные ограничения из `AGENTS.md` и `.agents/harness/harness_index.md`.
2. Попросите перечислить изменяемые файлы и причину каждого изменения.
3. Попросите продолжить с минимальной поверхностью правок.

Reset prompt:

```text
Pause and realign with repository harness.
Restate active constraints and quality gate.
Then continue with minimal, architecture-safe edits only.
```

## 7) Definition of Done

Задача считается завершенной только если:

- целевое поведение реализовано
- архитектурный контракт сохранен
- security review выполнен
- результаты quality gate честно отражены
- история коммитов цельная и rollback-safe
- PR соответствует одной логической фиче/фиксу

## 8) Ежедневный Короткий Чеклист

- Контекст загружен?
- Scope понятен?
- Критичные тесты обновлены?
- Analyze/test/format выполнены?
- Коммиты чистые и в Conventional формате?
- PR цельный и из именованной ветки?
