import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onRegister;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    const spotifyGreen = Color(0xFF1DB954);
    const inputColor = Color(0xFF222222);

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 24),
          _InputField(
            controller: nameController,
            icon: Icons.person_outline,
            hint: 'Full Name',
            fillColor: inputColor,
            validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: emailController,
            icon: Icons.email_outlined,
            hint: 'Email Address',
            fillColor: inputColor,
            validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: passwordController,
            icon: Icons.lock_outline,
            hint: 'Password',
            obscure: true,
            fillColor: inputColor,
            validator: (v) => v != null && v.length < 6
                ? 'Min 6 characters'
                : null,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: confirmPasswordController,
            icon: Icons.lock_outline,
            hint: 'Confirm Password',
            obscure: true,
            fillColor: inputColor,
            validator: (v) => v != passwordController.text
                ? 'Passwords do not match'
                : null,
          ),
          const SizedBox(height: 24),

          /// CREATE ACCOUNT BUTTON
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: spotifyGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    )
                  : const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
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
