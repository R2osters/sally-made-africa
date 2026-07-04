# Spec — Redesign v2 « Liquid Glass » (2026-07-04)

Source de vérité : dossier `D:\Sally made africa\TravelConnect Redesign\` — `TravelConnect Design Specs.dc.html` (tokens) + `TravelConnect.dc.html` (prototype interactif, fait foi pour le comportement) + screenshots. Ce document transpose la source en spec Flutter et consigne les déviations.

Remplace intégralement le design system v1 (orange `#FF6B35` / Plus Jakarta Sans, spec 2026-07-03).

## Direction

« Liquid glass » high-tech : fond spatial profond, surfaces en verre dépoli (blancs translucides empilés, jamais de gris opaques), accent bleu électrique → cyan. Trois principes : éditorial pas décoratif ; verre & profondeur (lumière = accent cyan, pas de dégradé plein) ; le globe est le héros (la 3D sert la navigation — choisir un pays).

## Tokens

### Couleurs — sombre (thème principal)
| Token | Valeur |
|---|---|
| bg (canvas) | `#05070F` |
| bg-2 (élevé) | `#0A1120` |
| surface | blanc 4.5% |
| surface-2 | blanc 7% |
| text | `#EAF0FB` |
| dim | `#95A1B8` |
| faint | `#5C6479` |
| border / border-2 | blanc 9% / 16% |
| primary | `#2F80FF` |
| accent-2 (cyan) | `#37E0FF` |
| success | `#2FD98A` |
| warn | `#FFB23E` |
| danger | `#FF5C6C` |

Dégradé primaire : 135°, `#3B8BFF → #2F6BFF` — **seul dégradé autorisé**, réservé aux CTA primaires.

### Couleurs — clair (vrai thème, pas une inversion)
Canvas `#EEF2F9`, élevé `#FFFFFF`, texte `#0B1220`, dim `#586378`, faint `#8B95A8`. Surfaces = `#0C162D` à 4% / 6%, bordures `#0C162D` 9% / 14%. Accent et sémantique inchangés. Le globe garde son écrin sombre.

### Typographie
- **Clash Display** (display) : 600 titres, 500 chiffres clés, letter-spacing −0.02em, jamais en corps.
- **Satoshi** (texte/UI) : 400/500/700/900.

| Rôle | Famille·poids | Taille/interligne |
|---|---|---|
| Display XL (accueil) | Clash 600 | 38 / 1.02 |
| Titre écran | Clash 600 | 30–32 / 1.05 |
| Titre section | Clash 600 | 22–26 / 1.05 |
| Chiffre clé | Clash 600 | 32–52 |
| Corps | Satoshi 400–500 | 15–16 / 1.5 |
| Label/bouton | Satoshi 700 | 14–16 |
| Label section | Satoshi 700 | 12, uppercase, +0.08em, faint |
| Caption/chip | Satoshi 600–700 | 11.5–13 |

Polices via fichiers locaux `assets/fonts/` (Fontshare) — google_fonts retiré du thème.

### Espacements & rayons
Échelle base 4 : 4/8/12/16/22/26/34. Gouttières 22–26. Entre cartes 12–14. Padding cartes 16–18. Padding bas écrans à onglets 128 (dégagement nav). Rayons : pilule 999, input 14–16, bouton 18, carte 20–24, nav/sheet 26–34.

### Verre, élévation, mouvement
- Surfaces : blur 14. Nav : blur 26 + saturate 150%, fond `rgba(12,18,32,.72)`. Sheets : blur 40 + saturate 200% + reflet spéculaire haut.
- Ombres : `0 18px 44px -14px rgba(0,0,0,.8)`. Lueur CTA : `0 14px 34px -10px accent/.7`. Jamais de gris.
- Mouvement : entrée fondu+8px .5s `(.2,.8,.2,1)` en cascade ; sheet montée .42s ; appui scale(.96) ; globe lévitation 6s + rotation continue.

## Composants
- **Boutons** h52–56, r18, Satoshi 700. Primaire = dégradé+lueur ; secondaire = verre+bordure ; fantôme = texte.
- **Chips statut** : pilule, fond couleur 13–14%, texte couleur pleine 700, 11.5.
- **Champ** : h56, r16, icône gauche, label uppercase au-dessus, focus = bordure accent.
- **Carte transaction** : drapeau · pays · sous-ligne op·data·date · montant + chip. Groupées par mois dans UN conteneur verre, séparateurs 1px.
- Carte opérateur (pastille couleur marque + chevron), carte forfait (data en Clash + prix **cyan**), carte plan actif (barre progression + anneau conique), nav 4 onglets pilule verre actif cyan, sheet à poignée r34.

## Écrans (11, FR/EN, sombre+clair)
1. **Bienvenue** — globe 3D étoilé, badge « DATA MOBILE · AFRIQUE », display XL, Créer un compte / J'ai déjà un compte / Continuer en invité, toggle FR/EN.
2. **Connexion** — email+password, mot de passe oublié, footer inscription.
3. **Inscription** — nom+email+password, notice CGU, footer connexion.
4. **OTP** — 4 cases, numéro masqué `+221 77 •• •• 42`, Vérifier, « Renvoyer le code dans 00:24 ».
5. **Explorer (Home)** — « Bienvenue Aïssatou 👋 », prompt globe, globe interactif (drag/rotation, dots cyan sur 8 pays servis, labels drapeaux tappables), hint « Glisser · pincer », Destinations populaires (6 cartes : drapeau, nom, N opérateurs, dès prix), cloche notifications.
6. **Sheet opérateurs** → **sheet forfaits** — pays → opérateurs (pastille marque) → 4 forfaits (data Clash, durée, prix cyan, tier 1 « hot »).
7. **Détail forfait** — header op+pays, data géante, specs (couverture/validité/débit 4G-5G/eSIM instant), total, Acheter.
8. **Paiement** — résumé forfait, 5 moyens (MTN MoMo, Orange Money, Moov Money, Wave, Carte) sélection anneau cyan, total, Payer maintenant, mention sécurisé.
9. **Succès** — check, « Forfait activé ! », carte plan, chip Actif, Voir mes forfaits / Retour accueil.
10. **Mes forfaits** + **Plan actif** — cartes progression ; plan actif : anneau conique 3,7/6 Go, 5 jours restants, QR factice, Installer l'eSIM / Recharger.
11. **Historique / Profil / Notifications** — history groupé par mois (statuts réussi/attente/échoué) ; profil (avatar initiales AD, compte, réglages : langue+mode sombre+notifs+biométrie, support, déconnexion, v1.0) ; notifications (4 items, icônes colorées, unread).

## Données mock (du prototype)
- 8 pays : SN, CI, GH, NG, TG, BJ, BF, ML — lat/lon, devise (XOF/GHS/NGN), 2–3 opérateurs chacun.
- 11 opérateurs avec couleur marque : MTN `#FFCC00`, Orange `#FF7900`, Moov `#0A58CA`, AirtelTigo/Telecel `#E4002B`, Glo `#00A651`, Free `#E2001A`, Expresso `#F58220`, Celtiis `#17A398`, Togocom `#E30613`, Malitel `#12B24A`.
- 4 tiers : 1,5 Go/24h · 6 Go/7j · 15 Go/30j · 40 Go/30j. Prix : XOF [900, 3500, 7900, 14900], GHS [12, 45, 99, 180], NGN [900, 3500, 8000, 15000]. Format : `3 500 FCFA`, `₵99`, `₦900`.
- Utilisateur démo : Aïssatou Diallo, aissatou@travelconnect.io, +221 77 123 45 42, membre depuis 2024.
- My plans (3), history (juil./juin 2026), notifications (4) : valeurs exactes du proto.

## i18n
FR **et** EN dès maintenant (arb files), toutes les clés du proto. Toggle langue persisté (welcome + profil). FR = langue par défaut du proto.

## Déviations assumées vs prototype
1. **Globe : CustomPaint, pas Three.js.** Sphère sombre + graticule + étoiles + halo atmosphère + dots/labels des 8 pays projetés (lat/lon → orthographique), rotation continue + drag horizontal, tap label → sheet opérateurs. Pas de texture frontières réelles ni pinch-zoom en v1 (coût/valeur ; nav assurée aussi par Destinations populaires).
2. **Drapeaux : emoji** (déjà dans les données), pas flagcdn.com — zéro dépendance réseau, tests hermétiques. Basculer vers assets images plus tard si rendu emoji insuffisant sur Android.
3. **QR : factice** (même algorithme déterministe que le proto), remplacé par le vrai LPA au sous-projet Purchase/eSIM.
4. Auth reste UI-only (submits → /home) — la vraie logique arrive au sous-projet Auth.
5. Statut bar iOS « 9:41 » du mockup : non reproduite (OS réel).

## Non-buts
Pas de logique Supabase, pas de vrais paiements, pas de provisioning eSIM, pas de push. UI + navigation + mocks seulement. Architecture (features, Riverpod, go_router, Result/Failure) inchangée.
