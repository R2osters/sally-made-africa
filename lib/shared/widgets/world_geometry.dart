import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// World country outlines (world-atlas 110m, converted at build time to
/// `assets/geo/world_110m.json`). Loaded once, cached statically.
class WorldPolygon {
  /// ISO-3166 numeric id when the country is served by TravelConnect
  /// (highlighted on the globe), empty otherwise.
  final String servedId;

  /// Outer rings, each a list of [lon, lat] pairs.
  final List<List<List<double>>> rings;

  const WorldPolygon({required this.servedId, required this.rings});

  bool get served => servedId.isNotEmpty;
}

abstract final class WorldGeometry {
  static List<WorldPolygon>? _cache;
  static Future<List<WorldPolygon>>? _loading;

  static List<WorldPolygon>? get maybeLoaded => _cache;

  static Future<List<WorldPolygon>> load() {
    if (_cache != null) return Future.value(_cache);
    return _loading ??= rootBundle
        .loadString('assets/geo/world_110m.json')
        .then((raw) {
      final data = jsonDecode(raw) as List<dynamic>;
      _cache = [
        for (final p in data)
          WorldPolygon(
            servedId: (p['i'] as String?) ?? '',
            rings: [
              for (final ring in p['r'] as List<dynamic>)
                [
                  for (final pt in ring as List<dynamic>)
                    [
                      (pt[0] as num).toDouble(),
                      (pt[1] as num).toDouble(),
                    ],
                ],
            ],
          ),
      ];
      return _cache!;
    });
  }
}
