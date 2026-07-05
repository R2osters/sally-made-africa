import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../domain/esim_installer.dart';

/// Real provisioning path from the esim-integration program:
/// backend orders the profile from the operator/aggregator and returns the
/// LPA string; the OS installs it via the `app/esim` platform channel
/// (Android EuiccManager / iOS CTCellularPlanProvisioning.addPlan).
/// Wire-up steps: docs/esim-native-integration.md.
class NativeEsimInstaller implements EsimInstaller {
  final String backendUrl;

  const NativeEsimInstaller({required this.backendUrl});

  static const _channel = MethodChannel('app/esim');

  @override
  Future<String> order({required String planId, required String userId}) async {
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'plan': planId, 'userId': userId}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'eSIM order failed: ${response.statusCode} ${response.body}');
    }
    return jsonDecode(response.body)['lpa'] as String;
  }

  @override
  Future<void> install(String lpa) =>
      _channel.invokeMethod('install', {'lpa': lpa});
}
