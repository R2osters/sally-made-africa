# Activer la vraie installation eSIM

La maquette utilise `MockEsimInstaller` (2 s, succès simulé). Le vrai flux est prêt dans `lib/features/esim/` et suit le programme `esim-integration/` (racine du projet principal) :

1. **Backend Node** — déployer `esim-integration/backend/` (`esim-client.js` + `route.js`), variables `ESIM_API_URL` / `ESIM_API_KEY` de l'agrégateur. Expose `POST /api/esim` → `{ "lpa": "LPA:1$..." }`.
2. **Android** — fusionner `esim-integration/android/MainActivity.kt` dans `android/app/src/main/kotlin/com/travelconnect/travelconnect/MainActivity.kt` (adapter le `package`). Channel `app/esim`, `EuiccManager.downloadSubscription` (Android 9+). Vérifier `androidx.core ≥ 1.9` (RECEIVER_NOT_EXPORTED).
3. **iOS** — remplacer `ios/Runner/AppDelegate.swift` par `esim-integration/ios/AppDelegate.swift` et ajouter `esim-integration/ios/Runner.entitlements` (entitlement eSIM Apple — nécessite l'accord carrier d'Apple). Garder la référence forte `CTTelephonyNetworkInfo`.
4. **Flutter** — dans `lib/features/esim/esim_provider.dart`, remplacer :
   ```dart
   Provider<EsimInstaller>((ref) => const MockEsimInstaller());
   ```
   par :
   ```dart
   Provider<EsimInstaller>(
     (ref) => const NativeEsimInstaller(backendUrl: 'https://ton-backend.com/api/esim'),
   );
   ```

Rien d'autre à changer : l'UI (popup d'installation, notifications) consomme l'interface `EsimInstaller`.
