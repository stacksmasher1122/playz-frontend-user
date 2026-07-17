import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchRulesWidget extends StatefulWidget {
  final List<String> halfLengthOptions;
  final String selectedHalfLength;
  final Function(String?) onHalfLengthChanged;
  
  final bool extraTimeEnabled;
  final Function(bool) onExtraTimeChanged;
  
  final bool penaltiesEnabled;
  final Function(bool) onPenaltiesChanged;

  const MatchRulesWidget({
    super.key,
    required this.halfLengthOptions,
    required this.selectedHalfLength,
    required this.onHalfLengthChanged,
    required this.extraTimeEnabled,
    required this.onExtraTimeChanged,
    required this.penaltiesEnabled,
    required this.onPenaltiesChanged,
  });

  @override
  State<MatchRulesWidget> createState() => _MatchRulesWidgetState();
}

class _MatchRulesWidgetState extends State<MatchRulesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Half Length
          Text(
            "Half Length (Minutes)",
            style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
            DropdownButtonFormField<String>(
            initialValue: widget.selectedHalfLength,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
            dropdownColor: AppColors.card,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: AppColors.card),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: AppColors.card),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(12),
              ),
            ),
            items: widget.halfLengthOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: widget.onHalfLengthChanged,
          ),
          
          SizedBox(height: ResponsiveHelper.h(16)),
          Divider(color: AppColors.outlineVariant, thickness: 1),
          SizedBox(height: ResponsiveHelper.h(16)),
          
          // Extra Time Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Extra Time on Draw",
                      style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      "Apply to knockout stages only",
                      style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.extraTimeEnabled,
                onChanged: widget.onExtraTimeChanged,
                activeThumbColor: AppColors.background,
                activeTrackColor: AppColors.accent,
                inactiveThumbColor: AppColors.muted,
                inactiveTrackColor: AppColors.outlineVariant,
              ),
            ],
          ),
          
          SizedBox(height: ResponsiveHelper.h(16)),
          
          // Penalties Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penalties",
                      style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      "If tied after extra time",
                      style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.penaltiesEnabled,
                onChanged: widget.onPenaltiesChanged,
                activeThumbColor: AppColors.background,
                activeTrackColor: AppColors.accent,
                inactiveThumbColor: AppColors.muted,
                inactiveTrackColor: AppColors.outlineVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
