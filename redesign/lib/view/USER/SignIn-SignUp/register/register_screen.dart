import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/SignIn-SignUp/login/login_screen.dart';
import 'package:redesign/view/USER/SignIn-SignUp/favorite_sports/favorite_sports_screen.dart';
import 'package:redesign/controller/User_Controller/registerController.dart';
import 'package:redesign/model/User_Models/registerModel.dart';

import 'widgets/register_background.dart';
import 'widgets/register_header.dart';
import 'widgets/register_form.dart';
import 'widgets/register_signin_prompt.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color cardColor = Color(0xFF0E0E0E);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final RegisterController _controller = RegisterController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    RegisterModel user = RegisterModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    bool success = await _controller.registerWithEmail(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => FavoriteSportsScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? "Registration failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const RegisterBackground(),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  context.heightPct(4),
            ),
            child: Column(
              children: [
                SizedBox(height: 300),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(20),
                    vertical: ResponsiveHelper.h(24),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(22)),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(22),
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const RegisterHeader(),
                        RegisterForm(
                          formKey: _formKey,
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isLoading: _isLoading,
                          onRegister: _handleRegister,
                        ),
                      ],
                    ),
                  ),
                ),
                RegisterSigninPrompt(
                  onSigninTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
                SizedBox(height: context.heightPct(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
