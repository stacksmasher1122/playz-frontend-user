import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);
const kSurface = Color(0xFF0E0E0E);

class TrainerInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initial;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  TrainerInputField({
    super.key,
    required this.label,
    this.hint,
    this.initial,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initial : null,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.sp(14.5),
        fontWeight: FontWeight.w500,
      ),
      cursorColor: kGreen,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: kMuted),
        hintStyle: TextStyle(color: kMuted.withValues(alpha: 0.6)),
        filled: true,
        fillColor: kCard,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          borderSide: BorderSide(color: kGreen, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}

class TrainerVerifiedField extends StatelessWidget {
  final String label;
  final String value;

  TrainerVerifiedField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return TextFormField(
      initialValue: value,
      enabled: false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kMuted),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: kGreen, size: 18),
            SizedBox(width: 6),
            Text('Verified', style: TextStyle(color: kGreen)),
            SizedBox(width: 12),
          ],
        ),
        filled: true,
        fillColor: kCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class TrainerDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  TrainerDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final safeValue = items.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      initialValue: safeValue,
      onChanged: onChanged,
      isExpanded: true,
      icon: Icon(Icons.expand_more_rounded, color: kMuted),
      dropdownColor: kSurface,
      menuMaxHeight: 280,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      style: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.sp(14),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: kCard,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          borderSide: BorderSide(color: kGreen, width: 1.2),
        ),
      ),
      items: items.map((e) {
        final isSelected = e == safeValue;
        return DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: TextStyle(
              color: isSelected ? kGreen : Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TrainerBioField extends StatefulWidget {
  TrainerBioField({super.key});

  @override
  State<TrainerBioField> createState() => _TrainerBioFieldState();
}

class _TrainerBioFieldState extends State<TrainerBioField> {
  final controller = TextEditingController();
  static const maxLength = 200;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 4,
          maxLength: maxLength,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Short Bio',
            hintText: 'Briefly describe your coaching style...',
            hintStyle: TextStyle(color: kMuted),
            labelStyle: TextStyle(color: kMuted),
            filled: true,
            fillColor: kCard,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              borderSide: BorderSide(color: kGreen),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: 4),
        Text(
          '${controller.text.length}/$maxLength',
          style: TextStyle(color: kMuted, fontSize: 11),
        ),
      ],
    );
  }
}
