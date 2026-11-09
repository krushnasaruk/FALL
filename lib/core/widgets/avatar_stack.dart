import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  final List<String>? avatarUrls;
  final List<Color>? fallbackColors;
  final double size;
  final double overlap;
  final int maxAvatars;

  const AvatarStack({
    super.key,
    this.avatarUrls,
    this.fallbackColors,
    this.size = 22.0,
    this.overlap = 8.0,
    this.maxAvatars = 3,
  });

  static const List<Color> _defaultColors = [
    Color(0xFFFF8FA3),
    Color(0xFF6ED4F8),
    Color(0xFFB392F0),
    Color(0xFF81E6D9),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = fallbackColors ?? _defaultColors;
    final count = maxAvatars;

    return SizedBox(
      height: size,
      width: size + (count - 1) * (size - overlap),
      child: Stack(
        children: List.generate(count, (index) {
          final left = index * (size - overlap);
          final color = colors[index % colors.length];

          return Positioned(
            left: left,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: size * 0.6,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
