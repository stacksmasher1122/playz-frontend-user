import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmartPresetsCard extends StatelessWidget {
  final VoidCallback onApply;

  SmartPresetsCard({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(8)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          border: Border.all(color: kAccentDim),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(8)),
              decoration: BoxDecoration(
                color: kAccentDim,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
              ),
              child: Icon(Icons.auto_awesome, color: kAccent, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Setup",
                    style: TextStyle(
                      color: kTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Used in 72% of friendly games",
                    style: TextStyle(color: kTextSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onApply,
              child: Text(
                "Apply Standard",
                style: TextStyle(color: kAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
