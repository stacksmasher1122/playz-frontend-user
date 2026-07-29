import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CoverImageWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String? imagePath;

  const CoverImageWidget({
    super.key,
    required this.onTap,
    this.imagePath,
  });

  @override
  State<CoverImageWidget> createState() => _CoverImageWidgetState();
}

class _CoverImageWidgetState extends State<CoverImageWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Basic Details",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1.2)),
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            height: context.heightPct(16).clamp(110.0, 150.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: (widget.imagePath != null && widget.imagePath!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    child: Image.file(
                      File(widget.imagePath!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.muted,
                        size: context.responsiveFont(28),
                      ),
                      SizedBox(height: context.heightPct(0.8)),
                      Text(
                        "Add Cover Image",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(13),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
