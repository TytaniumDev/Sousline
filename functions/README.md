# Sousvite Cloud Functions

Cloud Functions for Sousvite and the tests for `firestore.rules` and
`storage.rules`. Decisions are in [ENGINEERING.md §9](../docs/ENGINEERING.md#9-backend-firebase-decided).

## Layout

```
src/index.ts         Global options, and one export line per function
src/<name>/          One folder per function (fetch_proxy, usda_proxy, ...)
test/<name>/         Tests mirror src/
test/rules/          Security rules tests
test/helpers/        Shared test setup
```

## Running

Needs Node 24 and Java 21 (for the Firestore and Storage emulators).

```sh
npm ci
npm test            # build, start the emulators, run every test with coverage
npm run emulators   # build and start the emulators with the UI, for manual testing
npm run lint
npm run format
npm run typecheck
```

Tests and local runs use the `demo-sousvite` project id, which the emulators
treat as offline-only: nothing reaches the real `sousvite` project.
