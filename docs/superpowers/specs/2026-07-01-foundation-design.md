# TravelConnect — Foundation Sub-Project Design

Date: 2026-07-01
Scope: first of 6 sub-projects (Foundation, Auth, Catalog, Purchase, Notifications/History, Admin-ready DB). This spec covers **Foundation only**.

## Goal

Scaffold production-grade Flutter app skeleton: clean architecture folders, DI via Riverpod, Material 3 theming (light/dark), go_router navigation shell with 4-tab bottom nav, Supabase client bootstrap (placeholder env), shared error/result handling, i18n scaffolding (English only for now).

No feature logic yet — placeholder screens only. This is the substrate everything else builds on.

## Decisions (locked from brainstorming)

- State management / DI: **Riverpod** (flutter_riverpod). No separate DI container — Riverpod providers are DI.
- Payments: out of scope for this sub-project; interface comes in Purchase sub-project.
- Supabase creds: **placeholder**, read via `--dart-define` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`). Real values supplied later, not committed.
- i18n: scaffolded now via `flutter_localizations` + `intl`, English strings only. Structure ready for French (target market is largely francophone: Togo, Benin, Ivory Coast, Senegal, Burkina Faso, Mali).
- Router: **go_router**, `ShellRoute` for bottom-nav persistence across tab switches.
- Error handling: custom sealed `Result<T>` type (no external functional-programming dep like fpdart) — success/failure without exceptions crossing layer boundaries.

## Folder structure

```
lib/
  main.dart
  core/
    config/
      env.dart                 # reads --dart-define values
      supabase_client.dart      # Supabase.initialize + provider
    router/
      app_router.dart           # go_router config, ShellRoute, 4 tab routes
    theme/
      app_theme.dart            # ColorScheme.fromSeed light+dark
      theme_provider.dart       # Riverpod StateNotifier, persisted via shared_preferences
    error/
      failure.dart              # sealed Failure classes (ServerFailure, NetworkFailure, CacheFailure, UnknownFailure)
      result.dart                # sealed Result<T> { Success<T>, Error<T> }
    l10n/
      app_en.arb
      (generated l10n via flutter gen-l10n)
    constants/
      app_constants.dart
  features/
    home/
      presentation/
        home_screen.dart
    my_plans/
      presentation/
        my_plans_screen.dart
    history/
      presentation/
        history_screen.dart
    profile/
      presentation/
        profile_screen.dart
  shared/
    widgets/
      app_scaffold.dart          # bottom nav shell widget
      loading_indicator.dart
      error_view.dart
test/
  widget_test.dart               # app boots, bottom nav switches tabs
```

Each feature directory pre-creates `domain/`, `data/`, `presentation/` subfolders (even if only `presentation/` has content now) so later sub-projects drop straight into the existing pattern without restructuring.

## Dependencies (pubspec.yaml)

- flutter_riverpod
- go_router
- supabase_flutter
- shared_preferences
- flutter_localizations (sdk), intl
- dev: flutter_test, flutter_lints

## Theme

- Material 3, `ColorScheme.fromSeed(seedColor: ...)` for both brightness modes
- Theme mode (light/dark/system) persisted in `shared_preferences`, exposed via Riverpod `StateNotifierProvider`, toggle wired later in Profile screen

## Navigation

- `ShellRoute` wraps 4 tab branches: Home, My Plans, History, Profile
- `NavigationBar` (Material 3) in `AppScaffold`
- Auth-gated redirect logic stubbed as a TODO hook point in `app_router.dart` (real guard added in Auth sub-project)

## Error handling pattern

```dart
sealed class Result<T> {}
class Success<T> extends Result<T> { final T value; }
class Error<T> extends Result<T> { final Failure failure; }
```
Repositories (added in later sub-projects) return `Future<Result<T>>` — no throwing across the domain/presentation boundary.

## Testing

- One widget test: app launches, all 4 tabs render and switch correctly.

## Out of scope (deferred to later sub-projects)

- Auth screens/logic, Supabase auth wiring
- Country/operator/plan data + Supabase schema
- Payment service abstraction
- Push notifications
- Real i18n translations beyond English
- Admin dashboard
