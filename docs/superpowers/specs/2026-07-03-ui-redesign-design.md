# TravelConnect — Refonte UI/Design System (spec)

> Date : 2026-07-03. Sous-projet hors roadmap initiale, inséré avant Auth (sous-projet 2).
> Périmètre validé par l'utilisateur : design system + 4 tabs + écrans Auth (UI seule).

## Objectif

Remplacer les écrans placeholder par une vraie interface : design system complet, 4 onglets habillés avec données mockées, écrans Auth visuels (sans logique). Style : moderne épuré type fintech/voyage premium (réf. Wise, Revolut, Airbnb), avec animations.

## Décisions verrouillées

| Sujet | Décision |
|---|---|
| Direction visuelle | Moderne épuré + animations |
| Couleur accent | Orange chaud (seed ~`#FF6B35`), palette complète autour |
| Typographie | `google_fonts` — sans-serif moderne (Plus Jakarta Sans ou Manrope) |
| Bottom nav | Pill flottante arrondie animée (pas NavigationBar standard) |
| Données écrans | Mock data réaliste codée en dur (remplacée au sous-projet Catalog) |
| Écrans Auth | UI seule — submit no-op / navigation factice ; logique au sous-projet Auth |
| Animations | `flutter_animate`, durées 200–400 ms, stagger d'entrée |
| i18n | Nouvelles clés dans `app_en.arb` (anglais seulement, comme l'existant) |

## 1. Design system

- `lib/core/theme/app_theme.dart` refait :
  - `ColorScheme.fromSeed` avec seed orange chaud `#FF6B35`, light + dark.
  - Couleurs sémantiques additionnelles (succès vert, warning, surfaces différenciées) via extension de thème si nécessaire.
  - `TextTheme` complet basé sur la police Google Fonts choisie.
  - Styles par défaut des composants poussés dans `ThemeData` : `ElevatedButtonTheme`, `InputDecorationTheme`, `CardTheme`, `ChipTheme` — les widgets Material héritent du look sans re-style local.
- `lib/core/theme/app_spacing.dart` : tokens spacing/radius (4/8/12/16/24/32) — pas de magic numbers dans les écrans.
- Dépendances ajoutées : `google_fonts`, `flutter_animate`.

## 2. Composants partagés (`lib/shared/widgets/`)

| Widget | Rôle |
|---|---|
| `AppButton` | Variantes primary/secondary/ghost, états loading/disabled, feedback press (léger scale) |
| `AppCard` | Card standard : radius, ombre douce, padding tokens |
| `AppTextField` | Input stylé : label, erreur, préfixe/icône |
| `PlanCard` | Card forfait data : drapeau pays, opérateur, volume (Go), durée, prix, CTA — réutilisée Home + My Plans |
| `EmptyState` | Icône + titre + sous-texte + CTA optionnel |
| `ShimmerBox` | Placeholder de chargement animé (pour les vrais fetchs futurs) |

## 3. Navigation

- `AppScaffold` refait : bottom bar **pill flottante** arrondie, détachée des bords, ombre douce.
- Animation onglet actif : icône scale + label fade/slide ; indicateur glisse entre onglets (`AnimatedContainer`/`AnimatedAlign`, curve `easeOutCubic`).
- Transition entre tabs : fade-through (Material motion).
- Contrat de routes inchangé : mêmes paths, même `StatefulShellRoute.indexedStack` — les tests existants restent valides.

## 4. Animations transverses

- Entrée d'écran : contenu en stagger (fade + translate Y léger), listes item par item.
- `flutter_animate` pour éviter le boilerplate `AnimationController`.
- Durées courtes 200–400 ms, curves standard ; rien de lent ou gadget.

## 5. Écrans tabs (mock data)

- **Home** : header salutation + champ recherche destination, carrousel horizontal « pays populaires » (drapeaux emoji), section « Forfaits populaires » (liste `PlanCard`), stagger d'entrée. Mock : forfaits Ghana/Togo/Sénégal/Côte d'Ivoire etc.
- **My Plans** : forfait actif en tête (card héro : jauge data restante animée + jours restants), forfaits passés dessous, `EmptyState` si vide.
- **History** : transactions groupées par mois — achat, montant, statut en chip coloré (succès/attente/échec), `EmptyState` si vide.
- **Profile** : avatar + nom, groupes de réglages : compte, toggle thème light/dark branché sur `themeModeProvider` existant, langue, aide, bouton « Se connecter » (mène aux écrans Auth), déconnexion factice.

Les mocks vivent dans la couche `data` de chaque feature (fichier `*_mock.dart` clairement nommé), pour être remplacés proprement par Supabase plus tard.

## 6. Écrans Auth (UI seule)

- Routes `/auth/*` dans go_router, **hors** `StatefulShellRoute` (plein écran, pas de bottom bar).
- **Welcome** (`/auth`) : logo animé, tagline, boutons « Continuer avec Email / Téléphone / Google / Apple / Continuer en invité ».
- **Login** (`/auth/login`) : email + password, lien « mot de passe oublié » (visuel), bouton avec état loading.
- **Signup** (`/auth/signup`) : nom, email, téléphone, password, validation visuelle live des champs (regex simples côté UI).
- Entrée : bouton « Se connecter » dans Profile. Submit = retour Home (no-op). Aucune dépendance Supabase Auth ajoutée.
- Structure : `lib/features/auth/presentation/` (domain/data vides pour l'instant, remplis au sous-projet Auth).

## 7. Erreurs / états

- Pas de logique réseau dans ce chantier → pas de gestion `Result`/`Failure` nouvelle.
- États visuels couverts : loading (bouton, shimmer), vide (`EmptyState`), erreur de champ (`AppTextField`).

## 8. Tests

- Les 8 tests existants restent verts (contrat routes/`AppScaffold` conservé).
- Nouveaux tests widget : boot OK, navigation 4 tabs, écrans Auth s'affichent (welcome/login/signup), `AppButton` états (loading désactive le tap).

## Hors périmètre

- Logique Auth réelle (Supabase, secure storage, biométrie, guard `redirect`) → sous-projet Auth.
- Vraies données forfaits/pays → sous-projet Catalog.
- Français i18n → plus tard (structure déjà prête).
