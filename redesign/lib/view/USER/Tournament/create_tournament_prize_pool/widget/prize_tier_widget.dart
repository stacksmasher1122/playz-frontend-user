import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../model/User_Models/Tournament_Model/prize_tier_model.dart';
import 'common_textfield.dart';

class PrizeTierWidget extends StatefulWidget {
  final PrizeTierModel tier;
  final VoidCallback? onDelete;
  final Function(String)? onTitleChanged;

  const PrizeTierWidget({
    super.key,
    required this.tier,
    this.onDelete,
    this.onTitleChanged,
  });

  @override
  State<PrizeTierWidget> createState() => _PrizeTierWidgetState();
}

class _PrizeTierWidgetState extends State<PrizeTierWidget> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tier.title);
  }

  @override
  void didUpdateWidget(PrizeTierWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tier.title != widget.tier.title && widget.tier.title != null && _titleController.text != widget.tier.title) {
      _titleController.text = widget.tier.title!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.tier.icon,
              color: AppColors.accent,
              size: ResponsiveHelper.w(20),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.tier.isDefault && widget.tier.title != null)
                  Text(
                    widget.tier.title!,
                    style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
                  )
                else
                  TextFormField(
                    controller: _titleController,
                    style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
                    decoration: InputDecoration(
                      hintText: "Custom Prize Title",
                      hintStyle: AppTypography.bodyLg.copyWith(color: AppColors.muted),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onTitleChanged,
                  ),
                SizedBox(height: ResponsiveHelper.h(8)),
                CommonTextField(
                  controller: widget.tier.amountController,
                  hintText: "0.00",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icon(Icons.attach_money, color: AppColors.muted),
                ),
              ],
            ),
          ),
          if (!widget.tier.isDefault && widget.onDelete != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: widget.onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
