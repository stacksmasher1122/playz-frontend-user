import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StickyCtaButton extends StatelessWidget {
  final MatchMode mode;
  final bool isActive;
  final VoidCallback onTap;

  StickyCtaButton({
    super.key,
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: kBg,
        boxShadow: [
          BoxShadow(
            color: kAccent.withValues(alpha: 0.05),
            blurRadius: 32,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isActive ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.black,
          minimumSize: Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          ),
          elevation: 0,
        ),
        child: Text(
          mode == MatchMode.friendly ? "START MATCH" : "CREATE TOURNAMENT",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: ResponsiveHelper.sp(16),
          ),
        ),
      ),
    );
  }
}
