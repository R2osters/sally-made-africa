import '../domain/esim_installer.dart';

/// Showcase installer: 2-second fake provisioning, always succeeds.
/// Swapped for [NativeEsimInstaller] once the backend and operator
/// credentials exist (see docs/esim-native-integration.md).
class MockEsimInstaller implements EsimInstaller {
  const MockEsimInstaller();

  @override
  Future<String> order({required String planId, required String userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return 'LPA:1\$mock-smdp.travelconnect.io\$$planId';
  }

  @override
  Future<void> install(String lpa) =>
      Future<void>.delayed(const Duration(milliseconds: 1400));
}
