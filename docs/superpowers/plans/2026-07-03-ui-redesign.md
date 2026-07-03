# Refonte UI / Design System — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remplacer les écrans placeholder par une vraie interface : design system orange chaud + Google Fonts, bottom-nav pill flottante animée, 4 tabs avec mock data, écrans Auth UI-only.

**Architecture:** Feature-first existante conservée (`lib/features/<f>/{domain,data,presentation}`, transverse `lib/core/`, partagé `lib/shared/`). Le thème pousse le style dans `ThemeData` (component themes) ; les écrans consomment des widgets partagés et des mocks locaux par feature. Animations via `flutter_animate` (effets finis, compatibles `pumpAndSettle`).

**Tech Stack:** Flutter 3.24.4 / Dart 3.5.4, Riverpod, go_router (`StatefulShellRoute.indexedStack` inchangé), `google_fonts`, `flutter_animate`, l10n gen (`app_en.arb`).

## Global Constraints

- Spec : `docs/superpowers/specs/2026-07-03-ui-redesign-design.md`.
- Seed couleur : `#FF6B35`. Police : Plus Jakarta Sans. Durées animation : 200–400 ms.
- Les 8 tests existants DOIVENT rester verts. Les labels de nav (`Home`, `My Plans`, `History`, `Profile`) doivent rester visibles en permanence dans la bottom bar (les tests tapent dessus).
- Contrat routes inchangé : `/home`, `/my-plans`, `/history`, `/profile` dans `StatefulShellRoute.indexedStack`. Nouvelles routes auth : `/auth`, `/auth/login`, `/auth/signup` HORS shell.
- Aucune logique Supabase Auth. Submit auth = `context.go('/home')`.
- Pas de `ShimmerBox` monté par défaut dans un écran (animation infinie casse `pumpAndSettle`).
- i18n : toute string UI passe par `AppLocalizations` (clés dans `lib/core/l10n/app_en.arb`, anglais). Régénérer avec `flutter gen-l10n` après édition de l'arb.
- Windows : si une commande flutter échoue sur artefact engine manquant → `flutter precache --windows` d'abord.
- Commits fréquents, messages conventional commits, sur la branche courante `assistant/funny-lovelace-c7cd91`.

---

### Task 1: Dépendances + tokens spacing/radius

**Files:**
- Modify: `pubspec.yaml` (bloc `dependencies`)
- Create: `lib/core/theme/app_spacing.dart`

**Interfaces:**
- Produces: constantes `AppSpacing.xs/sm/md/lg/xl/xxl` (double), `AppRadius.sm/md/lg/pill` (double) — utilisées par toutes les tâches suivantes.

- [ ] **Step 1: Ajouter les dépendances**

Dans `pubspec.yaml`, sous `dependencies:` (après `shared_preferences: ^2.2.3`), ajouter :

```yaml
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
```

- [ ] **Step 2: Créer les tokens**

```dart
// lib/core/theme/app_spacing.dart
/// Design tokens — spacing and corner radii. No magic numbers in screens.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double pill = 34;
}
```

- [ ] **Step 3: Vérifier**

Run: `flutter pub get` → succès, puis `flutter analyze` → `No issues found!` (le lint `unnecessary_cast` info existant dans `result_test.dart` est toléré).

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/theme/app_spacing.dart
git commit -m "feat(theme): add google_fonts + flutter_animate deps and spacing tokens"
```

---

### Task 2: Clés l10n

**Files:**
- Modify: `lib/core/l10n/app_en.arb` (remplacer le contenu entier)

**Interfaces:**
- Produces: getters `AppLocalizations` utilisés par les tâches 6–13. Noms exacts ci-dessous.

- [ ] **Step 1: Remplacer `app_en.arb` par**

```json
{
  "@@locale": "en",
  "appTitle": "TravelConnect",
  "@appTitle": {"description": "The application title"},
  "homeTab": "Home",
  "myPlansTab": "My Plans",
  "historyTab": "History",
  "profileTab": "Profile",

  "homeGreeting": "Where are you traveling?",
  "homeSearchHint": "Search a destination",
  "homePopularCountries": "Popular destinations",
  "homePopularPlans": "Popular plans",
  "planValidity": "{days} days",
  "@planValidity": {"placeholders": {"days": {"type": "int"}}},
  "planData": "{gb} GB",
  "@planData": {"placeholders": {"gb": {"type": "int"}}},
  "planBuy": "Buy",

  "myPlansActive": "Active plan",
  "myPlansPast": "Past plans",
  "myPlansDaysLeft": "{days} days left",
  "@myPlansDaysLeft": {"placeholders": {"days": {"type": "int"}}},
  "myPlansRemaining": "{used} of {total} GB used",
  "@myPlansRemaining": {"placeholders": {"used": {"type": "String"}, "total": {"type": "int"}}},
  "myPlansEmptyTitle": "No plans yet",
  "myPlansEmptySubtitle": "Buy a data plan before your next trip and it will show up here.",
  "myPlansEmptyCta": "Browse plans",

  "historyEmptyTitle": "No transactions yet",
  "historyEmptySubtitle": "Your purchases and receipts will appear here.",
  "statusSuccess": "Paid",
  "statusPending": "Pending",
  "statusFailed": "Failed",

  "profileGuest": "Guest traveler",
  "profileSectionAccount": "Account",
  "profileSignIn": "Sign in",
  "profileSectionSettings": "Settings",
  "profileDarkMode": "Dark mode",
  "profileLanguage": "Language",
  "profileLanguageValue": "English",
  "profileSectionSupport": "Support",
  "profileHelp": "Help center",
  "profileSignOut": "Sign out",

  "authTagline": "Data plans for your next trip, ready before you land.",
  "authContinueEmail": "Continue with Email",
  "authContinuePhone": "Continue with Phone",
  "authContinueGoogle": "Continue with Google",
  "authContinueApple": "Continue with Apple",
  "authContinueGuest": "Continue as guest",
  "authLoginTitle": "Welcome back",
  "authEmailLabel": "Email",
  "authPasswordLabel": "Password",
  "authForgotPassword": "Forgot password?",
  "authLoginButton": "Log in",
  "authNoAccount": "No account? Sign up",
  "authSignupTitle": "Create your account",
  "authNameLabel": "Full name",
  "authPhoneLabel": "Phone number",
  "authSignupButton": "Sign up",
  "authHaveAccount": "Already have an account? Log in",
  "authEmailInvalid": "Enter a valid email",
  "authPasswordTooShort": "At least 8 characters",
  "authFieldRequired": "Required"
}
```

- [ ] **Step 2: Régénérer et vérifier**

Run: `flutter gen-l10n` → sans erreur. Puis `flutter analyze` → pas de nouvelle erreur.

- [ ] **Step 3: Commit**

```bash
git add lib/core/l10n/app_en.arb
git commit -m "feat(i18n): add l10n keys for redesigned screens and auth UI"
```

---

### Task 3: Thème orange + Google Fonts + component themes

**Files:**
- Modify: `lib/core/theme/app_theme.dart` (remplacer le contenu entier)
- Test: `test/core/theme/app_theme_test.dart` (créer)

**Interfaces:**
- Consumes: `AppRadius` (Task 1).
- Produces: `AppTheme.light()` / `AppTheme.dark()` (signatures inchangées — `main.dart` non modifié).

- [ ] **Step 1: Écrire le test qui échoue**

```dart
// test/core/theme/app_theme_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';

void main() {
  test('light and dark themes use the warm orange seed', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();
    expect(light.useMaterial3, isTrue);
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
    // Seed #FF6B35 produces an orange-hued primary in light mode.
    final hue = HSLColor.fromColor(light.colorScheme.primary).hue;
    expect(hue, inInclusiveRange(10, 50));
  });

  test('component themes are configured', () {
    final light = AppTheme.light();
    expect(light.inputDecorationTheme.filled, isTrue);
    expect(light.cardTheme.shape, isA<RoundedRectangleBorder>());
  });
}
```

- [ ] **Step 2: Vérifier l'échec**

Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: FAIL (hue bleue ~220 hors 10–50, inputDecorationTheme.filled null).

- [ ] **Step 3: Implémenter**

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_spacing.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFFFF6B35);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? colorScheme.surfaceContainerLowest
          : colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
          ),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
          ),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withOpacity(0.5),
        thickness: 1,
      ),
    );
  }
}
```

- [ ] **Step 4: Vérifier**

Run: `flutter test test/core/theme/app_theme_test.dart` → PASS.
Run: `flutter test` → toute la suite verte (les tests existants pompent le vrai thème ; google_fonts sans réseau retombe sur la police par défaut en test, c'est attendu et sans échec).

- [ ] **Step 5: Commit**

```bash
git add lib/core/theme/app_theme.dart test/core/theme/app_theme_test.dart
git commit -m "feat(theme): warm-orange seed, Plus Jakarta Sans, component themes"
```

---

### Task 4: AppButton + AppCard + ShimmerBox

**Files:**
- Create: `lib/shared/widgets/app_button.dart`
- Create: `lib/shared/widgets/app_card.dart`
- Create: `lib/shared/widgets/shimmer_box.dart`
- Test: `test/shared/widgets/app_button_test.dart`

**Interfaces:**
- Produces:
  - `AppButton({required String label, VoidCallback? onPressed, AppButtonVariant variant = AppButtonVariant.primary, bool loading = false, Widget? icon})`
  - `enum AppButtonVariant { primary, secondary, ghost }`
  - `AppCard({required Widget child, EdgeInsetsGeometry? padding, VoidCallback? onTap})`
  - `ShimmerBox({double? width, required double height, BorderRadius? borderRadius})`

- [ ] **Step 1: Test AppButton (échoue)**

```dart
// test/shared/widgets/app_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/shared/widgets/app_button.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('fires onPressed when tapped', (tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrap(
      AppButton(label: 'Go', onPressed: () => pressed = true),
    ));
    await tester.tap(find.text('Go'));
    expect(pressed, isTrue);
  });

  testWidgets('loading shows spinner and blocks taps', (tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrap(
      AppButton(label: 'Go', loading: true, onPressed: () => pressed = true),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Go'), findsNothing);
    await tester.tap(find.byType(AppButton));
    expect(pressed, isFalse);
  });
}
```

- [ ] **Step 2: Vérifier l'échec**

Run: `flutter test test/shared/widgets/app_button_test.dart`
Expected: FAIL — `app_button.dart` n'existe pas.

- [ ] **Step 3: Implémenter les trois widgets**

```dart
// lib/shared/widgets/app_button.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// Themed button with press-scale feedback and a loading state.
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.loading ? null : widget.onPressed;
    final spinner = SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: widget.variant == AppButtonVariant.primary
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary,
      ),
    );
    final content = widget.loading
        ? spinner
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(widget.label),
            ],
          );

    final Widget button = switch (widget.variant) {
      AppButtonVariant.primary =>
        FilledButton(onPressed: onPressed, child: content),
      AppButtonVariant.secondary =>
        OutlinedButton(onPressed: onPressed, child: content),
      AppButtonVariant.ghost =>
        TextButton(onPressed: onPressed, child: content),
    };

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed && onPressed != null ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}
```

```dart
// lib/shared/widgets/app_card.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Standard surface card: soft radius, subtle shadow, token padding.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
```

```dart
// lib/shared/widgets/shimmer_box.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_spacing.dart';

/// Looping loading placeholder. Do NOT mount in widgets covered by
/// pumpAndSettle-based tests — the animation never settles.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({super.key, this.width, required this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.md),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: scheme.surfaceContainerLowest);
  }
}
```

- [ ] **Step 4: Vérifier**

Run: `flutter test test/shared/widgets/app_button_test.dart` → PASS. Puis `flutter analyze` → propre.

- [ ] **Step 5: Commit**

```bash
git add lib/shared/widgets/app_button.dart lib/shared/widgets/app_card.dart lib/shared/widgets/shimmer_box.dart test/shared/widgets/app_button_test.dart
git commit -m "feat(shared): AppButton, AppCard, ShimmerBox"
```

---

### Task 5: AppTextField + EmptyState

**Files:**
- Create: `lib/shared/widgets/app_text_field.dart`
- Create: `lib/shared/widgets/empty_state.dart`

**Interfaces:**
- Produces:
  - `AppTextField({required String label, TextEditingController? controller, String? errorText, IconData? prefixIcon, bool obscureText = false, TextInputType? keyboardType, ValueChanged<String>? onChanged})`
  - `EmptyState({required IconData icon, required String title, required String subtitle, String? ctaLabel, VoidCallback? onCta})`

- [ ] **Step 1: Implémenter**

```dart
// lib/shared/widgets/app_text_field.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Themed text input: label above the field, inline error, optional icon.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
        ),
      ],
    );
  }
}
```

```dart
// lib/shared/widgets/empty_state.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

/// Centered empty state: icon bubble, title, subtitle, optional CTA.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle,
                style: textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center),
            if (ctaLabel != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: ctaLabel!, onPressed: onCta),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Vérifier**

Run: `flutter analyze` → propre. `flutter test` → suite verte.

- [ ] **Step 3: Commit**

```bash
git add lib/shared/widgets/app_text_field.dart lib/shared/widgets/empty_state.dart
git commit -m "feat(shared): AppTextField and EmptyState"
```

---

### Task 6: Modèles domaine + mock data

**Files:**
- Create: `lib/features/home/domain/data_plan.dart`
- Create: `lib/features/home/data/home_mock.dart`
- Create: `lib/features/my_plans/domain/purchased_plan.dart`
- Create: `lib/features/my_plans/data/my_plans_mock.dart`
- Create: `lib/features/history/domain/transaction_record.dart`
- Create: `lib/features/history/data/history_mock.dart`

**Interfaces:**
- Produces (exact):
  - `class DataPlan { final String id; final String countryName; final String flagEmoji; final String operatorName; final int gigabytes; final int validityDays; final String priceLabel; }` (const ctor, champs nommés requis)
  - `class PopularCountry { final String name; final String flagEmoji; }` (const ctor)
  - `const List<DataPlan> mockPopularPlans;` `const List<PopularCountry> mockPopularCountries;`
  - `class PurchasedPlan { final DataPlan plan; final double usedGigabytes; final int daysLeft; final bool active; }` (const ctor)
  - `const PurchasedPlan? mockActivePlan;` (non-null dans le mock) `const List<PurchasedPlan> mockPastPlans;`
  - `enum TxStatus { success, pending, failed }`
  - `class TransactionRecord { final String id; final String title; final String monthLabel; final String amountLabel; final TxStatus status; }` (const ctor)
  - `const List<TransactionRecord> mockTransactions;`

- [ ] **Step 1: Implémenter les 6 fichiers**

```dart
// lib/features/home/domain/data_plan.dart
class DataPlan {
  final String id;
  final String countryName;
  final String flagEmoji;
  final String operatorName;
  final int gigabytes;
  final int validityDays;
  final String priceLabel;

  const DataPlan({
    required this.id,
    required this.countryName,
    required this.flagEmoji,
    required this.operatorName,
    required this.gigabytes,
    required this.validityDays,
    required this.priceLabel,
  });
}

class PopularCountry {
  final String name;
  final String flagEmoji;
  const PopularCountry({required this.name, required this.flagEmoji});
}
```

```dart
// lib/features/home/data/home_mock.dart
// Hard-coded showcase data. Replaced by Supabase in the Catalog sub-project.
import '../domain/data_plan.dart';

const mockPopularCountries = <PopularCountry>[
  PopularCountry(name: 'Ghana', flagEmoji: '🇬🇭'),
  PopularCountry(name: 'Togo', flagEmoji: '🇹🇬'),
  PopularCountry(name: 'Bénin', flagEmoji: '🇧🇯'),
  PopularCountry(name: 'Nigeria', flagEmoji: '🇳🇬'),
  PopularCountry(name: "Côte d'Ivoire", flagEmoji: '🇨🇮'),
  PopularCountry(name: 'Sénégal', flagEmoji: '🇸🇳'),
];

const mockPopularPlans = <DataPlan>[
  DataPlan(
    id: 'gh-mtn-5',
    countryName: 'Ghana',
    flagEmoji: '🇬🇭',
    operatorName: 'MTN',
    gigabytes: 5,
    validityDays: 7,
    priceLabel: '3 500 FCFA',
  ),
  DataPlan(
    id: 'tg-togocom-10',
    countryName: 'Togo',
    flagEmoji: '🇹🇬',
    operatorName: 'Togocom',
    gigabytes: 10,
    validityDays: 30,
    priceLabel: '6 000 FCFA',
  ),
  DataPlan(
    id: 'sn-orange-8',
    countryName: 'Sénégal',
    flagEmoji: '🇸🇳',
    operatorName: 'Orange',
    gigabytes: 8,
    validityDays: 14,
    priceLabel: '5 000 FCFA',
  ),
  DataPlan(
    id: 'ci-mtn-20',
    countryName: "Côte d'Ivoire",
    flagEmoji: '🇨🇮',
    operatorName: 'MTN',
    gigabytes: 20,
    validityDays: 30,
    priceLabel: '10 000 FCFA',
  ),
];
```

```dart
// lib/features/my_plans/domain/purchased_plan.dart
import '../../home/domain/data_plan.dart';

class PurchasedPlan {
  final DataPlan plan;
  final double usedGigabytes;
  final int daysLeft;
  final bool active;

  const PurchasedPlan({
    required this.plan,
    required this.usedGigabytes,
    required this.daysLeft,
    required this.active,
  });
}
```

```dart
// lib/features/my_plans/data/my_plans_mock.dart
// Hard-coded showcase data. Replaced by Supabase in the Purchase sub-project.
import '../../home/domain/data_plan.dart';
import '../domain/purchased_plan.dart';

const PurchasedPlan mockActivePlan = PurchasedPlan(
  plan: DataPlan(
    id: 'gh-mtn-5',
    countryName: 'Ghana',
    flagEmoji: '🇬🇭',
    operatorName: 'MTN',
    gigabytes: 5,
    validityDays: 7,
    priceLabel: '3 500 FCFA',
  ),
  usedGigabytes: 2.1,
  daysLeft: 4,
  active: true,
);

const mockPastPlans = <PurchasedPlan>[
  PurchasedPlan(
    plan: DataPlan(
      id: 'sn-orange-8',
      countryName: 'Sénégal',
      flagEmoji: '🇸🇳',
      operatorName: 'Orange',
      gigabytes: 8,
      validityDays: 14,
      priceLabel: '5 000 FCFA',
    ),
    usedGigabytes: 8,
    daysLeft: 0,
    active: false,
  ),
];
```

```dart
// lib/features/history/domain/transaction_record.dart
enum TxStatus { success, pending, failed }

class TransactionRecord {
  final String id;
  final String title;
  final String monthLabel;
  final String amountLabel;
  final TxStatus status;

  const TransactionRecord({
    required this.id,
    required this.title,
    required this.monthLabel,
    required this.amountLabel,
    required this.status,
  });
}
```

```dart
// lib/features/history/data/history_mock.dart
// Hard-coded showcase data. Replaced by Supabase in the Notifications+History sub-project.
import '../domain/transaction_record.dart';

const mockTransactions = <TransactionRecord>[
  TransactionRecord(
    id: 'tx-3',
    title: 'MTN Ghana — 5 GB',
    monthLabel: 'July 2026',
    amountLabel: '3 500 FCFA',
    status: TxStatus.success,
  ),
  TransactionRecord(
    id: 'tx-2',
    title: 'Togocom — 10 GB',
    monthLabel: 'June 2026',
    amountLabel: '6 000 FCFA',
    status: TxStatus.pending,
  ),
  TransactionRecord(
    id: 'tx-1',
    title: 'Orange Sénégal — 8 GB',
    monthLabel: 'June 2026',
    amountLabel: '5 000 FCFA',
    status: TxStatus.failed,
  ),
];
```

- [ ] **Step 2: Vérifier + commit**

Run: `flutter analyze` → propre.

```bash
git add lib/features/home/domain lib/features/home/data lib/features/my_plans/domain lib/features/my_plans/data lib/features/history/domain lib/features/history/data
git commit -m "feat(mock): domain models and showcase data for home/my-plans/history"
```

---

### Task 7: PlanCard

**Files:**
- Create: `lib/shared/widgets/plan_card.dart`

**Interfaces:**
- Consumes: `DataPlan` (Task 6), `AppCard` (Task 4), l10n `planData`/`planValidity`/`planBuy` (Task 2).
- Produces: `PlanCard({required DataPlan plan, VoidCallback? onBuy})`.

- [ ] **Step 1: Implémenter**

```dart
// lib/shared/widgets/plan_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_spacing.dart';
import '../../features/home/domain/data_plan.dart';
import 'app_card.dart';

/// Data-plan offer card: flag, operator, volume, validity, price, buy CTA.
class PlanCard extends StatelessWidget {
  final DataPlan plan;
  final VoidCallback? onBuy;

  const PlanCard({super.key, required this.plan, this.onBuy});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(plan.flagEmoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${plan.countryName} · ${plan.operatorName}',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l10n.planData(plan.gigabytes)} · '
                  '${l10n.planValidity(plan.validityDays)}',
                  style: textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(plan.priceLabel,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                height: 32,
                child: FilledButton.tonal(
                  onPressed: onBuy,
                  style: FilledButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                  ),
                  child: Text(l10n.planBuy),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Vérifier + commit**

Run: `flutter analyze` → propre.

```bash
git add lib/shared/widgets/plan_card.dart
git commit -m "feat(shared): PlanCard offer card"
```

---

### Task 8: AppScaffold — pill flottante animée

**Files:**
- Modify: `lib/shared/widgets/app_scaffold.dart` (remplacer le contenu entier)

**Interfaces:**
- Consumes: `AppSpacing`/`AppRadius` (Task 1).
- Produces: même signature publique `AppScaffold({required StatefulNavigationShell navigationShell})` — router inchangé. Labels `Home`/`My Plans`/`History`/`Profile` toujours visibles (contrainte tests).

- [ ] **Step 1: Implémenter**

```dart
// lib/shared/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <({IconData icon, String label})>[
      (icon: Icons.home_rounded, label: l10n.homeTab),
      (icon: Icons.sim_card_rounded, label: l10n.myPlansTab),
      (icon: Icons.receipt_long_rounded, label: l10n.historyTab),
      (icon: Icons.person_rounded, label: l10n.profileTab),
    ];
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: items[i].icon,
                    label: items[i].label,
                    selected: navigationShell.currentIndex == i,
                    onTap: () => navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: Icon(
                icon,
                size: 22,
                color: selected
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? scheme.onPrimaryContainer
                        : scheme.onSurfaceVariant,
                  ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Vérifier les tests existants**

Run: `flutter test`
Expected: suite entière verte — surtout `widget_test.dart` (tap sur labels) et `test/shared/widgets/app_scaffold_test.dart`. Si `app_scaffold_test.dart` cherche `NavigationBar`, adapter CE test (pas le widget) pour chercher `AppScaffold`/labels à la place — le contrat visible (4 labels tapables) est inchangé.

- [ ] **Step 3: Commit**

```bash
git add lib/shared/widgets/app_scaffold.dart test/shared/widgets/app_scaffold_test.dart
git commit -m "feat(nav): floating animated pill bottom bar"
```

---

### Task 9: Home screen

**Files:**
- Modify: `lib/features/home/presentation/home_screen.dart` (remplacer le contenu entier)

**Interfaces:**
- Consumes: `mockPopularCountries`, `mockPopularPlans` (Task 6), `PlanCard` (Task 7), l10n (Task 2), `flutter_animate`.

- [ ] **Step 1: Implémenter**

```dart
// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/plan_card.dart';
import '../data/home_mock.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 120),
          children: [
            Text(l10n.homeGreeting,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800))
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(begin: 12, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              decoration: InputDecoration(
                hintText: l10n.homeSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ).animate(delay: 80.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.homePopularCountries,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700))
                .animate(delay: 160.ms)
                .fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mockPopularCountries.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) {
                  final c = mockPopularCountries[i];
                  return Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                        child: Text(c.flagEmoji,
                            style: const TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(c.name, style: textTheme.labelSmall),
                    ],
                  )
                      .animate(delay: (200 + 60 * i).ms)
                      .fadeIn(duration: 300.ms)
                      .moveX(begin: 16, curve: Curves.easeOutCubic);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.homePopularPlans,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700))
                .animate(delay: 240.ms)
                .fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < mockPopularPlans.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PlanCard(plan: mockPopularPlans[i], onBuy: () {})
                    .animate(delay: (300 + 80 * i).ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 16, curve: Curves.easeOutCubic),
              ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Vérifier**

Run: `flutter test` → suite verte (le boot test trouve toujours `Home` via label nav). `flutter analyze` → propre.

- [ ] **Step 3: Commit**

```bash
git add lib/features/home/presentation/home_screen.dart
git commit -m "feat(home): destination search, popular countries carousel, plan list"
```

---

### Task 10: My Plans screen

**Files:**
- Modify: `lib/features/my_plans/presentation/my_plans_screen.dart` (remplacer le contenu entier)

**Interfaces:**
- Consumes: `mockActivePlan`, `mockPastPlans` (Task 6), `AppCard`, `EmptyState`, l10n.

- [ ] **Step 1: Implémenter**

```dart
// lib/features/my_plans/presentation/my_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/my_plans_mock.dart';
import '../domain/purchased_plan.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPlansTab)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
        children: [
          Text(l10n.myPlansActive,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          _ActivePlanCard(plan: mockActivePlan)
              .animate()
              .fadeIn(duration: 300.ms)
              .moveY(begin: 16, curve: Curves.easeOutCubic),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.myPlansPast,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < mockPastPlans.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _PastPlanTile(plan: mockPastPlans[i])
                  .animate(delay: (100 + 80 * i).ms)
                  .fadeIn(duration: 300.ms)
                  .moveY(begin: 16),
            ),
        ],
      ),
    );
  }
}

class _ActivePlanCard extends StatelessWidget {
  final PurchasedPlan plan;
  const _ActivePlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ratio =
        (plan.usedGigabytes / plan.plan.gigabytes).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(plan.plan.flagEmoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  '${plan.plan.countryName} · ${plan.plan.operatorName}',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Chip(
                label: Text(l10n.myPlansDaysLeft(plan.daysLeft)),
                backgroundColor: scheme.primaryContainer,
                labelStyle: textTheme.labelMedium
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: scheme.surfaceContainerHigh,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.myPlansRemaining(
                plan.usedGigabytes.toStringAsFixed(1), plan.plan.gigabytes),
            style: textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PastPlanTile extends StatelessWidget {
  final PurchasedPlan plan;
  const _PastPlanTile({required this.plan});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      child: Row(
        children: [
          Text(plan.plan.flagEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '${plan.plan.countryName} · ${plan.plan.operatorName} · '
              '${plan.plan.gigabytes} GB',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(plan.plan.priceLabel,
              style: textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
```

Note : `EmptyState` (`myPlansEmptyTitle`/`myPlansEmptySubtitle`/`myPlansEmptyCta`) est le rendu prévu quand il n'y a aucun plan — non atteint avec ce mock ; il sera branché quand les vraies données arriveront. Ne pas ajouter de logique conditionnelle morte.

- [ ] **Step 2: Vérifier + commit**

Run: `flutter test` → verte. `flutter analyze` → propre.

```bash
git add lib/features/my_plans/presentation/my_plans_screen.dart
git commit -m "feat(my-plans): active plan hero with animated usage gauge, past plans"
```

---

### Task 11: History screen

**Files:**
- Modify: `lib/features/history/presentation/history_screen.dart` (remplacer le contenu entier)

**Interfaces:**
- Consumes: `mockTransactions`, `TxStatus` (Task 6), `AppCard`, l10n (`statusSuccess`/`statusPending`/`statusFailed`).

- [ ] **Step 1: Implémenter**

```dart
// lib/features/history/presentation/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/history_mock.dart';
import '../domain/transaction_record.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    // Group transactions by month, preserving mock order.
    final groups = <String, List<TransactionRecord>>{};
    for (final tx in mockTransactions) {
      groups.putIfAbsent(tx.monthLabel, () => []).add(tx);
    }

    var index = 0;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTab)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
        children: [
          for (final entry in groups.entries) ...[
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacing.md, bottom: AppSpacing.md),
              child: Text(entry.key,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ),
            for (final tx in entry.value)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _TxTile(tx: tx)
                    .animate(delay: (80 * index++).ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 12, curve: Curves.easeOutCubic),
              ),
          ],
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final TransactionRecord tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (label, bg, fg) = switch (tx.status) {
      TxStatus.success => (
          l10n.statusSuccess,
          const Color(0xFFD9F2E3),
          const Color(0xFF116B3E)
        ),
      TxStatus.pending => (
          l10n.statusPending,
          scheme.surfaceContainerHigh,
          scheme.onSurfaceVariant
        ),
      TxStatus.failed => (
          l10n.statusFailed,
          scheme.errorContainer,
          scheme.onErrorContainer
        ),
    };

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text(tx.amountLabel,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(label,
                style: textTheme.labelMedium
                    ?.copyWith(color: fg, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Vérifier + commit**

Run: `flutter test` → verte. `flutter analyze` → propre.

```bash
git add lib/features/history/presentation/history_screen.dart
git commit -m "feat(history): month-grouped transactions with status chips"
```

---

### Task 12: Profile screen

**Files:**
- Modify: `lib/features/profile/presentation/profile_screen.dart` (remplacer le contenu entier)

**Interfaces:**
- Consumes: `themeModeProvider` (existant, `lib/core/theme/theme_provider.dart` — `Notifier<ThemeMode>` avec méthode `setThemeMode(ThemeMode)`), `AppCard`, l10n. Route `/auth` (créée Task 13 — le bouton compile car go_router accepte les paths dynamiques ; navigation testée en Task 13).
- Produces: bouton `l10n.profileSignIn` qui fait `context.go('/auth')`.

- [ ] **Step 1: Vérifier l'API exacte du provider**

Lire `lib/core/theme/theme_provider.dart`. Adapter l'appel toggle ci-dessous au nom réel de la méthode (attendu : `ref.read(themeModeProvider.notifier).setThemeMode(...)`).

- [ ] **Step 2: Implémenter**

```dart
// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/app_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTab)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: scheme.primaryContainer,
                child: Icon(Icons.person_rounded,
                    size: 32, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: AppSpacing.lg),
              Text(l10n.profileGuest,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(l10n.profileSectionAccount),
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.login_rounded),
              title: Text(l10n.profileSignIn),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.go('/auth'),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(l10n.profileSectionSettings),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: Text(l10n.profileDarkMode),
                  value: isDark,
                  onChanged: (v) => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.profileLanguage),
                  trailing: Text(l10n.profileLanguageValue,
                      style: textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(l10n.profileSectionSupport),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: Text(l10n.profileHelp),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout_rounded, color: scheme.error),
                  title: Text(l10n.profileSignOut,
                      style: TextStyle(color: scheme.error)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}
```

- [ ] **Step 3: Vérifier + commit**

Run: `flutter test` → verte (le tap `/auth` n'est exercé qu'en Task 13). `flutter analyze` → propre.

```bash
git add lib/features/profile/presentation/profile_screen.dart
git commit -m "feat(profile): account/settings/support groups with working theme toggle"
```

---

### Task 13: Écrans Auth + routes

**Files:**
- Create: `lib/features/auth/presentation/welcome_screen.dart`
- Create: `lib/features/auth/presentation/login_screen.dart`
- Create: `lib/features/auth/presentation/signup_screen.dart`
- Modify: `lib/core/router/app_router.dart` (ajouter routes `/auth`)
- Test: `test/features/auth/auth_screens_test.dart`

**Interfaces:**
- Consumes: `AppButton`, `AppTextField` (Tasks 4–5), l10n auth (Task 2).
- Produces: routes `/auth`, `/auth/login`, `/auth/signup` hors shell. Tous les submits : `context.go('/home')`.

- [ ] **Step 1: Test (échoue)**

```dart
// test/features/auth/auth_screens_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Profile sign-in leads to welcome, login and signup',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TravelConnectApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Email'), findsOneWidget);

    await tester.tap(find.text('Continue with Email'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.text('No account? Sign up'));
    await tester.pumpAndSettle();
    expect(find.text('Create your account'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Vérifier l'échec**

Run: `flutter test test/features/auth/auth_screens_test.dart`
Expected: FAIL — tap `Sign in` ne mène nulle part (route `/auth` absente).

- [ ] **Step 3: Ajouter les routes**

Dans `lib/core/router/app_router.dart`, ajouter les imports :

```dart
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
```

et dans `routes: [` (AVANT le `StatefulShellRoute.indexedStack`) :

```dart
      GoRoute(
        path: '/auth',
        builder: (c, s) => const WelcomeScreen(),
        routes: [
          GoRoute(path: 'login', builder: (c, s) => const LoginScreen()),
          GoRoute(path: 'signup', builder: (c, s) => const SignupScreen()),
        ],
      ),
```

- [ ] **Step 4: Implémenter les trois écrans**

```dart
// lib/features/auth/presentation/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg + 4),
                ),
                child: Icon(Icons.travel_explore_rounded,
                    size: 44, color: scheme.onPrimary),
              )
                  .animate()
                  .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 400.ms,
                      curve: Curves.easeOutBack)
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.appTitle,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800))
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.authTagline,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                  textAlign: TextAlign.center)
                  .animate(delay: 180.ms)
                  .fadeIn(duration: 300.ms),
              const Spacer(),
              for (final (i, item) in <({String label, IconData icon, VoidCallback onTap, AppButtonVariant variant})>[
                (
                  label: l10n.authContinueEmail,
                  icon: Icons.mail_outline_rounded,
                  onTap: () => context.go('/auth/login'),
                  variant: AppButtonVariant.primary
                ),
                (
                  label: l10n.authContinuePhone,
                  icon: Icons.phone_iphone_rounded,
                  onTap: () => context.go('/auth/signup'),
                  variant: AppButtonVariant.secondary
                ),
                (
                  label: l10n.authContinueGoogle,
                  icon: Icons.g_mobiledata_rounded,
                  onTap: () => context.go('/home'),
                  variant: AppButtonVariant.secondary
                ),
                (
                  label: l10n.authContinueApple,
                  icon: Icons.apple_rounded,
                  onTap: () => context.go('/home'),
                  variant: AppButtonVariant.secondary
                ),
              ].indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: item.label,
                      icon: Icon(item.icon, size: 20),
                      variant: item.variant,
                      onPressed: item.onTap,
                    ),
                  )
                      .animate(delay: (250 + 70 * i).ms)
                      .fadeIn(duration: 300.ms)
                      .moveY(begin: 16, curve: Curves.easeOutCubic),
                ),
              AppButton(
                label: l10n.authContinueGuest,
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go('/home'),
              ).animate(delay: 550.ms).fadeIn(duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
```

```dart
// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  bool _loading = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _emailError =
          _emailRe.hasMatch(_email.text) ? null : l10n.authEmailInvalid;
    });
    if (_emailError != null) return;
    setState(() => _loading = true);
    // UI-only: fake a short round-trip, then land on Home.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(l10n.authLoginTitle,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800))
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: l10n.authEmailLabel,
              controller: _email,
              errorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ).animate(delay: 80.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authPasswordLabel,
              controller: _password,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
            ).animate(delay: 160.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(l10n.authForgotPassword),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.authLoginButton,
              loading: _loading,
              onPressed: _submit,
            ).animate(delay: 240.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.authNoAccount,
              variant: AppButtonVariant.ghost,
              onPressed: () => context.go('/auth/signup'),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/features/auth/presentation/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _loading = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _validateLive() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _nameError = _name.text.trim().isEmpty ? l10n.authFieldRequired : null;
      _emailError =
          _emailRe.hasMatch(_email.text) ? null : l10n.authEmailInvalid;
      _passwordError =
          _password.text.length >= 8 ? null : l10n.authPasswordTooShort;
    });
  }

  Future<void> _submit() async {
    _validateLive();
    if (_nameError != null || _emailError != null || _passwordError != null) {
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(l10n.authSignupTitle,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800))
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: l10n.authNameLabel,
              controller: _name,
              errorText: _nameError,
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (_) => _validateLive(),
            ).animate(delay: 60.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authEmailLabel,
              controller: _email,
              errorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _validateLive(),
            ).animate(delay: 120.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authPhoneLabel,
              controller: _phone,
              prefixIcon: Icons.phone_iphone_rounded,
              keyboardType: TextInputType.phone,
            ).animate(delay: 180.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authPasswordLabel,
              controller: _password,
              errorText: _passwordError,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              onChanged: (_) => _validateLive(),
            ).animate(delay: 240.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: l10n.authSignupButton,
              loading: _loading,
              onPressed: _submit,
            ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.authHaveAccount,
              variant: AppButtonVariant.ghost,
              onPressed: () => context.go('/auth/login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Vérifier**

Run: `flutter test test/features/auth/auth_screens_test.dart` → PASS.
Run: `flutter test` → suite entière verte. `flutter analyze` → propre.

- [ ] **Step 6: Commit**

```bash
git add lib/features/auth lib/core/router/app_router.dart test/features/auth/auth_screens_test.dart
git commit -m "feat(auth): welcome/login/signup UI-only screens with /auth routes"
```

---

### Task 14: Vérification finale

**Files:** aucun nouveau — vérification globale.

- [ ] **Step 1: Suite complète + lint**

Run: `flutter analyze` → seul l'info `unnecessary_cast` pré-existant toléré.
Run: `flutter test` → tous les tests passent (anciens 8 + nouveaux : thème ×2, AppButton ×2, auth ×1 minimum).

- [ ] **Step 2: Lancement visuel (si device/emulateur dispo)**

Run: `flutter run` (creds placeholder OK — l'app boote sans vraies clés). Vérifier : pill nav animée, stagger Home, jauge My Plans, chips History, toggle dark mode Profile, parcours Profile → Sign in → Login → Signup.

- [ ] **Step 3: Mettre à jour le handoff**

Dans `docs/superpowers/HANDOFF.md`, section « État actuel », ajouter une ligne : refonte UI faite (design system orange + Plus Jakarta Sans, pill nav animée, 4 tabs mock data, auth UI-only `/auth`), spec `2026-07-03-ui-redesign-design.md`. « Prochaine étape » reste Auth (la logique).

- [ ] **Step 4: Commit final**

```bash
git add docs/superpowers/HANDOFF.md
git commit -m "docs: record UI redesign completion in handoff"
```
