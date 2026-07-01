import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchFormSection extends StatelessWidget {
  MatchFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        _buildTextField(
          label: "MATCH NAME",
          hint: "e.g. Club Championship Final",
        ),
        SizedBox(height: 20),
        _buildTextField(
          label: "TOURNAMENT (OPTIONAL)",
          hint: "Select Tournament",
          isDropdown: true,
        ),
        SizedBox(height: 20),
        _buildTextField(
          label: "DATE & TIME",
          hint: "mm/dd/yyyy, --:-- --",
          trailingIcon: Icons.calendar_today_outlined,
        ),
        SizedBox(height: 20),
        _buildTextField(
          label: "VENUE / COURT",
          hint: "Court 04",
          trailingIcon: Icons.stadium_outlined,
        ),
        SizedBox(height: 20),
        _buildTextField(
          label: "UMPIRE ASSIGNMENT",
          hint: "Search Officials",
          trailingIcon: Icons.person_search_outlined,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    IconData? trailingIcon,
    bool isDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(10),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(4)),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: isDropdown,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  ),
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: AppColors.muted, size: 20)
              else if (isDropdown)
                Icon(Icons.keyboard_arrow_down, color: AppColors.muted, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
