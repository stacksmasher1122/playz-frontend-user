import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class InfoActionButtons extends StatelessWidget {
  InfoActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(Icons.search, "SEARCH", () {}),
        SizedBox(width: 16),
        _buildActionButton(Icons.share, "SHARE", () {}),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.w(80),
        height: ResponsiveHelper.h(80),
        decoration: BoxDecoration(
          color: _kSurface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: _kMuted,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
