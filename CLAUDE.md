# Sousvite

A Flutter app (iOS, Android, web) that combines recipes, accurate nutrition, grocery lists, and a smart cooking mode.

## Read first

| Doc | What it decides |
|---|---|
| [docs/PRD.md](docs/PRD.md) | What we build and why |
| [docs/ENGINEERING.md](docs/ENGINEERING.md) | Architecture and technology. **Source of truth for tech choices** |
| [docs/DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | Tokens, components, patterns, accessibility |
| [docs/BUILD_PLAN.md](docs/BUILD_PLAN.md) | Tasks, file ownership, and the rules for parallel work |

If your change contradicts one of these docs, update the doc in the same PR. If a doc is silent, pick the documented default, say so in the PR description, and record it.

## Layout

```
apps/sousvite/            Flutter app. Features are folders in lib/features/
packages/domain/          Entities, value objects, repository interfaces. Pure Dart
packages/data/            Drift schema, DAOs, repository implementations. Pure Dart
packages/design_system/   Tokens, theme, shared widgets. Flutter only
packages/<pure>/          sync, ingredient_parser, recipe_import, nutrition, measuring
tools/usda_builder/       CLI that builds the bundled USDA SQLite file
functions/                Cloud Functions (TypeScript) and the security rules tests
firestore.rules, storage.rules   Security rules, tested in functions/test/rules/
```

This is a [pub workspace](https://dart.dev/tools/pub/workspaces): one root `pubspec.yaml`, one `pubspec.lock`, one `flutter pub get`.

## Commands

Flutter is pinned in `.fvmrc` (CI reads it). Use that version.

```sh
flutter pub get                                  # at the repo root, resolves every package
dart run build_runner build --workspace          # at the root, after changing freezed/riverpod/drift code
dart format lib test                             # in a package
flutter analyze lib test                         # in a package
very_good test --coverage --min-coverage 90 \
  --exclude-coverage "**/*.g.dart **/*.freezed.dart lib/src/tables/** lib/l10n/gen/**"
                                                 # in a package; 70 for apps/sousvite
```

Cloud Functions and security rules are a Node project in `functions/` (Node version in its `package.json`; the emulators need Java 21). In `functions/`:

```sh
npm ci                     # install
npm run lint               # ESLint, zero issues
npm run format             # Prettier (CI runs format:check)
npm run typecheck
npm test                   # builds, starts the emulators (demo-sousvite), runs Vitest with a 90% coverage gate
```

**Before you push**, in every package you touched: format, analyze with zero issues (infos count), tests pass, coverage meets the gate. At the root: `build_runner` leaves no diff, and `flutter pub get --enforce-lockfile` passes. CI checks all of this. The only required check is **CI passed**, and PRs merge automatically once it's green.

## Dart conventions

- **Lints enforce consistency.** The rules are in the root `analysis_options.yaml` (`very_good_analysis` plus extra rules, ENGINEERING.md §16). Packages include it and add only excludes and plugins. If a style rule can be a lint, turn the lint on there instead of writing the rule here. No `// ignore:` without a comment saying why.
- Use only current, non-deprecated APIs. ENGINEERING.md §16.1 is the baseline (Flutter 3.50, Dart 3.14).
- **Primary constructors everywhere** (`use_primary_constructors`). Put each field's doc comment on its parameter. Classes and enums with no constructor get an empty `()`, which the lint requires. `dart fix --apply` converts code.
  ```dart
  class const RecipeTitle({
    /// The recipe whose title this shows.
    required final RecipeId recipeId,
    super.key,
  }) extends ConsumerWidget {
  ```
- Other constructors use the concise syntax, which the lints enforce: `factory(...)`, `const new _(...)`, `const factory({...}) = _Foo;`. Run `dart fix --apply` in the package after writing code.
- Dot shorthands for enum values and static members when the context gives the type: `themeMode: .system`, `brightness == .light`. Keep the type name inside `expect(...)` and annotations.
- Import Material from `package:material_ui/material_ui.dart` (Cupertino from `package:cupertino_ui/cupertino_ui.dart`), never `package:flutter/material.dart` or `cupertino.dart` (deprecated since Flutter 3.47). `dart fix --apply --code=migrate_design_widgets` converts old code.
- Localization delegates: `[AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates]` from `material_ui`. Never import `flutter_localizations`; only the generated l10n file uses it.
- Variable font weight is `FontWeight(...)` alone (it drives the `wght` axis since 3.41). Never `FontVariation.weight`.
- Use `package:` imports, never relative imports, in `lib/`.
- Generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/gen/`, `drift_schemas/`) are committed. Never edit or hand-merge them; regenerate.
- When a package gets its first tests, add it to the matrix in `.github/workflows/ci.yml`. CI fails if you forget.

## Architecture rules

- Layers: presentation → application → domain ← data. The domain knows nothing about Flutter, Drift, or Firebase.
- Only `apps/sousvite` and `packages/design_system` depend on Flutter.
- `design_system` never depends on `domain`, Riverpod, or a feature.
- **Features are folders, not packages:** `lib/features/<name>/` with `presentation/`, `application/`, and `data/` when needed.
- **A feature's public surface is one file,** `lib/features/<name>/<name>.dart`. Other features import only that file.
- **Routes live in the feature:** `<name>_routes.dart` exposes `<Name>Routes.path`, `.routes`, and `.location(...)` when the path has parameters. `lib/app/router.dart` only composes them. Navigate with `context.go(CookingRoutes.location(id))`, never a string literal.
- External services sit behind interfaces in `lib/app/services/` with stub implementations (`SignedOutAuthService`, `FreeEntitlements`, `OfflineNutritionApi`, `DebugErrorReporter`). Real implementations replace the provider body; nothing else changes.

## Widgets: small, and rebuild only when their data changes

ENGINEERING.md §5 is the rule. In practice:

1. **One widget, one concern.** A widget that shows a recipe's title watches only the title.
2. **Pass ids down, not objects.** A list builds children from ids; each child watches its own item with a `family` provider.
3. **`select` for fields:** `ref.watch(recipeProvider(id).select((r) => r.title))`.
4. **`const` constructors** everywhere possible.
5. **No widget-returning helper methods.** Extract a widget class (private `_Foo` is fine).
6. **`ValueKey(id)` on list items,** so reordering moves widgets instead of rebuilding them.
7. **Timers and animations stay local** in their own small widget.
8. **Assert rebuild counts in widget tests** with `BuildCounter` (see Testing).

## Riverpod

- Code generation only: `@riverpod` / `@Riverpod(keepAlive: true)` with `part '<file>.g.dart';`. No hand-written providers.
- `autoDispose` (the `@riverpod` default) unless the state is app-wide: auth, settings, sync status, the database, the router.
- `ref.watch` in `build`, `ref.read` in callbacks. Never `ref.read` to get data you render.
- Riverpod is the only DI. No `get_it`, no singletons, no static mutable state.
- Repository providers are in `lib/app/providers/repositories.dart`. They throw until the data task for that repository replaces the body. UI work codes against the interface and overrides the provider with a hand-written fake in tests.
- Show `AsyncValue`s with `AsyncValueView` (`lib/shared/widgets/`), so loading and error states look the same everywhere.
- `riverpod_lint` runs as an analyzer plugin; treat its findings like any lint.

## Design system

- No raw colors, font sizes, or spacing outside `packages/design_system`. CI greps `apps/` for `Color(0x`, `fontSize:`, and `EdgeInsets.all(<number>)`.
- Colors: `context.colors.primary` (Material roles) and `context.appColors.protein` (macros, warning).
- Text: `context.textStyles.titleLarge` (Material roles) and `context.appText.numberHero` (app styles).
- Spacing, radii, motion are constants: `AppSpacing.space4`, `AppRadii.borderMd`, `AppMotion.spatialDefault`, `SpringCurve(...)`.
- Layout: `WindowSizeClass.of(context)` for compact, medium, and expanded.
- Icons: `Symbols.<name>_rounded` from `material_symbols_icons`; `fill: 1` for selected states.
- A shared widget moves into `design_system` only once two features need it, takes plain values (never entities or providers), and gets golden tests in all four schemes plus 200% text scale.

## Strings

- Every user-facing string is in `apps/sousvite/lib/l10n/arb/app_en.arb`, with an `@key` description.
- Keys are prefixed with the feature: `cooking_nextStep`. Add keys in your feature's block; never rename or remove another feature's keys.
- Read them with `context.l10n.cooking_nextStep`. Sentence case, no exclamation marks (DESIGN_SYSTEM.md §11).

## Domain and data

- Entities are `freezed` classes in `packages/domain/lib/src/entities/`, one per file, with typed ids (`RecipeId`, extension types over `String`).
- Amounts are `Quantity` (exact rational), never `double`. Ordering uses `SortKey` (fractional index strings).
- Drift tables live in `packages/data/lib/src/tables/`, one file per aggregate. Row classes are `*Row` (`RecipeRow`) so they never clash with entities.
- **No foreign keys:** sync can apply a child before its parent. Repositories keep references consistent.
- Every local write appends to `change_log` in the same transaction (ENGINEERING.md §8).
- **Schema changes:** one schema PR open at a time (BUILD_PLAN §3.3). Bump `schemaVersion`, add the migration step, run `dart run drift_dev make-migrations` in `packages/data`, and commit the snapshot and generated tests.

## Testing

- **Pure packages:** unit tests with `package:test`, 90% coverage. Prefer small hand-written fakes; use `mocktail` where a fake would be heavier than the test.
- **App:** widget tests with `pumpApp` (theme, l10n, `ProviderScope` with overrides) and `BuildCounter`, both in `apps/sousvite/test/helpers/`. 70% coverage.

  ```dart
  final builds = BuildCounter.start();
  await tester.pumpApp(const IngredientList(recipeId: id), overrides: [
    recipeRepositoryProvider.overrideWithValue(fakeRepository),
  ]);
  builds.reset();
  fakeRepository.updateAmount(lineId, Quantity(2));
  await tester.pump();
  expect(builds.ofKey(ValueKey(lineId)), 1);
  expect(builds.of<RecipeTitle>(), 0);
  ```

- **Design system:** goldens in light, dark, cooking light, cooking dark, and 200% text, plus Flutter's `meetsGuideline` checks.
- Tests mirror `lib/`: `lib/src/foo/bar.dart` is tested in `test/src/foo/bar_test.dart`.
- A file that only declares an interface starts with `// coverage:ignore-file` and a comment saying why: its empty primary constructor is the only line coverage sees, and it never runs.
- Never skip or delete a failing test to get CI green.

## Pull requests

- One task, one PR, one branch (BUILD_PLAN §3.1). Edit only the paths your task owns plus the shared files in BUILD_PLAN §3.2.
- Small, focused commits with messages that say why.
- The PR description lists any decision you made that a doc didn't cover.
