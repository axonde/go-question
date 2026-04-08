---
description: Строгий алгоритм работы с ветками в рамках принятого в проекте Git Flow.
---

# Git Flow Workflow

В этом проекте используется строгий Git Flow подход. Всегда соблюдай следующие правила при работе с ветками.

## 1. Разработка новой фичи (Feature)
**Начало фичи:**
1. Нужно убедиться, что находимся в `develop` и она обновлена: `git checkout develop`, затем `git pull`.
2. Создаём ветку фичи: `git checkout -b feature/feature_name`.

**Завершение фичи:**
1. Пушим изменения: `git push origin feature/feature_name`.
2. После проверки и тестирования сливаем в `develop`.
3. Переключаемся: `git checkout develop`.
4. Сливаем: `git merge feature/feature_name`.
5. Удаляем локальную и удаленную ветку: `git branch -d feature/feature_name` и `git push origin --delete feature/feature_name`.

## 2. Подготовка Релиза (Release)
**Начало релиза:**
1. Ответвляемся от `develop`: `git checkout develop` -> `git pull`.
2. Создаём релизную ветку: `git checkout -b release/vX.X.X` (где X.X.X — версия релиз-кандидата).
3. В этой ветке производятся только багфиксы перед релизом и смена версий.

**Завершение релиза:**
1. Сливаем в `master`: `git checkout master` -> `git merge release/vX.X.X`.
2. Ставим тег: `git tag -a vX.X.X -m "Release vX.X.X"`.
3. Сливаем обратно в `develop`: `git checkout develop` -> `git merge release/vX.X.X`.
4. Удаляем ветку: `git branch -d release/vX.X.X`.

## 3. Исправление Багов в Проде (Hotfix)
**Начало исправления:**
1. Ответвляемся **СТРОГО** от `master`: `git checkout master` -> `git pull`.
2. Создаем ветку фикса: `git checkout -b hotfix/fix_name`.

**Завершение исправления:**
1. Сливаем в `develop`: `git checkout develop` -> `git merge hotfix/fix_name`.
2. Сливаем в `master`: `git checkout master` -> `git merge hotfix/fix_name`.
3. При необходимости ставим тег новой минорной версии в `master`.
4. Удаляем ветку: `git branch -d hotfix/fix_name`.
