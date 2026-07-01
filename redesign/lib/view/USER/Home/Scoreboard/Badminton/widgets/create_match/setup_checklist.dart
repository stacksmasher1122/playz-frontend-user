import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupChecklist extends StatelessWidget {
  SetupChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("SETUP CHECKLIST"),
          SizedBox(height: 20),
          _buildChecklistItem("Match name defined", isDone: true),
          SizedBox(height: 16),
          _buildChecklistItem("Standard category active", isDone: true),
          SizedBox(height: 16),
          _buildChecklistItem("Player management (Next step)", isDone: false),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.sp(12),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildChecklistItem(String text, {required bool isDone}) {
    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: isDone ? AppColors.accent : AppColors.muted,
          size: 20,
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isDone ? Colors.white : AppColors.muted,
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
      ],
    );
  }
}
