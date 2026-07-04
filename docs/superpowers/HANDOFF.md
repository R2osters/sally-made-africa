# TravelConnect — Handoff pour le prochain agent

> Document lu au démarrage d'une session pour savoir où en est le projet et quoi faire ensuite.
> Dernière mise à jour : 2026-07-04 (redesign v2 « liquid glass » complet, 11 écrans).

## ⚡ Redesign v2 « Liquid Glass » : FAIT ✅ (2026-07-04)

Source : dossier `TravelConnect Redesign/` (prototype HTML + specs). Spec : `docs/superpowers/specs/2026-07-04-liquid-glass-redesign-design.md`. Plan : `docs/superpowers/plans/2026-07-04-liquid-glass-redesign.md`. Audit 360 : `docs/superpowers/AUDIT-360-2026-07-04.md`. 15/15 tests.

Remplace le design v1 orange/Plus Jakarta Sans. Livré :
- **Design system** : fond spatial `#05070F`, surfaces verre translucides, accent `#2F80FF`/cyan `#37E0FF`, `AppColors` (ThemeExtension, dark+light), polices **locales** Clash Display + Satoshi (`assets/fonts/`, google_fonts retiré — le gotcha testWidgets/GoogleFonts n'existe plus)
- **11 écrans** : welcome (globe étoilé), login, signup, **OTP** (`/auth/otp`), Explorer (globe interactif CustomPaint `GlobeView` — rotation/drag/labels pays tappables), sheets opérateurs→forfaits, `/plan-detail`, `/checkout` (5 moyens de paiement), `/success`, Mes forfaits, `/active-plan` (anneau conique + QR factice), Historique (groupes mois), Profil (toggles langue/sombre/notifs/biométrie), `/notifications`
- **i18n FR+EN** complets, FR par défaut, `localeProvider` persisté avec garde `_touched` (même garde ajoutée à `themeModeProvider` — dette #2 soldée)
- **Mocks** : catalog 8 pays / 11 opérateurs / 4 tiers / devises XOF-GHS-NGN (`lib/features/catalog/`), paiements, plans, historique, notifs — tout depuis le prototype
- Gotcha : `GlobeView` détecte `FLUTTER_TEST` et désactive sa rotation infinie (pumpAndSettle-safe). Drapeaux = emoji (déviation spec, pas de réseau).

Reste v1 → v2 : rien de bloquant. Dette : `anonKey` déprécié (info), cast test (info).

## Ce qu'est le projet

Application mobile Flutter + Supabase (iOS/Android) : acheter des forfaits data mobiles pour un autre pays **avant** de voyager. Marketplace entre voyageurs et opérateurs télécom. Marchés cibles : Afrique de l'Ouest francophone (Ghana, Togo, Bénin, Nigeria, Côte d'Ivoire, Sénégal, Burkina Faso, Mali).

Package Dart : `travelconnect`. Repo mono-branche `main` (pas de remote GitHub configuré).

## Méthode de travail (IMPORTANT — respecter)

Le gros cahier des charges a été **découpé en 6 sous-projets**. Chaque sous-projet suit le cycle complet :

1. `superpowers:brainstorming` → produit un **spec** dans `docs/superpowers/specs/YYYY-MM-DD-<sujet>-design.md`
2. `superpowers:writing-plans` → produit un **plan** TDD dans `docs/superpowers/plans/YYYY-MM-DD-<sujet>.md`
3. `superpowers:subagent-driven-development` → exécute : 1 sous-agent implémenteur par tâche + 1 relecture (spec + qualité) par tâche + 1 relecture globale finale
4. `superpowers:finishing-a-development-branch` → merge sur `main`

Ne pas sauter le brainstorming ni écrire du code avant d'avoir spec + plan validés. Travailler sur une **branche dédiée** (jamais directement sur `main`), merge `--no-ff` à la fin.

Suivi durable de progression : `.superpowers/sdd/progress.md` (ledger — les tâches marquées `complete` sont faites, ne pas les refaire après une compaction).

## État actuel

### Sous-projet 1 — Foundation : FAIT ✅
Mergé sur `main` (commit `6a224ac`). 8/8 tests passent.

Livré :
- Architecture propre feature-first : `lib/features/<f>/{domain,data,presentation}`, transverse dans `lib/core/`, widgets partagés dans `lib/shared/`
- Riverpod = DI unique (pas de get_it/provider/bloc)
- Material 3, thèmes light/dark (`ColorScheme.fromSeed`), mode persisté via `shared_preferences` → `themeModeProvider`
- Navigation `go_router` : `StatefulShellRoute.indexedStack`, bottom-nav 4 onglets (Home / My Plans / History / Profile) via `AppScaffold`
- Bootstrap Supabase : creds placeholder lus par `--dart-define` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) — jamais commiter de vraies clés
- Types d'erreur : `sealed Result<T>` (`Success`/`Error`) + `sealed Failure` — les repos retournent `Result<T>`, jamais d'exception à travers les couches
- i18n : `AppLocalizations` câblé partout (anglais seulement pour l'instant), clés dans `lib/core/l10n/app_en.arb`
- Écrans placeholder + test de démarrage/changement d'onglet

### Refonte UI / Design System : FAIT ✅ (2026-07-03, hors roadmap, inséré avant Auth)
Spec : `docs/superpowers/specs/2026-07-03-ui-redesign-design.md`. Plan : `docs/superpowers/plans/2026-07-03-ui-redesign.md`. 13/13 tests passent.

Livré :
- Design system : seed orange `#FF6B35`, Plus Jakarta Sans (`google_fonts`), component themes complets, tokens `AppSpacing`/`AppRadius` (`lib/core/theme/`)
- Widgets partagés : `AppButton`, `AppCard`, `AppTextField`, `EmptyState`, `ShimmerBox`, `PlanCard` (`lib/shared/widgets/`)
- Bottom-nav pill flottante animée (`AppScaffold` refait, contrat routes inchangé)
- 4 tabs habillés avec mock data (fichiers `*_mock.dart` dans `data/`, remplacés par Supabase plus tard) ; animations `flutter_animate` finies (pumpAndSettle-safe)
- Écrans Auth UI-only : `/auth` (welcome), `/auth/login`, `/auth/signup` hors shell — submits factices `context.go('/home')`
- Toggle dark mode branché sur `themeModeProvider` dans Profile
- Gotcha : tests touchant `GoogleFonts` doivent être `testWidgets` (pas `test()`) — le fetch async de police échoue après la fin d'un plain test

## Prochaine étape : Sous-projet 2 — Auth

Commencer ici. Lancer `superpowers:brainstorming` pour le spec Auth. Les écrans Auth UI existent déjà (`lib/features/auth/presentation/`) — le sous-projet branche la vraie logique Supabase derrière.

Périmètre attendu (du cahier des charges initial) :
- Connexion : Email, Numéro de téléphone, Google, Apple, **Invité** (guest)
- Invités peuvent parcourir les offres, mais **acheter exige un compte**
- Supabase Auth, stockage sécurisé (secure storage), login biométrique
- Point d'accroche déjà en place : `lib/core/router/app_router.dart` contient un stub `redirect` avec `// TODO(auth-subproject): guard purchase/profile routes for guests.` — c'est là qu'on branche le garde d'authentification

Puis dans l'ordre :
3. **Catalog** — parcours pays/opérateur/forfait + schéma Supabase (Countries/Operators/Plans)
4. **Purchase** — checkout, abstraction `PaymentService` (fournisseurs en stub : MTN MoMo, Orange Money, TMoney, Wave, Visa/Mastercard), statut d'achat, My Plans
5. **Notifications + History** — service push, historique transactions, reçus
6. **Admin-ready DB** — schéma seulement, pas d'UI dashboard

## Décisions verrouillées

- State management / DI : **Riverpod** uniquement
- Paiements : **stub** derrière une interface `PaymentService` pour l'instant (pas encore de vraies creds marchand)
- Supabase : creds **placeholder** jusqu'à ce que l'utilisateur fournisse les vraies (URL + anon key)
- i18n : anglais seulement pour l'instant, structure prête pour le français

## Dettes techniques acceptées (à revisiter plus tard)

Voir aussi la mémoire `travelconnect-deferred-followups`.
1. `lib/core/config/supabase_client.dart` — param `anonKey:` déprécié par supabase_flutter (préférer `publishableKey`). Fonctionne encore. À renommer lors d'un bump ou dans Auth.
2. `lib/core/theme/theme_provider.dart` — `_loadPersisted()` lancé sans `await` depuis `build()` : un `setThemeMode()` très tôt au démarrage pourrait être écrasé par la lecture persistée. Inoffensif aujourd'hui (rien n'appelle setThemeMode au boot). Ajouter un flag « loaded » quand le toggle de thème du Profile sera construit.
3. `test/core/error/result_test.dart:18` — lint `unnecessary_cast` (info, volontaire).

## Environnement de build (gotchas Windows)

Voir la mémoire `travelconnect-env-gotchas`. En cas d'échec d'une commande flutter sur un artefact d'engine manquant, essayer d'abord :
```
flutter precache --windows
```
SDK utilisé : Flutter 3.24.4 / Dart 3.5.4. Le SDK avait été corrompu (`dart.exe` manquant) et réparé en supprimant le cache `dart-sdk` puis en relançant `flutter --version` pour re-télécharger. Garder >10 GB libres sur C:.

## Commandes utiles

```bash
flutter pub get              # dépendances
flutter gen-l10n             # régénère AppLocalizations depuis les .arb
flutter analyze              # lint
flutter test                 # suite complète (doit rester verte : 8/8 actuellement)
# lancer l'app avec de vraies creds Supabase :
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```
