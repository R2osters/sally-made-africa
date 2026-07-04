import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../features/catalog/domain/catalog_models.dart';
import 'flag_image.dart';
import 'world_geometry.dart';

/// The hero globe — stylised CustomPaint replacement for the prototype's
/// Three.js scene (deviation logged in the redesign spec): dark sphere,
/// graticule, starfield, atmosphere glow, cyan markers on served countries,
/// continuous rotation + horizontal drag. Tapping a country label calls
/// [onCountryTap]; that is real navigation, not decoration.
class GlobeView extends StatefulWidget {
  final List<Country> countries;
  final ValueChanged<Country>? onCountryTap;
  final bool showLabels;

  const GlobeView({
    super.key,
    required this.countries,
    this.onCountryTap,
    this.showLabels = true,
  });

  @override
  State<GlobeView> createState() => _GlobeViewState();
}

class _GlobeViewState extends State<GlobeView>
    with SingleTickerProviderStateMixin {
  static final bool _isTestEnv =
      !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  late final AnimationController _spin;
  // Face West Africa on load, like the prototype.
  double _dragY = -1.5;
  double _tiltX = 0.42;
  // Pinch zoom (prototype: cam 1.65–4.6 ≈ radius factor range below).
  double _zoom = 1.0;
  double _zoomStart = 1.0;
  List<WorldPolygon>? _world;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    );
    // A repeating controller would hang pumpAndSettle — static in tests.
    if (!_isTestEnv) _spin.repeat();
    _world = WorldGeometry.maybeLoaded;
    if (_world == null) {
      WorldGeometry.load().then((polys) {
        if (mounted) setState(() => _world = polys);
      });
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  double get _rotY => _dragY + _spin.value * 2 * math.pi;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      // Scale gestures subsume pan: 1 finger drags (rotate), 2 pinch (zoom).
      onScaleStart: (_) => _zoomStart = _zoom,
      onScaleUpdate: (d) => setState(() {
        _dragY += d.focalPointDelta.dx * 0.006 / _zoom;
        _tiltX =
            (_tiltX + d.focalPointDelta.dy * 0.005 / _zoom).clamp(-0.9, 0.9);
        if (d.scale != 1.0) {
          _zoom = (_zoomStart * d.scale).clamp(0.7, 2.2);
        }
      }),
      onDoubleTap: () =>
          setState(() => _zoom = _zoom > 1.2 ? 1.0 : 1.7),
      child: AnimatedBuilder(
        animation: _spin,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size =
                  Size(constraints.maxWidth, constraints.maxHeight);
              final projections = _project(size);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: size,
                    painter: _GlobePainter(
                      rotY: _rotY,
                      tiltX: _tiltX,
                      zoom: _zoom,
                      markers: projections,
                      world: _world,
                      dark: isDark,
                    ),
                  ),
                  if (widget.showLabels)
                    for (final p in projections)
                      if (p.visible)
                        Positioned(
                          left: p.offset.dx,
                          top: p.offset.dy - 34,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0),
                            child: Opacity(
                              opacity: p.opacity,
                              child: _CountryLabel(
                                country: p.country,
                                onTap: widget.onCountryTap == null
                                    ? null
                                    : () => widget.onCountryTap!(p.country),
                              ),
                            ),
                          ),
                        ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<_MarkerProjection> _project(Size size) {
    final radius = math.min(size.width, size.height) * 0.42 * _zoom;
    final center = Offset(size.width / 2, size.height / 2);
    return widget.countries.map((c) {
      final v = _sphericalToRotated(c.lat, c.lon, _rotY, _tiltX);
      final visible = v.z > 0.12;
      return _MarkerProjection(
        country: c,
        offset: center + Offset(v.x * radius, -v.y * radius),
        visible: visible,
        opacity: visible ? ((v.z - 0.12) * 3.2).clamp(0.0, 1.0) : 0,
      );
    }).toList();
  }
}

class _MarkerProjection {
  final Country country;
  final Offset offset;
  final bool visible;
  final double opacity;

  const _MarkerProjection({
    required this.country,
    required this.offset,
    required this.visible,
    required this.opacity,
  });
}

class _Vec3 {
  final double x, y, z;
  const _Vec3(this.x, this.y, this.z);
}

/// lat/lon on the unit sphere, rotated by rotY (spin) then tiltX.
_Vec3 _sphericalToRotated(double lat, double lon, double rotY, double tiltX) {
  final phi = (90 - lat) * math.pi / 180;
  final theta = (lon + 180) * math.pi / 180;
  var x = -math.sin(phi) * math.cos(theta);
  final y0 = math.cos(phi);
  var z = math.sin(phi) * math.sin(theta);
  // Spin around Y.
  final cy = math.cos(rotY), sy = math.sin(rotY);
  final x1 = x * cy + z * sy;
  final z1 = -x * sy + z * cy;
  x = x1;
  z = z1;
  // Tilt around X.
  final cx = math.cos(tiltX), sx = math.sin(tiltX);
  final y1 = y0 * cx - z * sx;
  final z2 = y0 * sx + z * cx;
  return _Vec3(x, y1, z2);
}

/// Theme-aware globe palette — dark keeps the prototype's space look,
/// light is a soft day variant so the globe follows the app theme.
class _GlobeTheme {
  final List<Color> ocean;
  final Color land;
  final Color landStroke;
  final Color atmosphere;
  final Color star;
  final Color rim;
  final Color graticule;

  const _GlobeTheme({
    required this.ocean,
    required this.land,
    required this.landStroke,
    required this.atmosphere,
    required this.star,
    required this.rim,
    required this.graticule,
  });

  static const dark = _GlobeTheme(
    ocean: [Color(0xFF12294A), Color(0xFF0A1F38), Color(0xFF08182E)],
    land: Color(0xFF17293F),
    landStroke: Color(0x8C82A5CD),
    atmosphere: Color(0xFF2F9BFF),
    star: Color(0xFFBCD4FF),
    rim: Color(0x803C78C8),
    graticule: Color(0x242F6BFF),
  );

  static const light = _GlobeTheme(
    ocean: [Color(0xFFDCEAFB), Color(0xFFC6DCF6), Color(0xFFB3CFF0)],
    land: Color(0xFFF4F8FE),
    landStroke: Color(0x734A6B96),
    atmosphere: Color(0xFF7FB4FF),
    star: Color(0x33456A9E),
    rim: Color(0x66688FC4),
    graticule: Color(0x1F2F6BFF),
  );
}

class _GlobePainter extends CustomPainter {
  final double rotY;
  final double tiltX;
  final double zoom;
  final List<_MarkerProjection> markers;
  final List<WorldPolygon>? world;
  final bool dark;

  const _GlobePainter({
    required this.rotY,
    required this.tiltX,
    required this.zoom,
    required this.markers,
    this.world,
    this.dark = true,
  });

  _GlobeTheme get _t => dark ? _GlobeTheme.dark : _GlobeTheme.light;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42 * zoom;

    _paintStars(canvas, size);

    // Atmosphere glow.
    canvas.drawCircle(
      center,
      radius * 1.16,
      Paint()
        ..color = _t.atmosphere.withOpacity(dark ? 0.35 : 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26),
    );

    // Ocean sphere (prototype's canvas gradient).
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.15,
          colors: _t.ocean,
          stops: const [0, 0.55, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    _paintGraticule(canvas, center, radius);
    if (world != null) _paintLand(canvas, center, radius);

    // Rim light.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = _t.rim,
    );

    // Served-country markers (labels are widgets above the canvas).
    for (final m in markers) {
      if (!m.visible) continue;
      final dot = Paint()..color = AppColors.accent.withOpacity(m.opacity);
      canvas.drawCircle(
        m.offset,
        9,
        Paint()
          ..color = AppColors.accent.withOpacity(0.28 * m.opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(m.offset, 3.4, dot);
    }
  }

  /// Country outlines projected orthographically. Points on the far side
  /// are clamped to the horizon so rings stay closed (mild edge distortion,
  /// invisible at this size). Served countries get the prototype's vivid
  /// blue→cyan fill with a glow pass.
  void _paintLand(Canvas canvas, Offset center, double radius) {
    final landFill = Paint()..color = _t.land;
    final landStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _t.landStroke;
    final servedFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2F86FF), Color(0xFF37E0FF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    final servedGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = const Color(0xFF3CE0FF).withOpacity(0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final servedStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0xFFCDF6FF);

    final clip = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clip);

    for (final servedPass in [false, true]) {
      for (final poly in world!) {
        if (poly.served != servedPass) continue;
        final path = _polyPath(poly, center, radius);
        if (path == null) continue;
        if (poly.served) {
          canvas.drawPath(path, servedGlow);
          canvas.drawPath(path, servedFill);
          canvas.drawPath(path, servedStroke);
        } else {
          canvas.drawPath(path, landFill);
          canvas.drawPath(path, landStroke);
        }
      }
    }
    canvas.restore();
  }

  Path? _polyPath(WorldPolygon poly, Offset center, double radius) {
    Path? path;
    for (final ring in poly.rings) {
      var anyVisible = false;
      final points = <Offset>[];
      for (final pt in ring) {
        final v = _sphericalToRotated(pt[1], pt[0], rotY, tiltX);
        double x = v.x, y = v.y;
        if (v.z > 0) {
          anyVisible = true;
        } else {
          // Clamp far-side points onto the horizon circle.
          final len = math.sqrt(x * x + y * y);
          if (len == 0) continue;
          x /= len;
          y /= len;
        }
        points.add(center + Offset(x * radius, -y * radius));
      }
      if (!anyVisible || points.length < 3) continue;
      path ??= Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      path.close();
    }
    return path;
  }

  void _paintStars(Canvas canvas, Size size) {
    // Deterministic starfield (subtle specks in light mode).
    final rnd = math.Random(97);
    final paint = Paint();
    final baseOpacity = dark ? 0.25 : 0.06;
    final varOpacity = dark ? 0.5 : 0.10;
    for (var i = 0; i < 90; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final r = rnd.nextDouble() * 1.1 + 0.3;
      paint.color = _t.star
          .withOpacity(baseOpacity + rnd.nextDouble() * varOpacity);
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  void _paintGraticule(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _t.graticule;

    Offset? prev;
    void polyline(double lat, double lon, bool reset) {
      final v = _sphericalToRotated(lat, lon, rotY, tiltX);
      if (v.z <= 0.02) {
        prev = null;
        return;
      }
      final p = center + Offset(v.x * radius, -v.y * radius);
      if (prev != null && !reset) canvas.drawLine(prev!, p, paint);
      prev = p;
    }

    for (double lat = -60; lat <= 60; lat += 30) {
      prev = null;
      var first = true;
      for (double lon = -180; lon <= 180; lon += 5) {
        polyline(lat, lon, first);
        first = false;
      }
    }
    for (double lon = -180; lon < 180; lon += 30) {
      prev = null;
      var first = true;
      for (double lat = -85; lat <= 85; lat += 5) {
        polyline(lat, lon, first);
        first = false;
      }
    }
  }

  @override
  bool shouldRepaint(_GlobePainter old) =>
      old.rotY != rotY ||
      old.tiltX != tiltX ||
      old.zoom != zoom ||
      old.world != world ||
      old.dark != dark;
}

class _CountryLabel extends StatelessWidget {
  final Country country;
  final VoidCallback? onTap;

  const _CountryLabel({required this.country, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: dark ? const Color(0xE6080E1A) : const Color(0xF0FFFFFF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: (dark ? AppColors.accent : AppColors.primary)
                  .withOpacity(0.45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.7 : 0.25),
              blurRadius: 18,
              spreadRadius: -6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlagImage(
                countryId: country.id,
                flagEmoji: country.flagEmoji,
                width: 19),
            const SizedBox(width: 6),
            Text(
              country.name,
              style: TextStyle(
                fontFamily: AppTheme.textFamily,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: dark
                    ? const Color(0xFFEAF0FB)
                    : const Color(0xFF0B1220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
