import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color kSurface = Color(0xFF0E0E0E);
  static const Color kCard = Color(0xFF1A1A1A);
  static const Color kMuted = Color(0xFFA7A7A7);
  static const Color kSpotifyGreen = AppColors.accent;

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
          backgroundColor: kSurface,
          title: const Text(
            "Reset Password",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: resetController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter your email",
              hintStyle: const TextStyle(color: kMuted),
              filled: true,
              fillColor: kCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kSpotifyGreen),
              child: const Text(
                "Send Reset Link",
                style: TextStyle(color: Colors.black),
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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

    bool success = await _controller.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final docId = _emailController.text.trim();
      final exists = await _checkAndFetchUserDoc(docId);
      if (!mounted) return;
      if (exists) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserAppNavShell()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_controller.errorMessage ?? "Login failed")));
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    bool success = await _controller.loginWithGoogle();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final user = FirebaseAuth.instance.currentUser;
      final docId = user?.email ?? '';
      if (docId.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()));
        return;
      }
      final exists = await _checkAndFetchUserDoc(docId);
      if (!mounted) return;
      if (exists) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserAppNavShell()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_controller.errorMessage ?? "Google Sign-In failed")));
    }
  }

  Future<bool> _checkAndFetchUserDoc(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('User').doc(docId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        await UserPreferences.saveDocId(docId);
        await UserPreferences.saveUserProfile(
          data['fullName'] ?? '',
          data['primaryPhone'] ?? '',
          data['primaryEmail'] ?? '',
          data['dob'] ?? '',
          data['bio'] ?? '',
          data['profileImageUrl'] ?? '',
        );
        final sports = data['favoriteSports'];
        if (sports != null && sports is List) {
          await UserPreferences.saveFavoriteSports(sports.map((e) => e.toString()).toList());
        }
        await UserPreferences.setPublicProfile(data['isPublicProfile'] ?? true);
        await UserPreferences.setTrainer(data['isTrainer'] ?? false);
        await UserPreferences.setProfileComplete(true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error fetching user doc: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const LoginBackground(),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                const SizedBox(height: 300),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
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
                          onRememberMeChanged: (v) => setState(() => _rememberMe = v ?? false),
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
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
