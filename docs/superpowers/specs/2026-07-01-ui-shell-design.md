# TravelConnect — UI Shell (Auth/Catalog/Purchase mock) Design

Date: 2026-07-01
Scope: combines the UI layer of 3 planned sub-projects (Auth, Catalog, Purchase) into a single design. All auth and payment logic is **mocked** — real Supabase Auth and real payment gateways remain separate future specs. Catalog data uses **real Supabase tables** (migration + seed), since it's read-only and low-risk.

Input: a 12-screen HTML/Tailwind mock (splash, onboarding, login, signup, home, country select, plan select, plan details, checkout, payment method, payment processing, payment success) with an embedded Material color token system.

## Goal

Port the visual design system and screen flow from the HTML mock into the Flutter app, on top of the existing Foundation scaffold (4-tab shell, Riverpod, go_router, Material 3 theme). Produce a fully navigable, visually complete app — no dead-end screens — with auth and payment logic stubbed so later specs can slot in real behavior without UI rework.

## Decisions (locked from brainstorming)

- **Theme**: centralize HTML design tokens (colors, font sizes, spacing, radii) in a `ThemeExtension<AppTokens>` attached to both light/dark `ThemeData`. Screens read tokens via `Theme.of(context).extension<AppTokens>()!`, never hardcode hex values.
- **Auth**: UI only. Login/signup screens exist and validate input shape, but the submit button navigates directly to `/home` — no `Supabase.auth` call. The `// TODO(auth-subproject)` redirect guard in `app_router.dart` stays a no-op.
- **Catalog data**: real Supabase tables (`countries`, `esim_plans`), queried via a `CatalogRepository`. New migration `supabase/migrations/0001_catalog.sql` with public-read RLS policies, plus a seed script matching the countries/plans shown in the HTML mock (Japan, UK, Italy, France, China, India, South Korea, Thailand, Germany, Spain, Brazil, Canada, Mexico, USA). Since `Env` still holds placeholder Supabase credentials, these screens are expected to show the existing `ErrorView` (retry) until real credentials are supplied — this is correct, not a bug, and will be documented in the handoff.
- **Purchase**: UI only. `payment_processing_screen` runs a `Future.delayed(~2s)` then navigates to `payment_success_screen`. No PaymentService, no gateway integration (that interface is the real Purchase sub-project later).
- **Routing**: pre-shell routes (`/splash`, `/onboarding`, `/login`, `/signup`) live at the top level of the existing `GoRouter`, outside `StatefulShellRoute`. Purchase/catalog flow screens (`/country-select`, `/country/:code/plans`, `/plans/:id`, `/checkout`, `/payment-method`, `/payment-processing`, `/payment-success`) are pushed on top of the shell, reachable from Home. App always boots at `/splash` for now (no "already onboarded" / "already logged in" persistence — that's real Auth sub-project work).
- **State**: Riverpod. Simple `AsyncNotifier`/`FutureProvider` for catalog fetches; an in-memory `StateNotifier`-based `PurchaseFlowController` holds the selected country/plan through checkout→payment→success (cleared on success or back-navigation to Home).

## Folder structure

```
lib/features/
  onboarding/presentation/
    splash_screen.dart
    onboarding_screen.dart
  auth/presentation/
    login_screen.dart
    signup_screen.dart
  catalog/
    data/
      catalog_repository.dart
      models/country.dart
      models/esim_plan.dart
    presentation/
      country_select_screen.dart
      plan_select_screen.dart
      plan_details_screen.dart
  purchase/
    presentation/
      checkout_screen.dart
      payment_method_screen.dart
      payment_processing_screen.dart
      payment_success_screen.dart
      purchase_flow_controller.dart   # Riverpod StateNotifier: selected country/plan

lib/shared/widgets/
  gradient_background.dart
  glass_card.dart
  pill_button.dart
  step_dots.dart

lib/core/theme/
  app_tokens.dart   # ThemeExtension<AppTokens>: colors, spacing, radii, text styles

supabase/
  migrations/0001_catalog.sql
  seed/catalog_seed.sql
```

## Routing changes (`app_router.dart`)

```
GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute('/splash', ...),
    GoRoute('/onboarding', ...),
    GoRoute('/login', ...),
    GoRoute('/signup', ...),
    StatefulShellRoute.indexedStack(...)   # existing 4-tab shell, unchanged
      # + purchase/catalog routes pushed via context.push from Home, not tabs:
    GoRoute('/country-select', ...),
    GoRoute('/country/:code/plans', ...),
    GoRoute('/plans/:id', ...),
    GoRoute('/checkout', ...),
    GoRoute('/payment-method', ...),
    GoRoute('/payment-processing', ...),
    GoRoute('/payment-success', ...),
  ],
)
```

The existing `redirect` TODO stub is untouched — no guard added yet (that's real Auth sub-project scope).

## Data model

```sql
-- countries
code text primary key,        -- 'JP', 'GB', ...
name text not null,
region text not null,         -- 'Asia', 'Europe', 'Americas'
flag_url text,
coverage_label text           -- 'Excellent Coverage'

-- esim_plans
id uuid primary key default gen_random_uuid(),
country_code text references countries(code),
data_gb numeric not null,
validity_days int not null,
price_usd numeric not null,
network_label text,           -- '5G/LTE'
is_popular boolean default false
```

RLS: `select` policy `using (true)` on both tables (public read), no insert/update/delete policy for `anon` role.

## Error handling

Catalog screens use the existing `ErrorView` widget on fetch failure (expected with placeholder creds) with a retry button that re-invokes the provider. No new error-handling abstraction needed — reuses `Result`/`Failure` from Foundation.

## Testing

- `flutter analyze` clean.
- Existing boot test (`lib/main.dart` smoke test) still passes.
- New widget test: navigating `/splash` → `/onboarding` → `/login` renders expected content (route smoke test, no backend dependency).
- Catalog screens are **not** integration-tested against a live Supabase instance in this spec (no real project connected) — manual verification deferred to whoever supplies real credentials.
- No emulator/device available in this environment; running the full visual flow end-to-end is explicitly **not** claimed as verified — flagged to the user in the handoff instead of asserting success.

## Out of scope (future specs)

- Real Supabase Auth (email/phone/Google/Apple/guest), secure storage, biometric, router auth guard.
- Real payment gateway integration (MTN MoMo, Orange Money, TMoney, Wave, Visa/Mastercard) behind a `PaymentService` interface.
- Persisted "seen onboarding" / "logged in" state.
- Push notifications, transaction history, receipts.
