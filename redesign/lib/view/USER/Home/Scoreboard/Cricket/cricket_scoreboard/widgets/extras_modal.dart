import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';

class ExtrasModal extends StatefulWidget {
  final Function(ExtraType, int) onSelect;
  const ExtrasModal({super.key, required this.onSelect});

  @override
  State<ExtrasModal> createState() => _ExtrasModalState();
}

class _ExtrasModalState extends State<ExtrasModal> {
  ExtraType? selectedType;
  int additionalRuns = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Extra Type',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExtraType.values.map((t) {
              final sel = selectedType == t;
              return GestureDetector(
                onTap: () => setState(() => selectedType = t),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.warning.withValues(alpha: 0.2) : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: sel ? Border.all(color: AppColors.warning) : null,
                  ),
                  child: Text(
                    t.name.toUpperCase(),
                    style: TextStyle(
                      color: sel ? AppColors.warning : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Additional Runs',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [0, 1, 2, 3, 4].map((r) {
              final sel = additionalRuns == r;
              return GestureDetector(
                onTap: () => setState(() => additionalRuns = r),
                child: Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.accent.withValues(alpha: 0.2) : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: sel ? Border.all(color: AppColors.accent) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$r',
                    style: TextStyle(
                      color: sel ? AppColors.accent : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedType != null
                  ? () => widget.onSelect(selectedType!, additionalRuns)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
