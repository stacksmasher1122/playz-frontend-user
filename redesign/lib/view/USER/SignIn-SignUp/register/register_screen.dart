import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/SignIn-SignUp/login/login_screen.dart';
import 'package:redesign/view/USER/SignIn-SignUp/favorite_sports/favorite_sports_screen.dart';
import 'package:redesign/controller/User_Controller/registerController.dart';
import 'package:redesign/model/User_Models/registerModel.dart';

import 'widgets/register_background.dart';
import 'widgets/register_header.dart';
import 'widgets/register_form.dart';
import 'widgets/register_signin_prompt.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static Color cardColor = Color(0xFF181818);

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
        SnackBar(content: Text(_controller.errorMessage ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          RegisterBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                children: [
                  SizedBox(height: 280),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(24)),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(28)),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        children: [
                          RegisterHeader(),
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
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
