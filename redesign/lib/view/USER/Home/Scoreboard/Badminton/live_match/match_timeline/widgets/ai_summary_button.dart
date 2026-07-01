import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AiSummaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  AiSummaryButton({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: Color(0xFFC6FF00), // Neon Yellow-Green
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: ResponsiveHelper.w(20),
                  height: ResponsiveHelper.h(20),
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2.0,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.black,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'AI MATCH SUMMARY',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
