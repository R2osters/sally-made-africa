import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/mock_esim_installer.dart';
import 'domain/esim_installer.dart';

/// Mock in the showcase build. Swap for NativeEsimInstaller(backendUrl: …)
/// when the eSIM backend goes live.
final esimInstallerProvider =
    Provider<EsimInstaller>((ref) => const MockEsimInstaller());
