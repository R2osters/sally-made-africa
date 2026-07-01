# TravelConnect Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Scaffold the TravelConnect Flutter app skeleton — clean-architecture folders, Riverpod DI, Material 3 theming (light/dark), go_router bottom-nav shell, Supabase client bootstrap, shared Result/Failure error types, English-only i18n scaffolding.

**Architecture:** Feature-first folders under `lib/features/<feature>/{domain,data,presentation}`, shared cross-cutting code under `lib/core/`. Riverpod providers act as the DI mechanism throughout — no separate service locator.

**Tech Stack:** Flutter (stable channel), flutter_riverpod, go_router, supabase_flutter, shared_preferences, flutter_localizations + intl, flutter_lints.

## Global Constraints

- State management/DI: Riverpod only — do not add get_it, provider, or bloc.
- Supabase credentials: read via `--dart-define` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) — never hardcode or commit real values.
- Errors never throw across domain/presentation boundary — use `Result<T>` (see Task 2).
- i18n: English only for now, but strings must go through `AppLocalizations`, not raw string literals in widgets.
- Navigation: go_router `ShellRoute`, 4 tabs — Home, My Plans, History, Profile — in that order.
- Material 3 only (`useMaterial3: true`), light + dark `ColorScheme.fromSeed`.
- No feature business logic in this plan — placeholder screens only.

---

### Task 1: Create Flutter project and configure dependencies

**Files:**
- Create: `pubspec.yaml` (via `flutter create`, then edited)
- Create: `analysis_options.yaml` (via `flutter create`, uses flutter_lints)
- Modify: `.gitignore` (Flutter default is fine, verify `.env` is ignored)

**Interfaces:**
- Produces: a runnable Flutter project at repo root with package name `travelconnect`, ready for `flutter pub get`.

- [ ] **Step 1: Create the Flutter project**

Run: `flutter create --org com.travelconnect --project-name travelconnect .`
Expected: creates `lib/main.dart`, `pubspec.yaml`, platform folders (`android/`, `ios/`), `test/widget_test.dart`.

- [ ] **Step 2: Add dependencies to `pubspec.yaml`**

Edit `pubspec.yaml` dependencies section to:

```yaml
environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  flutter_riverpod: ^2.5.1
  go_router: ^14.2.0
  supabase_flutter: ^2.5.6
  shared_preferences: ^2.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  generate: true
```

- [ ] **Step 3: Enable l10n generation config**

Create `l10n.yaml` at repo root:

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

- [ ] **Step 4: Install dependencies**

Run: `flutter pub get`
Expected: `Got dependencies!` with no version-solving errors.

- [ ] **Step 5: Commit**

```bash
git init
git add pubspec.yaml pubspec.lock l10n.yaml .gitignore android ios lib test analysis_options.yaml
git commit -m "chore: scaffold flutter project with core dependencies"
```

---

### Task 2: Core error handling — `Result<T>` and `Failure`

**Files:**
- Create: `lib/core/error/failure.dart`
- Create: `lib/core/error/result.dart`
- Test: `test/core/error/result_test.dart`

**Interfaces:**
- Produces: `sealed class Failure` with subtypes `ServerFailure`, `NetworkFailure`, `CacheFailure`, `UnknownFailure`, each with a `final String message`.
- Produces: `sealed class Result<T>` with `Success<T>(T value)` and `Error<T>(Failure failure)`, plus `bool get isSuccess` and a `T? get valueOrNull` helper.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/error/result_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/failure.dart';
import 'package:travelconnect/core/error/result.dart';

void main() {
  group('Result', () {
    test('Success holds a value and isSuccess is true', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 42);
    });

    test('Error holds a failure and isSuccess is false', () {
      const result = Error<int>(ServerFailure('boom'));
      expect(result.isSuccess, isFalse);
      expect(result.valueOrNull, isNull);
      expect((result as Error<int>).failure.message, 'boom');
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/error/result_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:travelconnect/core/error/failure.dart'`

- [ ] **Step 3: Write `failure.dart`**

```dart
// lib/core/error/failure.dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
```

- [ ] **Step 4: Write `result.dart`**

```dart
// lib/core/error/result.dart
import 'failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(value: final v) => v,
        Error<T>() => null,
      };
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/core/error/result_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 6: Commit**

```bash
git add lib/core/error test/core/error
git commit -m "feat: add Result and Failure core error types"
```

---

### Task 3: Env config and Supabase client bootstrap

**Files:**
- Create: `lib/core/config/env.dart`
- Create: `lib/core/config/supabase_client.dart`
- Test: `test/core/config/env_test.dart`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: `class Env` with static `String get supabaseUrl` and `String get supabaseAnonKey`, reading from `String.fromEnvironment`.
- Produces: `final supabaseClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);` and `Future<void> initSupabase()` top-level function.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/config/env_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/config/env.dart';

void main() {
  test('Env falls back to placeholder values when dart-define not set', () {
    expect(Env.supabaseUrl, isNotEmpty);
    expect(Env.supabaseAnonKey, isNotEmpty);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/config/env_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:travelconnect/core/config/env.dart'`

- [ ] **Step 3: Write `env.dart`**

```dart
// lib/core/config/env.dart
class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://placeholder.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'placeholder-anon-key',
  );
}
```

- [ ] **Step 4: Write `supabase_client.dart`**

```dart
// lib/core/config/supabase_client.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
}

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/core/config/env_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/core/config test/core/config
git commit -m "feat: add Env config and Supabase client bootstrap"
```

---

### Task 4: Theme — light/dark ColorScheme + persisted mode provider

**Files:**
- Create: `lib/core/theme/app_theme.dart`
- Create: `lib/core/theme/theme_provider.dart`
- Test: `test/core/theme/theme_provider_test.dart`

**Interfaces:**
- Consumes: `shared_preferences` package (Task 1 dep).
- Produces: `class AppTheme { static ThemeData light(); static ThemeData dark(); }`.
- Produces: `class ThemeModeNotifier extends Notifier<ThemeMode>` with method `void setThemeMode(ThemeMode mode)`, exposed as `final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);`. Persists via key `'theme_mode'` in `SharedPreferences` (`'light'|'dark'|'system'`).

- [ ] **Step 1: Write the failing test**

```dart
// test/core/theme/theme_provider_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/core/theme/theme_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to ThemeMode.system', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('setThemeMode updates state and persists', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'dark');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/theme/theme_provider_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:travelconnect/core/theme/theme_provider.dart'`

- [ ] **Step 3: Write `app_theme.dart`**

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF0B5FFF);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
```

- [ ] **Step 4: Write `theme_provider.dart`**

```dart
// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadPersisted();
    return ThemeMode.system;
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == stored,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/core/theme/theme_provider_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 6: Commit**

```bash
git add lib/core/theme test/core/theme
git commit -m "feat: add Material 3 theme and persisted theme mode provider"
```

---

### Task 5: i18n scaffolding (English)

**Files:**
- Create: `lib/core/l10n/app_en.arb`

**Interfaces:**
- Produces: generated `AppLocalizations` class (via `flutter gen-l10n`, run automatically by `flutter pub get`/`flutter build` since `generate: true` is set in Task 1) exposing `appTitle`, `homeTab`, `myPlansTab`, `historyTab`, `profileTab`.

- [ ] **Step 1: Create the ARB file**

```json
// lib/core/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "TravelConnect",
  "@appTitle": {"description": "The application title"},
  "homeTab": "Home",
  "myPlansTab": "My Plans",
  "historyTab": "History",
  "profileTab": "Profile"
}
```

- [ ] **Step 2: Generate localizations**

Run: `flutter gen-l10n`
Expected: generates `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart` with no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/core/l10n
git commit -m "feat: scaffold English l10n strings"
```

---

### Task 6: Shared widgets — AppScaffold, LoadingIndicator, ErrorView

**Files:**
- Create: `lib/shared/widgets/loading_indicator.dart`
- Create: `lib/shared/widgets/error_view.dart`
- Create: `lib/shared/widgets/app_scaffold.dart`
- Test: `test/shared/widgets/app_scaffold_test.dart`

**Interfaces:**
- Consumes: `themeModeProvider` not needed here; consumes go_router's `StatefulNavigationShell` (passed in by router, see Task 8).
- Produces: `class LoadingIndicator extends StatelessWidget` (centered `CircularProgressIndicator`).
- Produces: `class ErrorView extends StatelessWidget` with constructor `ErrorView({required this.message, this.onRetry})`.
- Produces: `class AppScaffold extends StatelessWidget` with constructor `AppScaffold({required this.navigationShell})` where `navigationShell` is `StatefulNavigationShell`. Renders `NavigationBar` with 4 destinations (Home, My Plans, History, Profile) using Material icons `Icons.home`, `Icons.sim_card`, `Icons.receipt_long`, `Icons.person`, calling `navigationShell.goBranch(index)` on tap.

- [ ] **Step 1: Write `loading_indicator.dart`**

```dart
// lib/shared/widgets/loading_indicator.dart
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
```

- [ ] **Step 2: Write `error_view.dart`**

```dart
// lib/shared/widgets/error_view.dart
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Write `app_scaffold.dart`**

```dart
// lib/shared/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.sim_card), label: 'My Plans'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Write the widget test**

```dart
// test/shared/widgets/app_scaffold_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconnect/shared/widgets/app_scaffold.dart';

void main() {
  testWidgets('AppScaffold shows 4 nav destinations', (tester) async {
    final router = GoRouter(
      initialLocation: '/a',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              AppScaffold(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/a', builder: (c, s) => const Text('A')),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/b', builder: (c, s) => const Text('B')),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/c', builder: (c, s) => const Text('C')),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/d', builder: (c, s) => const Text('D')),
            ]),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(4));
    expect(find.text('A'), findsOneWidget);
  });
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/shared/widgets/app_scaffold_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/shared test/shared
git commit -m "feat: add AppScaffold bottom-nav shell and shared UI widgets"
```

---

### Task 7: Placeholder feature screens

**Files:**
- Create: `lib/features/home/presentation/home_screen.dart`
- Create: `lib/features/my_plans/presentation/my_plans_screen.dart`
- Create: `lib/features/history/presentation/history_screen.dart`
- Create: `lib/features/profile/presentation/profile_screen.dart`
- Create (empty, for later sub-projects): `lib/features/home/domain/.gitkeep`, `lib/features/home/data/.gitkeep`, `lib/features/my_plans/domain/.gitkeep`, `lib/features/my_plans/data/.gitkeep`, `lib/features/history/domain/.gitkeep`, `lib/features/history/data/.gitkeep`, `lib/features/profile/domain/.gitkeep`, `lib/features/profile/data/.gitkeep`

**Interfaces:**
- Produces: `class HomeScreen extends StatelessWidget`, `class MyPlansScreen extends StatelessWidget`, `class HistoryScreen extends StatelessWidget`, `class ProfileScreen extends StatelessWidget`. Each renders a centered `Text` with its own name (via `AppLocalizations` tab key from Task 5) inside a `Scaffold` with an `AppBar`.

- [ ] **Step 1: Write `home_screen.dart`**

```dart
// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home')),
    );
  }
}
```

- [ ] **Step 2: Write `my_plans_screen.dart`**

```dart
// lib/features/my_plans/presentation/my_plans_screen.dart
import 'package:flutter/material.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Plans')),
      body: const Center(child: Text('My Plans')),
    );
  }
}
```

- [ ] **Step 3: Write `history_screen.dart`**

```dart
// lib/features/history/presentation/history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History')),
    );
  }
}
```

- [ ] **Step 4: Write `profile_screen.dart`**

```dart
// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile')),
    );
  }
}
```

- [ ] **Step 5: Create placeholder domain/data folders**

Run:
```bash
mkdir -p lib/features/home/domain lib/features/home/data \
  lib/features/my_plans/domain lib/features/my_plans/data \
  lib/features/history/domain lib/features/history/data \
  lib/features/profile/domain lib/features/profile/data
touch lib/features/home/domain/.gitkeep lib/features/home/data/.gitkeep \
  lib/features/my_plans/domain/.gitkeep lib/features/my_plans/data/.gitkeep \
  lib/features/history/domain/.gitkeep lib/features/history/data/.gitkeep \
  lib/features/profile/domain/.gitkeep lib/features/profile/data/.gitkeep
```

- [ ] **Step 6: Commit**

```bash
git add lib/features
git commit -m "feat: add placeholder screens for the 4 bottom-nav features"
```

---

### Task 8: Router — go_router ShellRoute wiring

**Files:**
- Create: `lib/core/router/app_router.dart`
- Test: `test/core/router/app_router_test.dart`

**Interfaces:**
- Consumes: `AppScaffold` (Task 6), `HomeScreen`/`MyPlansScreen`/`HistoryScreen`/`ProfileScreen` (Task 7).
- Produces: `final appRouterProvider = Provider<GoRouter>((ref) => ...)` exposing a `GoRouter` with `initialLocation: '/home'` and a `StatefulShellRoute.indexedStack` with 4 branches at paths `/home`, `/my-plans`, `/history`, `/profile`, in that order. Includes a `redirect` callback stub that currently always returns `null` (TODO: wire auth guard in Auth sub-project).

- [ ] **Step 1: Write the failing test**

```dart
// test/core/router/app_router_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/router/app_router.dart';

void main() {
  testWidgets('router starts at /home', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    // go_router only parses its initial route during a real build cycle;
    // currentConfiguration stays empty until the router is pumped into a
    // widget tree. Pump it, then assert the resolved initial location.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      '/home',
    );
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:travelconnect/core/router/app_router.dart'`

- [ ] **Step 3: Write `app_router.dart`**

```dart
// lib/core/router/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/my_plans/presentation/my_plans_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // TODO(auth-subproject): guard purchase/profile routes for guests.
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/my-plans', builder: (c, s) => const MyPlansScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/history', builder: (c, s) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/profile', builder: (c, s) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/core/router test/core/router
git commit -m "feat: wire go_router ShellRoute with 4-tab bottom nav"
```

---

### Task 9: `main.dart` wiring and app boot widget test

**Files:**
- Modify: `lib/main.dart` (replace `flutter create` boilerplate entirely)
- Modify: `test/widget_test.dart` (replace `flutter create` boilerplate entirely)

**Interfaces:**
- Consumes: `initSupabase()` (Task 3), `appRouterProvider` (Task 8), `themeModeProvider`/`AppTheme` (Task 4), generated `AppLocalizations` (Task 5).
- Produces: `void main()` that calls `WidgetsFlutterBinding.ensureInitialized()`, `await initSupabase()`, then runs `ProviderScope(child: TravelConnectApp())`. Produces `class TravelConnectApp extends ConsumerWidget` building `MaterialApp.router`.

- [ ] **Step 1: Write `main.dart`**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/supabase_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const ProviderScope(child: TravelConnectApp()));
}

class TravelConnectApp extends ConsumerWidget {
  const TravelConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'TravelConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );
  }
}
```

- [ ] **Step 2: Write the app boot + tab switch test**

```dart
// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app boots on Home and switches tabs', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TravelConnectApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);

    await tester.tap(find.text('My Plans').last);
    await tester.pumpAndSettle();
    expect(find.text('My Plans'), findsWidgets);

    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();
    expect(find.text('History'), findsWidgets);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);
  });
}
```

Note: this test does not call `initSupabase()`/`main()` — it pumps `TravelConnectApp` directly, so Supabase must not be required at widget-build time. `supabaseClientProvider` is only read lazily by later sub-projects, so this holds for Foundation.

- [ ] **Step 3: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS

- [ ] **Step 4: Run the full test suite**

Run: `flutter test`
Expected: All tests pass (result.dart, env.dart, theme_provider.dart, app_scaffold.dart, app_router.dart, widget_test.dart).

- [ ] **Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: wire main.dart app shell and add boot/tab-switch test"
```

---

## Self-Review Notes

- **Spec coverage:** folder structure ✅ (Task 1,7), DI/Riverpod ✅ (all tasks), theme light/dark ✅ (Task 4), router+bottom nav ✅ (Task 6,8), Supabase bootstrap placeholder env ✅ (Task 3), error/Result type ✅ (Task 2), i18n English scaffold ✅ (Task 5), widget test ✅ (Task 9). Payment abstraction, auth, Supabase schema, push notifications explicitly deferred per spec's "Out of scope" section.
- **Type consistency checked:** `AppScaffold(navigationShell: ...)` (Task 6) matches usage in `app_router.dart` (Task 8) `builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell)`. `themeModeProvider` type `NotifierProvider<ThemeModeNotifier, ThemeMode>` (Task 4) matches `ref.watch(themeModeProvider)` returning `ThemeMode` in Task 9. `appRouterProvider` type `Provider<GoRouter>` (Task 8) matches `ref.watch(appRouterProvider)` returning `GoRouter` in Task 9.
- **No placeholders left unresolved** — the one `// TODO(auth-subproject)` in Task 8 is an intentional, explicitly-scoped hook point documented in the spec's "Out of scope" section, not a plan gap.
