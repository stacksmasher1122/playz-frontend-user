import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AddTeamBottomSheet extends StatefulWidget {
  final Function(String name, String? imageUrl) onAdd;

  const AddTeamBottomSheet({super.key, required this.onAdd});

  @override
  State<AddTeamBottomSheet> createState() => _AddTeamBottomSheetState();
}

class _AddTeamBottomSheetState extends State<AddTeamBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedImageUrl;

  void _pickImage() {
    // Mock image picking
    setState(() {
      _selectedImageUrl = "https://via.placeholder.com/150";
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adding viewInsets padding to move sheet above keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveHelper.w(16),
        right: ResponsiveHelper.w(16),
        top: ResponsiveHelper.h(24),
        bottom: ResponsiveHelper.h(24) + bottomInset,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add New Team",
            style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
          ),
          SizedBox(height: ResponsiveHelper.h(24)),
          
          // Image Picker
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: ResponsiveHelper.w(80),
                height: ResponsiveHelper.w(80),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                  image: _selectedImageUrl != null
                      ? DecorationImage(image: NetworkImage(_selectedImageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: _selectedImageUrl == null
                    ? Icon(Icons.add_a_photo, color: AppColors.muted, size: ResponsiveHelper.w(28))
                    : null,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Center(
            child: Text(
              "Add Team Logo",
              style: AppTypography.bodySm.copyWith(color: AppColors.muted),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24)),
          
          // Team Name Input
          Text(
            "Team Name",
            style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
            decoration: InputDecoration(
              hintText: "Enter team name",
              hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(14),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(32)),
          
          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                ),
              ),
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  widget.onAdd(name, _selectedImageUrl);
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                    "Error", 
                    "Please enter a team name", 
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.card,
                    colorText: AppColors.onPrimary,
                  );
                }
              },
              child: Text(
                "Add Team",
                style: AppTypography.headlineSm.copyWith(color: AppColors.background),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
