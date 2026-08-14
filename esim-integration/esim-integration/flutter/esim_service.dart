// esim_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class EsimService {
  // Remplace par l'URL de ton backend.
  static const _backend = "https://ton-backend.com/api/esim";
  static const _channel = MethodChannel("app/esim");

  // 1) Commande l'eSIM chez l'opérateur -> récupère la chaîne LPA
  static Future<String> commander({
    required String plan,
    required String userId,
  }) async {
    final r = await http.post(
      Uri.parse(_backend),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"plan": plan, "userId": userId}),
    );
    if (r.statusCode != 200) {
      throw Exception("Commande eSIM échouée : ${r.statusCode} ${r.body}");
    }
    return jsonDecode(r.body)["lpa"] as String;
  }

  // 2) Installe l'eSIM via le code natif (Android EuiccManager / iOS addPlan)
  static Future<void> installer(String lpa) async {
    await _channel.invokeMethod("install", {"lpa": lpa});
  }
}
