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
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(context.widthPct(2.5)),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.tier.icon,
              color: AppColors.accent,
              size: context.responsiveFont(20),
            ),
          ),
          SizedBox(width: context.widthPct(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.tier.isDefault && widget.tier.title != null)
                  Text(
                    widget.tier.title!,
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(14.5),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  TextFormField(
                    controller: _titleController,
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(14.5),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Custom Prize Title",
                      hintStyle: AppTypography.bodyLg.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(14),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onTitleChanged,
                  ),
                SizedBox(height: context.heightPct(1)),
                CommonTextField(
                  controller: widget.tier.amountController,
                  hintText: "0.00",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.muted,
                    size: context.responsiveFont(20),
                  ),
                ),
              ],
            ),
          ),
          if (!widget.tier.isDefault && widget.onDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: context.responsiveFont(20),
              ),
              onPressed: widget.onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
