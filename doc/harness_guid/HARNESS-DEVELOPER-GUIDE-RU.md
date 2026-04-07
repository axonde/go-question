# Руководство Для Разработчиков Harness (go-question)

Этот документ описывает, как команде работать с harness при использовании любой модели.

## 1) Точки Входа Harness

- `AGENTS.md` (корневой короткий контракт)
- `.agents/harness/harness_index.md` (канонический порядок загрузки runtime)
- `.agents/rules/*` (обязательные правила)
- `.agents/skills/*` (playbook-и под конкретные задачи)

Базовая архитектура:

- Flutter + Dart
- BLoC + GetIt + auto_route + Firebase
- `freezed` для immutable/codegen моделей
- кастомный `Result<TSuccess, TFailure>` для функционального потока успех/ошибка

## 2) Bootstrap-Промпт Для Ввода Модели В Контекст

Используйте в начале новой сессии:

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

## 4) Workflow По Фиче (Самое Важное)

Для одной фичи порядок реализации обязателен:

1. Domain слой
- определить/уточнить entities, интерфейсы репозиториев, типы failures и result-контракты
- сначала зафиксировать бизнес-контракты

2. Data слой
- реализовать datasource + repository по контрактам domain
- добавить явный маппинг exception -> failure
- при необходимости локального хранения использовать `shared_preferences` или `sqflite`

3. Presentation слой
- реализовать BLoC/Cubit на готовых domain/data контрактах
- подключить bloc к уже сверстанному экрану
- если экрана нет, сделать минимальный каркас страницы и подключить bloc-flow

## 5) Режим Нескольких Разработчиков На Одной Фиче

Если над фичей работают несколько разработчиков, делите ответственность по слоям:

- Разработчик A: domain
- Разработчик B: data
- Разработчик C: presentation

Правила:

- порядок передачи работ: `domain -> data -> presentation`
- финальная интеграция presentation стартует только после согласованных domain-контрактов
- владелец каждого слоя держит интерфейсы явными и стабильными

## 6) Стандартный Workflow (End-to-End)

1. Загрузить контекст из `AGENTS.md` + `.agents/harness/harness_index.md`.
2. Определить scope и затронутые слои.
3. Спланировать минимальный безопасный набор изменений.
4. Применить TDD для критичных кейсов (RED -> GREEN -> REFACTOR).
5. Внести изменения с соблюдением архитектурных границ.
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

## 7) Git и GitHub Workflow

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

### Требования К Коммитам

- Один коммит = одна цель.
- Коммиты должны быть небольшими/средними и удобными для review.
- Откат одного последнего коммита не должен ломать несвязанное поведение.
- WIP-коммиты допустимы для больших задач, но перед merge история должна быть очищена.
- Изменение зависимостей в `pubspec.yaml` только с явного согласия разработчика.

### Требования К PR

- Предпочтительно один PR = одна цельная фича/фикс.
- Не дробить одну фичу на много PR без причины.
- PR должен идти из именованной ветки.
- Использовать шаблон: `.github/pull_request_template.md`.

## 8) Контроль Контекста На Длинных Задачах

Если модель начинает уходить от правил:

1. Попросите ее заново перечислить активные ограничения из `AGENTS.md` и `.agents/harness/harness_index.md`.
2. Попросите перечислить изменяемые файлы и причину каждого изменения.
3. Попросите продолжить с минимальной поверхностью правок.

Reset prompt:

```text
Pause and realign with repository harness.
Restate active constraints and quality gate.
Then continue with minimal, architecture-safe edits only.
```

## 9) Definition of Done

Задача считается завершенной только если:

- целевое поведение реализовано
- архитектурный контракт сохранен
- security review выполнен
- результаты quality gate честно отражены
- история коммитов цельная и rollback-safe
- PR соответствует одной логической фиче/фиксу

## 10) Ежедневный Короткий Чеклист

- Контекст загружен?
- Scope понятен?
- Критичные тесты обновлены?
- Analyze/test/format выполнены?
- Коммиты чистые и в Conventional формате?
- PR цельный и из именованной ветки?
