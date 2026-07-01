import 'package:flutter/material.dart';
import '../edit_profile_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EditProfileField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  EditProfileField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: ResponsiveHelper.sp(10),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white24),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: Colors.white38, size: 20)
                : Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(icon, color: Colors.white38, size: 20),
                  ),
            filled: true,
            fillColor: kEditProfileCard,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              borderSide: BorderSide(
                color: kEditProfileGreen.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
