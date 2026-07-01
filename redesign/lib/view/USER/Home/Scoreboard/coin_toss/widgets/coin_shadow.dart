import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CoinShadow extends StatelessWidget {
  final double shadowValue;

  CoinShadow({super.key, required this.shadowValue});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Transform.translate(
      offset: Offset(0, 125),
      child: Opacity(
        opacity: shadowValue * 0.35,
        child: Container(
          width: 160 * shadowValue,
          height: 20 * shadowValue,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.black,
                Colors.black.withValues(alpha: 0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
