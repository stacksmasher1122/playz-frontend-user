import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RaiseTicketBottomSheet extends StatefulWidget {
  const RaiseTicketBottomSheet({super.key});

  @override
  State<RaiseTicketBottomSheet> createState() => _RaiseTicketBottomSheetState();
}

class _RaiseTicketBottomSheetState extends State<RaiseTicketBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Bookings';
  String _subject = '';
  String _description = '';

  final List<String> _categories = const ['Bookings', 'Scoreboards', 'Payments', 'Account & App'];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(6)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.minDimensionPct(6)),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: context.widthPct(10).clamp(36.0, 44.0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.muted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(2.5)),
                Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined, color: AppColors.coinsGold, size: 24),
                    SizedBox(width: context.widthPct(2.5)),
                    Expanded(
                      child: Text(
                        'Raise Support Ticket',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(18),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(0.8)),
                Text(
                  'Our support team will get back to you within 2-4 hours.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
                SizedBox(height: context.heightPct(2.5)),

                Text(
                  'Category',
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightPct(0.8)),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  dropdownColor: AppColors.surfaceElevated,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textPrimary.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: const BorderSide(color: AppColors.borderDark),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: const BorderSide(color: AppColors.borderDark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                    ),
                  ),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _category = val);
                    }
                  },
                ),
                SizedBox(height: context.heightPct(2)),

                Text(
                  'Subject',
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightPct(0.8)),
                TextFormField(
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Brief summary of the issue...',
                    hintStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.muted.withValues(alpha: 0.5),
                      fontSize: context.responsiveFont(14),
                    ),
                    filled: true,
                    fillColor: AppColors.textPrimary.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: const BorderSide(color: AppColors.borderDark),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: const BorderSide(color: AppColors.borderDark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a subject' : null,
                  onSaved: (v) => _subject = v ?? '',
                ),
                SizedBox(height: context.heightPct(2)),

                Text(
                  'Description',
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightPct(0.8)),
                TextFormField(
                  maxLines: 4,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Describe your query or issue in detail...',
                    hintStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.muted.withValues(alpha: 0.5),
                      fontSize: context.responsiveFont(14),
                    ),
                    filled: true,
                    fillColor: AppColors.textPrimary.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: const BorderSide(color: AppColors.borderDark),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: const BorderSide(color: AppColors.borderDark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      borderSide: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a description' : null,
                  onSaved: (v) => _description = v ?? '',
                ),
                SizedBox(height: context.heightPct(3)),

                SizedBox(
                  width: double.infinity,
                  height: context.heightPct(6).clamp(48.0, 56.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        debugPrint('Ticket Submitted -> Category: $_category, Subject: $_subject, Desc: $_description');
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ticket created! Support reference #TK-84920'),
                            backgroundColor: AppColors.accent,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Submit Ticket',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
