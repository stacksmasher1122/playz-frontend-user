import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingDropdowns extends StatelessWidget {
  final String? selectedType;
  final String? selectedSize;
  final String typeLabel;
  final String sizeLabel;
  final List<String> typeOptions;
  final List<String> sizeOptions;
  final bool isLoadingTypes;
  final ValueChanged<String> onTypeSelected;
  final ValueChanged<String> onSizeSelected;

  const BookingDropdowns({
    super.key,
    required this.selectedType,
    required this.selectedSize,
    this.typeLabel = 'Ground',
    this.sizeLabel = 'Size',
    required this.typeOptions,
    required this.sizeOptions,
    this.isLoadingTypes = false,
    required this.onTypeSelected,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;

          return Row(
            children: [
              Expanded(
                child: _DropdownCard(
                  label: typeLabel,
                  value: selectedType,
                  isLoading: isLoadingTypes,
                  onTap: () => _openBottomSheet(
                    context,
                    title: 'Select $typeLabel',
                    options: typeOptions,
                    selected: selectedType,
                    onSelected: onTypeSelected,
                  ),
                ),
              ),
              SizedBox(width: isWide ? context.widthPct(4) : context.widthPct(3)),
              Expanded(
                child: _DropdownCard(
                  label: sizeLabel,
                  value: selectedSize,
                  onTap: () => _openBottomSheet(
                    context,
                    title: 'Select $sizeLabel',
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
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.widthPct(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightPct(2)),
                if (options.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
                    child: Center(
                      child: Text(
                        'No options available',
                        style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                      ),
                    ),
                  )
                else
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
                        style: AppTypography.bodySm.copyWith(
                          color: isSelected ? AppColors.accent : AppColors.textPrimary,
                          fontSize: context.responsiveFont(14),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.accent)
                          : null,
                    );
                  }),
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
  final bool isLoading;
  final VoidCallback onTap;

  const _DropdownCard({
    required this.label,
    this.value,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(1.5),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(color: AppColors.borderDark, width: 1),
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
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  isLoading
                      ? const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accent,
                          ),
                        )
                      : Text(
                          value ?? 'Select',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: value == null ? AppColors.muted : AppColors.textPrimary,
                            fontSize: context.responsiveFont(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
