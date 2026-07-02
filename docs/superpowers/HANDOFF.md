# TravelConnect — Handoff pour le prochain agent

> Document lu au démarrage d'une session pour savoir où en est le projet et quoi faire ensuite.
> Dernière mise à jour : 2026-07-01 (fin du sous-projet Foundation).

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

## Prochaine étape : Sous-projet 2 — Auth

Commencer ici. Lancer `superpowers:brainstorming` pour le spec Auth.

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

## UI Shell (2026-07-02)

Les 12 écrans du mock HTML construits par-dessus Foundation :
splash → onboarding → login → signup → home → country select → plan select →
plan details → checkout → payment method → payment processing → success.

- **Thème** : ThemeExtension `AppTokens` (`lib/core/theme/app_tokens.dart`) porte
  tous les design tokens du HTML (palette bleue du bloc Design-System ; la palette
  orange par-écran du mock a été volontairement ignorée). Les écrans lisent via
  `context.tokens`.
- **Mocké** : auth (login/signup font juste `context.go('/home')`), paiement
  (`payment_processing_screen` attend 2 s puis navigue). Pas de Supabase Auth réel,
  pas de gateway.
- **Réel** : données catalogue via `CatalogRepository` sur les tables Supabase
  `countries` / `esim_plans` (migration + seed dans `supabase/`).
- **ÉTAT CONNU** : `Env` contient toujours des creds Supabase placeholder, donc les
  écrans country select / plan select afficheront `ErrorView` (retry) tant que de
  vrais creds ne sont pas fournis et que migration + seed n'ont pas tourné. C'est
  attendu, pas un bug.
- **NON vérifié de bout en bout sur device/émulateur** — aucun device disponible
  dans l'environnement de build. Les tests widget passent (32/32) ; un humain doit
  lancer l'app une fois les vrais creds en place.

Prochains specs (inchangés vs roadmap) : Auth réel, Purchase/PaymentService réel,
Notifications/History.
