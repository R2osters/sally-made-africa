# TravelConnect — Auth Sub-Project Design

Date: 2026-07-02
Scope: second of 6 sub-projects. This spec covers **Auth only**.

## Goal

Full authentication for TravelConnect on top of Supabase Auth: Email/password, Phone (SMS OTP), Google, Apple, and an explicit **Guest** mode. Guests can browse; account-gated routes (Profile now, Purchase later) redirect to login. Session persisted in **secure storage**. Biometric unlock is **deferred** to a later iteration (user decision 2026-07-02).

## Decisions (locked from brainstorming)

- Scope: **all sign-in methods now** (Email, Phone OTP, Google, Apple, Guest) — user decision 2026-07-02.
- Supabase creds: still **placeholder** via `--dart-define`. Everything testable with fakes; real OAuth/SMS providers get configured in the Supabase dashboard later (Google & Apple OAuth apps, Twilio/Messagebird for SMS). Code must work unchanged once real creds exist.
- Google/Apple: via `supabase.auth.signInWithOAuth(OAuthProvider.google|apple)` (external browser / deep-link flow). **No** `google_sign_in` / `sign_in_with_apple` native packages for now — fewer moving parts, no platform config needed until real creds arrive. Revisit for native-feel later.
- Phone: `signInWithOtp(phone:)` + `verifyOTP(type: OtpType.sms)`. Sign-up and sign-in are the same flow for phone.
- Guest = **local-only state** (no Supabase anonymous session). Persisted flag in `shared_preferences`. Choosing guest skips login; purchasing/profile will force account creation.
- Session storage: `flutter_secure_storage` wired as Supabase auth `localStorage` (`FlutterAuthClientOptions`). Also fixes deferred debt: rename deprecated `anonKey:` → `publishableKey:` is NOT done (param still `anonKey` in supabase_flutter 2.5.x for `Supabase.initialize`; keep as-is, re-check on next dep bump).
- Biometrics: **deferred**.
- New deps: `flutter_secure_storage`. No other additions.

## Architecture

Feature-first, mirroring Foundation conventions. Repositories return `Result<T>`, never throw across layers.

```
lib/features/auth/
  domain/
    auth_user.dart            # entity: id, email, phone, displayName
    auth_repository.dart      # abstract, Result-returning
  data/
    supabase_auth_repository.dart   # impl over supabase.auth
    secure_auth_storage.dart        # LocalStorage impl over flutter_secure_storage
  presentation/
    auth_providers.dart       # authRepositoryProvider, authStateProvider, guestModeProvider
    auth_controller.dart      # AsyncNotifier driving sign-in/up/out actions
    login_screen.dart         # /login
    sign_up_screen.dart       # /signup
    phone_login_screen.dart   # /phone-login (phone entry → OTP entry)
lib/core/error/failure.dart   # + AuthFailure
```

### Domain

- `AuthUser { String id; String? email; String? phone; String? displayName; }` — plain immutable class, `==`/`hashCode` on id.
- `AuthRepository`:
  - `Future<Result<AuthUser>> signInWithEmail(String email, String password)`
  - `Future<Result<AuthUser>> signUpWithEmail(String email, String password)`
  - `Future<Result<void>> signInWithOtp(String phone)` — sends SMS
  - `Future<Result<AuthUser>> verifyOtp(String phone, String token)`
  - `Future<Result<void>> signInWithGoogle()` / `signInWithApple()` — fire OAuth flow; session lands via stream
  - `Future<Result<void>> signOut()`
  - `AuthUser? get currentUser`
  - `Stream<AuthUser?> authStateChanges()`

### App-level auth state

`AppAuthState` (sealed): `Authenticated(AuthUser)` / `Guest` / `Unauthenticated`.

- `guestModeProvider` — `Notifier<bool>` persisted under key `guest_mode` in shared_preferences (same load pattern as `themeModeProvider`, but with a `loaded` guard to avoid the race noted in Foundation debt #2).
- `appAuthStateProvider` — combines `authStateChanges()` stream + guest flag. Signed-in wins over guest; signing out clears guest flag only if it was set by the session.

### Failure mapping

`AuthFailure extends Failure` added to `failure.dart`. `supabase.AuthException` → `AuthFailure(message)`; network errors → `NetworkFailure`; anything else → `UnknownFailure`. UI shows `failure.message` in a SnackBar.

### Router integration

- New top-level routes **outside** the shell: `/login`, `/signup`, `/phone-login`.
- `GoRouter(refreshListenable: ...)` driven by `appAuthStateProvider` (small `Listenable` bridge, e.g. `ValueNotifier` updated by a provider listener).
- `redirect` logic (replaces the Foundation TODO stub):
  - `Unauthenticated` (not guest) & target is not an auth route → `/login`
  - `Authenticated` or `Guest` & target is an auth route → `/home`
  - `Guest` & target ∈ guarded set (`/profile` for now; purchase routes join in sub-project 4) → `/login`
- Guarded set lives in one const list so Purchase can extend it.

### Screens (Material 3, l10n everywhere)

- **LoginScreen**: email + password fields with validation, Sign in button, divider, Google / Apple / Phone buttons, "Continue as guest" text button, link to Sign up. Errors via SnackBar; loading state disables buttons.
- **SignUpScreen**: email, password, confirm password; on success either signed in (auto-confirm) or "check your email" info shown.
- **PhoneLoginScreen**: step 1 phone number (E.164 hint), step 2 six-digit OTP; resend link.
- **ProfileScreen**: gains a real Sign out button (guest never reaches it).

### Supabase bootstrap change

`initSupabase()` gains `authOptions: FlutterAuthClientOptions(localStorage: SecureAuthStorage())` so sessions live in platform secure storage (Keychain / EncryptedSharedPreferences).

## Testing strategy

No Flutter SDK in the sandbox this session → tests are written per-task, full suite run by Léo on Windows at the end (`flutter gen-l10n && flutter analyze && flutter test`). Suite must stay green (was 8/8).

- `FakeAuthRepository` in `test/helpers/` — scriptable results + controllable auth stream.
- Unit: AuthUser equality, failure mapping helper, guestModeProvider persistence (via `SharedPreferences.setMockInitialValues`), appAuthState combination, auth_controller actions.
- Widget: LoginScreen validation + guest button, PhoneLoginScreen step transition.
- Router: redirect matrix (unauth→login, guest can browse home, guest blocked on profile, authed leaves login).
- Supabase repository itself is a thin adapter — covered by failure-mapping unit tests; no live network tests.

## Out of scope

Biometric unlock, native Google/Apple SDK flows, real SMS/OAuth provider config, password reset UI (deep-link handling lands with real creds), account deletion, profile editing.
