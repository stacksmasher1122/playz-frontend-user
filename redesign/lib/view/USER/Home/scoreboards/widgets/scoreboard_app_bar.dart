import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class ScoreboardAppBar extends StatelessWidget {
  ScoreboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scoreboards',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(22),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Live scores & real competition',
                    style: TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            CircleIcon(Icons.add, fill: kGreen),
          ],
        ),
      ),
    );
  }
}

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color? fill;
  CircleIcon(this.icon, {super.key, this.fill});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(10)),
      decoration: BoxDecoration(
        color: fill ?? kSurface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: fill != null ? Colors.black : Colors.white),
    );
  }
}
