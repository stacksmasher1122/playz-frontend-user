import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class FeeSuccessBottomBar extends StatelessWidget {
  FeeSuccessBottomBar({super.key});

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
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainerAppNavShell()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
                  ),
                ),
                child: Text(
                  'Go to Trainer Dashboard',
                  style: TextStyle(fontSize: ResponsiveHelper.sp(16), fontWeight: FontWeight.w800),
                ),
              ),
            ),

            SizedBox(height: 10),

            /// SECONDARY CTA
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: kGreen,
                side: BorderSide(color: kGreen),
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
                ),
              ),
              child: Text(
                'View Membership Details',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            SizedBox(height: 8),

            GestureDetector(
              onTap: () {},
              child: Text(
                'Need help? Contact Support',
                style: TextStyle(
                  color: kMuted,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
