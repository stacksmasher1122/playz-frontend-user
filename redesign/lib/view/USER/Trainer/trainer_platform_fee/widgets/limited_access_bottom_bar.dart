import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);

class LimitedAccessBottomBar extends StatelessWidget {
  LimitedAccessBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: kCard)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// PRIMARY CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.black,
                  padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
                  ),
                ),
                child: Text(
                  'Upgrade to Trainer Pro ↗',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            /// SECONDARY CTA
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side:
                    BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                padding:
                    EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14), horizontal: ResponsiveHelper.w(14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
                ),
              ),
              child: Text(
                'Continue with Limited Access',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
