# Sousvite: Engineering Design

| | |
|---|---|
| **Status** | Draft |
| **Owner** | Tyler |
| **Last updated** | 2026-11-13 |
| **Companion doc** | [PRD](PRD.md) |

---

## 1. Purpose

This document records the architecture and technology decisions for Sousvite, and the reasoning behind them. The PRD says *what* we build. This doc says *how*. When a decision changes, update this doc in the same pull request as the change.

Each decision is marked:

- **Decided:** chosen explicitly by Tyler.
- **Default:** the standard choice, picked during drafting and open to review.

## 2. Engineering principles

1. **Flutter everywhere.** One codebase for iOS, Android, and web. *(Decided)*
2. **Clean architecture.** Presentation, application, domain, and data layers, with dependencies pointing inward only. The domain knows nothing about Flutter, Drift, or Firebase. *(Decided)*
3. **Small, composable UI.** Screens are built from small widgets. Each widget rebuilds **only** when the data it renders changes. This is checked in tests, not just in review (see §5 and §15). *(Decided)*
4. **Offline first.** The local database is the source of truth. The UI never waits on the network to show or save data.
5. **Deterministic.** No AI or ML anywhere (PRD non-goal). Parsing, matching, and suggestions are rule-based, explainable, and testable.
6. **Small, reusable modules.** Logic lives in small pure-Dart packages with narrow public APIs and their own tests.
7. **Consistency over cleverness.** One way to do each thing (state, navigation, models, errors), enforced by lints and code review.

## 3. Decision summary

| Area | Choice | Status |
|---|---|---|
| UI framework | Flutter (iOS, Android, web) | Decided |
| Toolchain | Latest stable Flutter and Dart (3.50 and 3.14 today), pinned in `.fvmrc`; Material from `material_ui` (§16.1) | Decided |
| State management and DI | Riverpod 3 with code generation | Decided |
| Local database | Drift (SQLite; WebAssembly SQLite on web) | Decided |
| Sync model | Change log with per-field merge and hybrid logical clocks | Decided |
| Free sync transport | User's Google Drive (hidden app data folder) | PRD |
| Pro backend | Firebase: Auth, Firestore, Cloud Functions, Hosting | Decided |
| Sign-in | Optional; Google and Apple via Firebase Auth | PRD |
| USDA nutrition data | Generic foods bundled; branded foods fetched through our proxy and cached | Decided |
| Open Food Facts | Fetched online and cached | Decided |
| URL import | On device; web goes through a thin fetch proxy | Decided |
| Ingredient parsing | Our own rule-based Dart parser | Decided |
| Code structure | Pub workspace: Flutter app plus pure-Dart core packages | Decided |
| Testing | Unit (with fixtures), widget (with rebuild counts), golden, integration | Decided |
| Lints | `very_good_analysis` plus extra consistency rules in one root `analysis_options.yaml` (§16) | Decided |
| CI | GitHub Actions using `very_good_workflows`, added with the app scaffold PR | Decided |
| Mocking | `mocktail` (no code generation) | Decided |
| Routing | `go_router` | Default |
| Immutable models | `freezed` + `json_serializable` | Default |
| Subscriptions | RevenueCat (App Store, Play, web via Stripe) | Default |
| Crash and error reporting | Sentry (works on all three platforms) | Default |
| Release builds | fastlane on GitHub Actions; one Firebase project (no dev/prod split) | Decided |

## 4. Architecture

### 4.1 Layers

```
┌────────────────────────────────────────────────────────────┐
│ Presentation   widgets, screens, routes                    │
│                reads providers, never calls repositories   │
├────────────────────────────────────────────────────────────┤
│ Application    Riverpod providers / notifiers, use cases   │
│                orchestrates domain + repositories          │
├────────────────────────────────────────────────────────────┤
│ Domain         entities, value objects, repository         │
│                interfaces, pure logic (scaling, measuring, │
│                nutrition math). Pure Dart.                 │
├────────────────────────────────────────────────────────────┤
│ Data           Drift DB, repositories, sync engine,        │
│                transports (Drive, Firestore), HTTP clients │
└────────────────────────────────────────────────────────────┘
```

- Dependencies point inward. Data implements the repository interfaces that domain defines.
- Repositories expose **streams** (Drift watch queries), so every change flows to the UI automatically, whether it was made locally or arrived through sync.
- Writes go through use cases, which write to Drift **and** append to the change log in the same transaction (§7).

### 4.2 Module structure *(Decided)*

The repo is a [pub workspace](https://dart.dev/tools/pub/workspaces): one root `pubspec.yaml` lists the member packages. They share one lockfile and one `pub get`.

```
apps/
  sousvite/                Flutter app. Features as folders:
                           library, recipe, editor, import, nutrition,
                           cooking, grocery, experiments, sharing,
                           settings, account
packages/
  domain/                  Entities, value objects, repository interfaces,
                           pure logic. No Flutter, Drift, or Firebase.
  data/                    Drift schema, DAOs, repository implementations
  sync/                    Change log, hybrid logical clock, merge,
                           transports (Google Drive, Firestore)
  ingredient_parser/       "1 ½ cups rolled oats, chopped" → structured line
  recipe_import/           URL (schema.org) and Umami import/export
  nutrition/               Food matching, unit → gram conversion, totals
  measuring/               Measuring-tool decomposition, smart step text
  design_system/           Theme, tokens, shared small widgets
tools/
  usda_builder/            CLI that builds the bundled USDA SQLite file
functions/                 Firebase Cloud Functions (TypeScript)
```

Rules:

- `domain` depends on nothing in the repo. Pure packages (`ingredient_parser`, `recipe_import`, `nutrition`, `measuring`) depend only on `domain`.
- Only `apps/sousvite` depends on Flutter, except for `design_system`.
- Features are folders inside the app, not packages, to avoid glue code between them.
- Each feature folder mirrors the layers: `presentation/`, `application/`, and feature-specific `data/` when needed.

## 5. UI composition and rebuild discipline *(Decided)*

The goal is that a change to one field rebuilds only the widgets that show that field.

**Rules:**

1. **One widget, one concern.** A widget that renders a recipe's title watches only the title. A widget that shows one ingredient line watches only that line.
2. **Granular providers.** Providers are keyed by id with `family`, such as `ingredientLineProvider(lineId)`. Lists pass **ids** down, never whole objects, so a change to one item doesn't rebuild its siblings or its parent.
3. **`select()` for fields.** `ref.watch(recipeProvider(id).select((r) => r.title))` rebuilds only when the title changes.
4. **Value equality everywhere.** Entities are `freezed` classes with `==` and `hashCode`, so `select()` and Drift streams don't emit for no-op changes. Drift queries feeding providers use `distinct()`.
5. **`const` constructors** wherever possible (enforced by lints).
6. **No widget-returning helper methods.** Extract a widget class instead, so Flutter can skip rebuilding it.
7. **Keys on list items** (`ValueKey(id)`), so reordering sections and steps moves widgets rather than rebuilding them.
8. **Animations and timers stay local.** Cooking-mode timers live in their own small widget and provider, so a ticking clock doesn't rebuild the step text.

**Enforcement:** Widget tests use a small `BuildCounter` test helper to assert rebuild counts. For example, after editing one ingredient's amount, only that line's widget and the nutrition summary rebuild (§15).

## 6. State management: Riverpod 3 *(Decided)*

- Code generation (`@riverpod`) for all providers, for consistent naming and compile-time safety.
- **Repository providers** expose the data layer, and tests override them with fakes.
- **Stream providers** wrap Drift watch queries, and the UI handles `AsyncValue` loading, error, and data states consistently through a shared `AsyncValueView` widget.
- **Notifiers** hold transient UI state, such as editor drafts, the cooking-mode step index, and grocery-list selection.
- `autoDispose` is the default. Keep-alive is used only for app-wide state (auth, settings, the sync status).
- Riverpod is the only DI mechanism. No `get_it` and no global singletons.

## 7. Local data: Drift *(Decided)*

- SQLite on iOS and Android. On web, SQLite compiled to WebAssembly, stored in the Origin Private File System (falling back to IndexedDB).
- The database is the single source of truth. The UI reads only from it.
- **Full-text search** (FTS5) indexes recipe titles, ingredient names, and folder names (PRD 7.1).
- **Amounts** are exact rational numbers (numerator and denominator), not floats, so ⅓ cup × 3 is exactly 1 cup.
- **Units** (`packages/domain/lib/src/units/`): each unit belongs to a family (US volume, metric volume, US mass, metric mass, count) and counts a whole number of the family's smallest unit, so conversion within a family is exact. US to metric is approximate and always ends in **measurable rounding**: friendly cup fractions (¼, ⅓, ½, ⅔, ¾), tablespoons to ½, teaspoons to ⅛, metric to 0.5, 1, or 5 depending on size, ounces and pounds to ¼, counts to ¼ or ½. A friendly amount may be at most 5% off before rounding falls back to a smaller unit. Rounding applies only to scaled or converted amounts; unscaled amounts show as written.
- **Ordering** of sections, steps, and ingredients uses fractional index keys, so moving one item changes one row and merges cleanly during sync.
- **Migrations** are versioned with Drift's schema tooling and tested with generated schema snapshots.

### 7.1 Core entities

| Entity | Notes |
|---|---|
| `Recipe` | Title, photo ref, servings, times, notes, source URL and attribution |
| `IngredientLine` | Raw text plus parsed quantity, unit, name, preparation; sort key; optional section |
| `StepSection` | Named section ("Prep"), sort key |
| `Step` | Text, sort key, section |
| `Folder`, `FolderEntry` | Many-to-many (a recipe can be in several folders) |
| `NutritionMatch` | Ingredient line → food id, source (USDA or Open Food Facts), gram weight, user-confirmed flag |
| `Food`, `FoodNutrient`, `FoodPortion` | Bundled USDA data (read-only) plus cached branded and Open Food Facts foods |
| `RecipeVersion` | Snapshot of a recipe at a point in history |
| `Experiment` | Copy of a recipe version with change description, notes, share flag, outcome |
| `GroceryList`, `GroceryItem` | Items link back to source ingredient lines for combining |
| `MeasuringTool` | Tools the user owns (PRD 7.5) |
| `UserRecipePrefs` | Per-user serving size and units, kept separate from the recipe so joint shares don't overwrite them |
| `ChangeLog`, `SyncState` | See §8 |

The bundled USDA database ships as a separate, read-only SQLite file attached to the main database, so app updates can replace it without migrations.

## 8. Sync *(Decided)*

### 8.1 Model: a change log with per-field merge

Every local write produces **change records** in the same transaction as the write:

```
Change {
  id            unique id
  entity        "recipe" | "ingredient_line" | ...
  entityId
  field         "title" | "quantity" | "sortKey" | "_deleted" | ...
  value         JSON
  hlc           hybrid logical clock timestamp
  deviceId
  spaceId       which library or share this belongs to
}
```

- **Hybrid logical clocks (HLC)** give every change a timestamp that is ordered consistently across devices, even when their clocks disagree.
- **Merge rule:** for each `(entity, entityId, field)`, the change with the highest HLC wins. Edits to different fields never conflict. Editing a recipe's title on a phone and its steps on a laptop keeps both edits.
- **Deletes** are tombstones (`_deleted = true`), so a delete and an offline edit resolve predictably.
- **Never silently discard.** When a concurrent edit loses on a long text field (notes, step text), the losing value is kept in the recipe's history, so it can be recovered. This addresses the PRD's sync-conflict risk.
- Applying remote changes is idempotent, and the same changes arriving twice is harmless.
- **Compaction:** periodically, a snapshot of current state is written and older changes are pruned, so new devices don't replay the full history.

### 8.2 Transports

The sync engine is transport-agnostic. One interface, two implementations:

```dart
abstract interface class SyncTransport {
  Future<void> push(List<Change> changes);
  Stream<List<Change>> pull({required SyncCursor since});
  Future<void> writeSnapshot(Snapshot snapshot);
}
```

| | Google Drive (free) | Sousvite cloud (Pro) |
|---|---|---|
| Storage | Hidden `appDataFolder` in the user's Drive (`drive.appdata` scope) | Firestore |
| Layout | Append-only change files per device, plus periodic snapshot files | `spaces/{spaceId}/changes/{changeId}`, plus snapshots |
| Freshness | Poll on app open, on resume, and every few minutes while active | Realtime listener |
| Sign-in | Google only | Google or Apple |

Because both carry the same change log, **switching transports** means replaying the local state into the new transport, with nothing to convert (PRD 7.8). Both transports run against the same shared test suite (§15).

### 8.3 Spaces and sharing

- A **space** is a set of entities that sync together. Each user has a private space, and each joint share is its own space with members.
- Joint shares always live in Firestore, even for Drive-sync users (PRD 7.12).
- **Share jointly:** the recipe or folder moves into a new shared space, and membership is enforced by Firestore security rules.
- **Send a copy:** a Cloud Function writes a copy, with new ids, into the recipient's inbox, and the recipient's app imports it into their own space.
- **Leaving or deleting** a joint share removes the user from the space and keeps a local copy for the others (PRD 7.10).
- **Experiments in shared recipes** stay in the creator's private space unless "Share with others" is on, and then they move into the shared space.
- **View-only links:** a Cloud Function renders a read-only page on Firebase Hosting from a published snapshot.
- **Pro check:** a share syncs only while at least one member has Pro. The entitlement is stored server-side and enforced by rules (§9).

## 9. Backend: Firebase *(Decided)*

| Service | Use |
|---|---|
| Firebase Auth | Google and Apple sign-in. Signed-out users have no account at all. |
| Firestore | Pro change logs and snapshots, shared spaces, membership, share inbox |
| Cloud Functions | Fetch proxy for web URL import, USDA API proxy (hides the API key), send-a-copy, share links, subscription webhooks |
| Cloud Storage | Recipe photos for Pro users and shares |
| Hosting | Flutter web app and view-only recipe pages |
| App Check | Limits the proxies to our apps |

- **Security rules** are the access boundary. They're written alongside the schema and tested with the Firestore emulator.
- **Functions toolchain** *(Default)*: TypeScript on Node.js 24 (the newest Cloud Functions runtime), ES modules, `firebase-functions` v2 APIs, region `us-central1` (next to Cloud Storage) with a `maxInstances` cap set globally in `functions/src/index.ts`. Each function is a folder under `functions/src/<name>/`, exported from `index.ts` with one line. Tests mirror `src/` under `functions/test/` and use Vitest with a 90% coverage gate; rules tests live in `functions/test/rules/` and use `@firebase/rules-unit-testing`. Lints follow the Dart side's approach (§16): ESLint with `typescript-eslint`'s strict type-checked rules, snake_case file names, sorted imports, and Prettier formatting with single quotes. TypeScript stays on 6.0 until `typescript-eslint` supports 7.
- **Emulators:** tests and local runs use the `demo-sousvite` project id, so they never touch the real `sousvite` project and need no credentials. `npm test` in `functions/` builds, starts the emulators, and runs every test.
- **Subscriptions** *(Default)*: RevenueCat handles App Store, Google Play, and web (Stripe) billing, and a webhook writes the Pro entitlement to Firestore.
- **Cost control:** batched change writes, snapshots so devices don't read full histories, and listeners scoped to the spaces a user belongs to.
- Photos for Drive-sync users are stored in their Drive app folder.

## 10. Accounts and auth

- Signing in is optional. Signed out, the app runs entirely on Drift with a local device id.
- Google sign-in requests the `drive.appdata` scope only when Drive sync is turned on.
- **Signing in later** attaches the existing local data to the account and uploads it through the chosen transport (PRD 7.9).
- **Apple users** can use only Sousvite cloud sync, since Drive needs a Google account.

## 11. Nutrition *(Decided)*

### 11.1 Data sources

- **Bundled:** USDA FoodData Central *Foundation Foods* and *SR Legacy* (generic ingredients), with nutrients and household portions. `tools/usda_builder` turns the official CSV releases into a compact SQLite file, about 9 MB on disk and under 2 MB compressed (schema in `tools/usda_builder/README.md`). The file is committed to the repo as a normal file (no Git LFS) and regenerated only with the tool. On web it's downloaded once on first launch and cached.
- **Online, then cached:** USDA *Branded Foods* through our Cloud Function proxy, and Open Food Facts via its public API. Looked-up foods are saved to Drift, so recipes using them keep working offline.
- **Licensing:** USDA data is public domain. Open Food Facts data is ODbL (share-alike), so we keep attribution and keep OFF data separate from our own data.

### 11.2 Matching and math

- Matching is deterministic: normalize the ingredient name, apply a synonym table ("scallion" → "green onion"), then rank candidates by token overlap, preferring generic USDA foods.
- Every match records its source and can be changed by the user. Unmatched lines are flagged, never guessed silently (PRD 7.4).
- **Unit → grams:** weights convert directly. Volumes use the food's USDA portion data first, and a curated density table second. Counts ("2 eggs") use USDA portions.
- Totals are computed in `packages/nutrition` as pure functions: batch totals, then per serving using each user's serving size.

## 12. Ingredient parsing *(Decided)*

`packages/ingredient_parser` is a small, rule-based parser:

```
"1 ½ cups rolled oats, chopped"
  → quantity: 3/2, unit: cup, name: "rolled oats", preparation: "chopped"
```

- Handles Unicode and ASCII fractions, mixed numbers, ranges ("2–3"), metric and US units with aliases ("tbsp", "T", "Tbsp."), sizes ("1 large egg"), parentheticals ("1 (15 oz) can"), and "to taste" lines with no amount.
- Output keeps the original text, and users can correct any field (PRD 7.3).
- **Corpus testing:** a fixture file of several thousand real ingredient lines with expected results, run in CI. Every parsing bug becomes a new fixture.

## 13. Smart step text and measuring guidance

`packages/measuring` holds two pure modules:

- **Smart step text:** finds mentions of each ingredient in step text (name plus synonyms and head noun, longest match first) and inserts the scaled amount. Replacements are visible and editable (PRD risk table).
- **Measuring decomposition:** turns an amount into the fewest tools the user owns, as a small search over their cups and spoons with a rounding tolerance. For example, ¾ cup → ½ cup + ¼ cup, and 5 tsp → 1 Tbsp + 2 tsp.

## 14. Recipe import *(Decided)*

- **URL import** runs on the device in `packages/recipe_import`. It reads schema.org `Recipe` JSON-LD first, microdata second, and falls back to simple heuristics, then runs each ingredient line through the parser.
- On **web**, browsers block cross-site requests, so the page is fetched through a Cloud Function proxy that returns the HTML. Parsing still happens on the client.
- Results always open in a review screen before saving, and failures are reported by site so we can see which sites need work (PRD 10).
- **Umami import and export** live in the same package. The format is to be validated against real Umami exports early (PRD risk table).

## 15. Testing *(Decided)*

| Level | What | Tools |
|---|---|---|
| Unit | Pure packages: parser corpus, importer fixtures (saved HTML pages), nutrition math, measuring, HLC and merge, use cases with fake repositories | `package:test`, `mocktail` |
| Sync | One shared contract suite run against both transports, plus randomized multi-device merge tests that check every device converges | `package:test`, Firestore emulator |
| Widget | Behavior of each widget **and rebuild counts**, using the `BuildCounter` helper (§5) | `flutter_test` |
| Golden | Design-system widgets and key screens, in light and dark themes | `alchemist` *(Default)* |
| Integration | A few end-to-end flows: import → edit → cook → grocery list; offline edit → sync | `integration_test` |
| Database | Drift migrations against generated schema snapshots | `drift_dev` |
| Backend | Security rules and Cloud Functions | Firebase emulators, Vitest, `@firebase/rules-unit-testing` |

**Mocking** *(Decided)*: `mocktail` for mocks and stubs, since it needs no code generation. Prefer small hand-written fakes for repositories, and use `mocktail` for collaborators where a fake would be heavier than the test.

## 16. Code quality and CI

- **Lints** *(Decided)*: consistency is enforced by lints, not by convention. When a style rule can be checked by a lint, we turn the lint on instead of writing the rule down. The rules live in one root `analysis_options.yaml`: `very_good_analysis` as the base, plus `use_primary_constructors`, `migrate_design_widgets`, `prefer_expression_function_bodies`, `avoid_annotating_with_dynamic`, `use_decorated_box`, `use_if_null_to_convert_nulls_to_bools`, `prefer_void_to_null`, `unnecessary_async`, `unnecessary_await_in_return`, `avoid_futureor_void`, `unsafe_variance`, `no_dynamic_casts`, `annotate_redeclares`, `avoid_null_checks_in_equality_operators`, and `no_runtimetype_tostring`. Each package's `analysis_options.yaml` includes the root file and adds only its own excludes and plugins (`riverpod_lint` in the app). Rules left off conflict with ones `very_good_analysis` enables (`omit_obvious_property_types`, `prefer_double_quotes`, `prefer_relative_imports`, `always_specify_types`, `unnecessary_final`) or flag our design (`avoid_classes_with_only_static_members` for token classes, `one_member_abstracts` for service interfaces). An `// ignore:` always carries a comment saying why.
- **Formatting:** `dart format`, checked in CI.
- **CI** *(Decided)*: GitHub Actions, added in the app scaffold PR, built on Very Good Ventures' reusable [`very_good_workflows`](https://github.com/VeryGoodOpenSource/very_good_workflows). Every package gets a job from their `dart_package` or `flutter_package` workflow (format, analyze, tests, and a coverage gate). Our own steps add code-generation freshness checks and a web build. Mobile builds and Firebase Hosting preview deploys follow once the app runs.
- **Coverage gate** *(Default)*: 90% for the pure packages, where most logic lives, and 70% for the app, where goldens and integration tests carry part of the load. These numbers will be tuned in the scaffold PR.
- **Not used:** the Very Good CLI starter template, because it is built around Bloc and we use Riverpod.
- **Merging:** PRs merge automatically once CI is green.

### 16.1 Toolchain and language *(Decided)*

We track the latest stable Flutter and Dart and use nothing that is deprecated. The baseline, checked against the Flutter 3.41–3.50 and Dart 3.10–3.14 release notes:

- **Versions:** Flutter 3.50 with Dart 3.14, pinned in `.fvmrc` and read by CI. Every package's SDK constraint is `^3.14.0`.
- **Material and Cupertino are packages.** `package:flutter/material.dart` and `cupertino.dart` are deprecated (3.47, formally in 3.50). Import `package:material_ui/material_ui.dart` (and `package:cupertino_ui/cupertino_ui.dart` if we ever need Cupertino widgets). New `flutter create` projects do the same.
- **Localization delegates** come from `material_ui`: `[AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates]`. The legacy delegates in `flutter_localizations` are deprecated. `flutter gen-l10n` still imports `flutter_localizations` in its generated file, so the app keeps that dependency for codegen only; never import it in our code.
- **Variable fonts:** since 3.41 `FontWeight` drives a variable font's `wght` axis and takes any value from 1 to 1000. Set weight with `FontWeight` only, never `FontVariation.weight`. Other axes (Newsreader's optical size) still use `FontVariation`.
- **Constructors:** primary constructors (Dart 3.13) everywhere, enforced by `use_primary_constructors`. Each field's doc comment goes on its parameter. The lint also asks for an empty `()` on classes and enums with no constructor (static-only token classes, interfaces, Drift tables, plain enums); we accept that for one consistent rule. Other constructors (factories, private named ones) use the concise syntax (`factory(...)`, `const new _(...)`). `SpringCurve` is the one exception to `const`: it computes its `duration` once in a field initializer, so it is a non-`const` primary constructor with a commented `// ignore:`.
- **Dot shorthands** (Dart 3.10, no lint exists yet): use them for enum values and static members when the type is obvious from the context, as in `themeMode: .system` or `labelType: extended ? .none : .all`. Keep the type name where the context is `dynamic` or `Object`, such as `expect(...)` and annotations.
- **Null-aware elements:** `[?maybeItem]` instead of `if (x != null) x`.
- **Web:** `dart:js_interop` and `package:web` only; `dart:html`, `dart:js`, and `package:js` are deprecated.
- **Android:** project files match the 3.50 `flutter create` template (AGP 9.3, Gradle 9.5, Kotlin 2.4, Java 17).
- **Upgrading:** bump `.fvmrc`, run `flutter pub upgrade --major-versions`, then `dart migrate` (Dart 3.14) and `dart fix --apply` in each package, then read the release notes for breaking changes and update this section.

## 17. Other defaults *(open to review)*

| Area | Choice | Why |
|---|---|---|
| Routing | `go_router` | Official, URL-based (needed for web and share links), deep links |
| Models | `freezed` + `json_serializable` | Value equality (needed for §5), immutable copies, JSON for sync |
| Errors | Typed result values in the domain; exceptions only at layer boundaries | Predictable, testable error handling |
| Localization | ARB files with `flutter gen-l10n` and `material_ui` delegates (§16.1), English only at launch | Avoids retrofitting strings later |
| Crash reporting | Sentry | One tool across iOS, Android, and web |
| Subscriptions | RevenueCat | Handles both stores and web billing |

## 18. Open questions

1. **Umami format:** confirm the export format against real files before building import and export.
2. **Drive sync cadence:** tune the polling interval against Drive API quotas during the beta.
