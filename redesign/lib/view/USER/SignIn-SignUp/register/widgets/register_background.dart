import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.heightPct(42);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(context.minDimensionPct(10)),
        bottomRight: Radius.circular(context.minDimensionPct(10)),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            /// ARTIFICIAL TURF GRASS BACKGROUND IMAGE (NO GREEN GRADIENT OVERLAY & NO Z TEXT)
            Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/006/981/368/small/artificial-turf-of-soccer-football-field-photo.jpg',
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.network(
                'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=1200&auto=format&fit=crop&q=80',
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            /// LIGHT GRADIENT OVERLAY FOR SMOOTH BLEND
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
