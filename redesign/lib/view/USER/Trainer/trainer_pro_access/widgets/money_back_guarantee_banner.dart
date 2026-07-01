import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);
const kSurface = Color(0xFF0E0E0E);

class MoneyBackGuaranteeBanner extends StatelessWidget {
  MoneyBackGuaranteeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_rounded, color: kGreen, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7-Day Money Back Guarantee',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'If your application is rejected or you change your mind within 7 days, get a full refund.',
                  style: TextStyle(color: kMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
