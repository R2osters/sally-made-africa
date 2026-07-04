# Plan — Redesign v2 « Liquid Glass » (2026-07-04)

Spec : `docs/superpowers/specs/2026-07-04-liquid-glass-redesign-design.md`. Branche : `claude/strange-colden-336451`. Contrat : `flutter analyze` propre + tests verts à chaque commit.

## Tâches (ordre d'exécution)

1. **Polices locales** — copier OTF Fontshare (ClashDisplay Medium/Semibold ; Satoshi Regular/Medium/Bold/Black) dans `assets/fonts/`, déclarer familles `ClashDisplay`/`Satoshi` dans pubspec, retirer google_fonts des thèmes (dépendance conservée tant qu'utilisée ailleurs, sinon retirée).
2. **Design system** — `lib/core/theme/app_colors.dart` (2 palettes + alias sémantiques), refonte `app_theme.dart` (textTheme Clash/Satoshi, component themes : boutons, inputs, chips, sheets, nav), `app_spacing.dart` mis à jour (échelle 4, rayons spec), `lib/shared/widgets/glass.dart` (GlassCard/GlassSheet : BackdropFilter blur param + bordure + reflet).
3. **i18n** — `app_fr.arb` complet + `app_en.arb` enrichi (toutes clés proto), `localeProvider` persisté (mimique themeModeProvider, garde `loaded`), câblage MaterialApp.
4. **Mocks** — `lib/features/catalog/{domain,data}` : Country, Operator, PlanSpec, prix/formatage devise ; `payment_methods_mock`, refonte `my_plans_mock`, `history_mock`, `notifications_mock`, utilisateur démo.
5. **Widgets partagés** — AppButton (3 variants), AppTextField, StatusChip, nav pill verre (actif cyan), `GlobeView` CustomPaint (rotation, drag, dots+labels tappables, étoiles, atmosphère).
6. **Auth** — welcome/login/signup restylés + OTP (`/auth/otp`).
7. **Explorer** — home (greeting, globe, populaires, cloche) + sheet opérateurs + sheet forfaits.
8. **Achat** — `/plan-detail`, `/checkout`, `/success` (hors shell), état sélection via provider éphémère ou passage d'objet.
9. **Mes forfaits / Plan actif** — liste progression + `/active-plan` (anneau conique CustomPaint, QR factice CustomPaint).
10. **Historique / Profil / Notifications** — groupes mois, profil complet (toggles langue/sombre/notifs/biométrie), `/notifications`.
11. **Clôture** — routes complètes, tests adaptés + smoke tests nouveaux écrans, analyze propre, HANDOFF.md mis à jour, commits par tranche.

## Risques
- Emoji drapeaux ternes sur certains Android → déviation notée, bascule assets possible.
- BackdropFilter coûteux si empilé → limiter aux surfaces majeures (nav, sheets, cartes de premier plan), surfaces simples = couleur translucide sans blur.
- Suppression google_fonts : gotcha testWidgets du HANDOFF disparaît avec elle (polices locales synchrones).
