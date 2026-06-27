import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class BookingDropdowns extends StatelessWidget {
  final String? selectedType;
  final String? selectedSize;
  final List<String> typeOptions;
  final List<String> sizeOptions;
  final ValueChanged<String> onTypeSelected;
  final ValueChanged<String> onSizeSelected;

  const BookingDropdowns({
    super.key,
    required this.selectedType,
    required this.selectedSize,
    required this.typeOptions,
    required this.sizeOptions,
    required this.onTypeSelected,
    required this.onSizeSelected,
  });

  static const _kGreen = AppColors.accent;
  static const _kBottomSheetColor = AppColors.surface;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;

          return Row(
            children: [
              Expanded(
                child: _DropdownCard(
                  label: 'Type',
                  value: selectedType,
                  onTap: () => _openBottomSheet(
                    context,
                    title: 'Select Type',
                    options: typeOptions,
                    selected: selectedType,
                    onSelected: onTypeSelected,
                  ),
                ),
              ),
              SizedBox(width: isWide ? 16 : 12),
              Expanded(
                child: _DropdownCard(
                  label: 'Size',
                  value: selectedSize,
                  onTap: () => _openBottomSheet(
                    context,
                    title: 'Select Size',
                    options: sizeOptions,
                    selected: selectedSize,
                    onSelected: onSizeSelected,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openBottomSheet(
    BuildContext context, {
    required String title,
    required List<String> options,
    String? selected,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _kBottomSheetColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                /// OPTIONS
                ...options.map((option) {
                  final isSelected = option == selected;

                  return ListTile(
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? _kGreen : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: _kGreen)
                        : null,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DropdownCard extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _DropdownCard({
    required this.label,
    this.value,
    required this.onTap,
  });

  static const _kMuted = Color(0xFFA7A7A7);
  static const _kCardColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kCardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade800, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _kMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? 'Select',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: value == null ? _kMuted : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _kMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
