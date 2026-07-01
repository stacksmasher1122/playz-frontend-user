import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CancellationPolicyBanner extends StatelessWidget {
  CancellationPolicyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: Colors.red),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Free cancellation up to 4 hours before the booked slot. 50% refund thereafter.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
