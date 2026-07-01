import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Friends_SQF/friendsSqflite.dart';
import 'package:redesign/view/USER/SignIn-SignUp/login/login_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LogoutDialog extends StatelessWidget {
  LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Dialog(
      backgroundColor: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(24))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(28), vertical: ResponsiveHelper.h(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: ResponsiveHelper.w(56),
              height: ResponsiveHelper.h(56),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Logout',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(22),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Are you sure you want to logout? You will need to sign in again to access your matches and profile.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: ResponsiveHelper.sp(13),
                height: ResponsiveHelper.h(1.5),
              ),
            ),
            SizedBox(height: 28),
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(50),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  await FirebaseAuth.instance.signOut();
                  await UserPreferences.clearUser();
                  await FriendsSqflite.clearAll();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(25)),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),
            // Cancel Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(15),
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
