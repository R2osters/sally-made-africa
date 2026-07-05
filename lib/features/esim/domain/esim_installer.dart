/// eSIM provisioning contract, mirroring the esim-integration program:
/// 1. order the profile from the operator/aggregator → LPA activation code
/// 2. hand the LPA to the OS (Android EuiccManager / iOS addPlan)
abstract class EsimInstaller {
  /// Orders the eSIM profile and returns the LPA activation string
  /// (`LPA:1$smdp-address$matching-id`).
  Future<String> order({required String planId, required String userId});

  /// Installs the profile via the platform channel; the device eUICC
  /// downloads it from the operator's SM-DP+ server.
  Future<void> install(String lpa);
}
