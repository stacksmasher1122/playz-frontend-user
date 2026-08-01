import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Friends_SQF/friendsSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Groups_SQF/groupsSqflite.dart';
import 'package:redesign/view/USER/SignIn-SignUp/login/login_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final iconContainerSize = context.minDimensionPct(14).clamp(48.0, 60.0);
    final buttonHeight = context.heightPct(6).clamp(44.0, 52.0);

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(6),
          vertical: context.heightPct(3.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: iconContainerSize * 0.5,
              ),
            ),
            SizedBox(height: context.heightPct(2.2)),
            Text(
              'Logout',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(22),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.heightPct(1.2)),
            Text(
              'Are you sure you want to logout? You will need to sign in again to access your matches and profile.',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                fontSize: context.responsiveFont(13),
                height: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(3)),
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  await FirebaseAuth.instance.signOut();
                  await UserPreferences.clearUser();
                  await FriendsSqflite.clearAll();
                  await GroupsSqflite.clearAll();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(6),
                    ),
                  ),
                  elevation: 0,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Logout',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.background,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(1.8)),
            // Cancel Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(15),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
