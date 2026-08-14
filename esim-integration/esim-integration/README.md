# Intégration eSIM — Flutter (Android + iOS) + backend Node

Provisioning d'une eSIM temporaire : le backend commande le profil chez l'opérateur et
renvoie un code d'activation (chaîne LPA), l'app le remet à l'OS qui installe le profil.

## Comment ça marche

1. **Backend** : appelle l'API de l'opérateur/agrégateur, récupère la chaîne
   `LPA:1$adresse-SMDP+$matching-id`.
2. **App Flutter** : envoie la commande au backend, reçoit le LPA.
3. **Code natif** : remet le LPA au système.
   - Android : `EuiccManager`.
   - iOS : `CTCellularPlanProvisioning.addPlan`.

L'app ne manipule jamais le profil lui-même — c'est l'eUICC de l'appareil qui le télécharge
depuis le serveur de l'opérateur.

## Où placer chaque fichier

| Fichier | Destination dans ton projet |
|---|---|
| `backend/esim-client.js` | ton serveur Node |
| `backend/route.js` | ton serveur Node |
| `flutter/esim_service.dart` | `lib/` |
| `android/MainActivity.kt` | `android/app/src/main/kotlin/<ton/package>/` |
| `ios/AppDelegate.swift` | `ios/Runner/` (remplace l'existant) |
| `ios/Runner.entitlements` | `ios/Runner/` |

---

## 1. Backend (Node 18+)

Variables d'environnement :

```
ESIM_API_URL=https://api.ton-operateur.com
ESIM_API_KEY=ton_token
```

Monte la route dans ton app Express :

```js
import esimRoute from "./route.js";
app.use("/api", esimRoute);   // -> POST /api/esim
```

⚠️ Adapte les noms de champs dans `esim-client.js` à la réponse réelle de ton opérateur
(`smdp_address`, `matching_id`, `lpa`... varient d'un fournisseur à l'autre).

## 2. Flutter

Fusionne dans `pubspec.yaml` (voir `pubspec-add.yaml`) :

```yaml
dependencies:
  http: ^1.2.0
```

Dans `esim_service.dart`, remplace l'URL `_backend` par celle de ton serveur.

## 3. Android

- Place `MainActivity.kt` et remplace le package `com.tonapp.esim` par ton `applicationId`.
- Aucune permission spéciale à déclarer : le système gère lui-même le consentement.
- L'installation totalement silencieuse exige les **carrier privileges** (l'opérateur ajoute
  la signature de ton app dans la config de la SIM). Sinon, l'OS affiche un écran de
  confirmation déjà pré-rempli.

## 4. iOS

- Remplace `AppDelegate.swift`.
- Ajoute `Runner.entitlements`, puis lie-le dans Xcode → *Signing & Capabilities*.
- L'entitlement `com.apple.CommCenter.fine-grained` / `public-cellular-plan` n'est actif que
  si Apple te l'a accordé (réservé aux opérateurs sous contrat). Il doit apparaître dans ton
  provisioning profile.

---

## Utilisation

```dart
final lpa = await EsimService.commander(plan: "7j-1Go", userId: user.id);
await EsimService.installer(lpa);
```

## Pièges qui font échouer l'installation

- **iOS renvoie `.unknown` en boucle** : il manque la référence forte à
  `CTTelephonyNetworkInfo` (propriété `networkInfo` dans l'AppDelegate). Ne jamais la mettre
  en variable locale.
- **Simulateur** : l'eSIM ne fonctionne que sur appareil réel (iOS 12+ / Android 9+).
- **iOS sans entitlement** : l'API ne répond pas. L'entitlement est réservé aux MNO sous
  contrat avec Apple.
- **Feuille de confirmation** : même avec entitlement (iOS) ou carrier privileges (Android),
  une confirmation système peut s'afficher. L'utilisateur ne saisit rien, il valide.
