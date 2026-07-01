import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmSquadButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  ConfirmSquadButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Colors.black, // Dark background behind sticky button
        border: Border(
          top: BorderSide(color: Colors.grey.shade900),
        ),
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFFC6FF00).withValues(alpha: 0.3), // Lime Green glow
                blurRadius: 16,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                decoration: BoxDecoration(
                  color: Color(0xFFC6FF00), // Lime Green
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.black, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'CONFIRM SQUAD',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
