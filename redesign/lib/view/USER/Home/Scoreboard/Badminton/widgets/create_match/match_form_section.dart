import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class MatchFormSection extends StatelessWidget {
  const MatchFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          label: "MATCH NAME",
          hint: "e.g. Club Championship Final",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "TOURNAMENT (OPTIONAL)",
          hint: "Select Tournament",
          isDropdown: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "DATE & TIME",
          hint: "mm/dd/yyyy, --:-- --",
          trailingIcon: Icons.calendar_today_outlined,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "VENUE / COURT",
          hint: "Court 04",
          trailingIcon: Icons.stadium_outlined,
        ),
        const SizedBox(height: 20),
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: isDropdown,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: AppColors.muted, size: 20)
              else if (isDropdown)
                const Icon(Icons.keyboard_arrow_down, color: AppColors.muted, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
