---
paths:
  - "**/*.dart"
  - "**/firebase.json"
  - "**/AndroidManifest.xml"
  - "**/Info.plist"
---

# Security Rules (Project)

## Mandatory Security Review

Security review is required for all meaningful changes.

## Secrets and Credentials

- Never hardcode API keys, tokens, passwords, or private credentials.
- Keep secrets outside source code and out of VCS.
- Treat Firebase service/account material as sensitive.

## Firebase Safety

- Validate Firebase Auth assumptions before privileged actions.
- Keep Firestore/Storage access aligned with backend security rules.
- Do not trust client-only checks as the final authorization boundary.

## Input and Navigation Safety

- Validate user input at boundaries.
- Validate deep links and route arguments before acting.
- Avoid passing raw untrusted data into navigation/state transitions.

## Data Handling

- Do not log sensitive user data.
- Do not store sensitive data in plaintext local storage.
- Clear auth/session-sensitive local data on sign-out when relevant.

## Transport and Platform

- Prefer HTTPS-only communication.
- Keep mobile permissions minimal and justified.
