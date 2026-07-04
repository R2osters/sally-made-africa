import 'package:flutter/material.dart';

/// Real flag image (bundled PNG per served country), rounded + soft shadow
/// like the prototype. Falls back to the emoji when no asset exists.
class FlagImage extends StatelessWidget {
  final String countryId;
  final String flagEmoji;
  final double width;

  const FlagImage({
    super.key,
    required this.countryId,
    required this.flagEmoji,
    this.width = 36,
  });

  @override
  Widget build(BuildContext context) {
    final height = width * 0.72;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.16),
        child: Image.asset(
          'assets/flags/$countryId.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SizedBox(
            width: width,
            height: height,
            child: Center(
              child:
                  Text(flagEmoji, style: TextStyle(fontSize: width * 0.55)),
            ),
          ),
        ),
      ),
    );
  }
}
