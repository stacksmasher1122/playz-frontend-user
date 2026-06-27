import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final bool isLoading;
  final Function(bool?) onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.isLoading,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    const kSpotifyGreen = Color(0xFF1DB954);
    const kCard = Color(0xFF1A1A1A);

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 26),

          /// 📧 EMAIL
          _InputField(
            controller: emailController,
            icon: Icons.email_outlined,
            hint: 'user@playz.com',
            fillColor: kCard,
            validator: (value) => value == null || value.isEmpty
                ? 'Email is required'
                : null,
          ),

          const SizedBox(height: 14),

          /// 🔒 PASSWORD
          _InputField(
            controller: passwordController,
            icon: Icons.lock_outline,
            hint: '••••••••',
            obscure: true,
            fillColor: kCard,
            validator: (value) =>
                value == null || value.length < 6
                ? 'Minimum 6 characters'
                : null,
          ),

          const SizedBox(height: 14),

          /// ☑ REMEMBER + FORGOT
          Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: rememberMe,
                  activeColor: kSpotifyGreen,
                  checkColor: Colors.black,
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.25),
                  ),
                  onChanged: onRememberMeChanged,
                ),
              ),
              const Text(
                'Remember me',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kSpotifyGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// 🟢 PRIMARY CTA
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: kSpotifyGreen,
                disabledBackgroundColor: kSpotifyGreen
                    .withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('loader'),
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.black,
                        ),
                      )
                    : const Row(
                        key: ValueKey('text'),
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscure;
  final Color fillColor;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.fillColor,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
