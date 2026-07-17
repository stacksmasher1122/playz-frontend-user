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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Basic Details",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            height: ResponsiveHelper.h(130),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              border: Border.all(color: AppColors.card, width: 1), // Optional: wrap in dashed border if required
            ),
            child: (widget.imagePath != null && widget.imagePath!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
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
                        size: ResponsiveHelper.w(32),
                      ),
                      SizedBox(height: ResponsiveHelper.h(8)),
                      Text(
                        "Add Cover Image",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
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
