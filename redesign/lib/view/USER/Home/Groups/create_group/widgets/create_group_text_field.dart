import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF161616);
const kMuted = Colors.white54;

class CreateGroupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final int? maxLength;

  CreateGroupTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 14),
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kMuted, fontSize: 14),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
