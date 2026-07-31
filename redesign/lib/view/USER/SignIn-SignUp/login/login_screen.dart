import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/registerController.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/SignIn-SignUp/register/register_screen.dart';
import 'package:redesign/view/USER/SignIn-SignUp/favorite_sports/favorite_sports_screen.dart';

import 'widgets/login_background.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';
import 'widgets/social_login_row.dart';
import 'widgets/login_signup_prompt.dart';
import 'widgets/phone_login_sheet.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegisterController _controller = RegisterController();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showPhoneLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const PhoneLoginSheet();
      },
    );
  }

  Future<void> _forgotPassword() async {
    TextEditingController resetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          ),
          title: Text(
            "Reset Password",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: resetController,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(14),
            ),
            decoration: InputDecoration(
              hintText: "Enter your email",
              hintStyle: AppTypography.bodyMd.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                ),
              ),
              child: Text(
                "Send Reset Link",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(13),
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: resetController.text.trim(),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset email sent")),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      bool success = await _controller.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        final docId = _emailController.text.trim();
        final exists = await _checkAndFetchUserDoc(docId);
        if (!mounted) return;
        if (exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserAppNavShell()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.errorMessage ?? "Login failed")),
        );
      }
    } catch (e) {
      debugPrint('🔴 [_handleLogin] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      bool success = await _controller.loginWithGoogle();

      if (!mounted) return;

      if (success) {
        final user = FirebaseAuth.instance.currentUser;
        final docId = user?.email ?? '';
        if (docId.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
          );
          return;
        }
        final exists = await _checkAndFetchUserDoc(docId);
        if (!mounted) return;
        if (exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserAppNavShell()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_controller.errorMessage ?? "Google Sign-In failed"),
          ),
        );
      }
    } catch (e) {
      debugPrint('🔴 [_handleGoogleLogin] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google login error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _checkAndFetchUserDoc(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .get()
          .timeout(const Duration(seconds: 5));
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final bool isComplete = (data['isProfileComplete'] ?? false) == true;
        final sports = data['favoriteSports'];
        final bool hasSports =
            sports != null && sports is List && sports.length >= 4;

        await UserPreferences.saveDocId(docId);
        await UserPreferences.saveUserProfile(
          data['fullName'] ?? '',
          data['primaryPhone'] ?? '',
          data['primaryEmail'] ?? '',
          data['dob'] ?? '',
          data['bio'] ?? '',
          data['profileImageUrl'] ?? '',
        );
        if (sports != null && sports is List) {
          await UserPreferences.saveFavoriteSports(
            sports.map((e) => e.toString()).toList(),
          );
        }
        await UserPreferences.setPublicProfile(data['isPublicProfile'] ?? true);
        await UserPreferences.setTrainer(data['isTrainer'] ?? false);

        if (isComplete && hasSports) {
          await UserPreferences.setProfileComplete(true);
          return true;
        }
      }
      await UserPreferences.setProfileComplete(false);
      return false;
    } catch (e) {
      debugPrint('Error fetching user doc: $e');
      await UserPreferences.setProfileComplete(false);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.greenBlackBg),
        child: Stack(
          children: [
            const LoginBackground(),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  SizedBox(height: context.heightPct(30)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(5),
                      vertical: context.heightPct(2.5),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(context.widthPct(5.5)),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          context.minDimensionPct(5.5),
                        ),
                        border: Border.all(
                          color: AppColors.textPrimary.withValues(alpha: 0.06),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.background.withValues(alpha: 0.6),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const LoginHeader(),
                          LoginForm(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            rememberMe: _rememberMe,
                            isLoading: _isLoading,
                            onRememberMeChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                            onForgotPassword: _forgotPassword,
                            onLogin: _handleLogin,
                          ),
                          SocialLoginRow(
                            isLoading: _isLoading,
                            onGoogleLogin: _handleGoogleLogin,
                            onPhoneLogin: _showPhoneLoginSheet,
                          ),
                        ],
                      ),
                    ),
                  ),
                  LoginSignupPrompt(
                    onSignupTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
