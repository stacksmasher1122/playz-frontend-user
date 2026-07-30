import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/model/user_profile_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';

import 'widgets/profile_photo_picker.dart';
import 'widgets/profile_setup_field.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'package:redesign/services/global_groups_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  final List<String> selectedSports;
  const ProfileSetupScreen({super.key, required this.selectedSports});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  final _controller = Get.put(UserProfileController());

  bool _isEmailBound = false;
  bool _isPhoneBound = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      await _controller.fetchUserProfile(docId);
      final user = _controller.rxUser.value;
      if (user != null && mounted) {
        _nameController.text = user.fullName;
        _emailController.text = user.primaryEmail;
        _phoneController.text = user.primaryPhone;
      }
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && mounted) {
      setState(() {
        if (_nameController.text.trim().isEmpty &&
            currentUser.displayName != null &&
            currentUser.displayName!.isNotEmpty) {
          _nameController.text = currentUser.displayName!;
        }
        if (currentUser.email != null && currentUser.email!.isNotEmpty) {
          _emailController.text = currentUser.email!;
          _isEmailBound = true;
        }
        if (currentUser.phoneNumber != null &&
            currentUser.phoneNumber!.isNotEmpty) {
          _phoneController.text = currentUser.phoneNumber!;
          _isPhoneBound = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Pick image error: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to pick image")));
      }
    }
  }

  Future<void> _completeSetup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name is required")));
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    final email = _emailController.text.trim().isNotEmpty
        ? _emailController.text.trim()
        : (currentUser?.email ?? '');
    final phone = _phoneController.text.trim().isNotEmpty
        ? _phoneController.text.trim()
        : (currentUser?.phoneNumber ?? '');

    final String docId = email.isNotEmpty
        ? email
        : (phone.isNotEmpty ? phone : (currentUser?.uid ?? ''));

    if (docId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An email or phone number is required.")),
      );
      return;
    }

    final newUser = UserProfileModel(
      docId: docId,
      fullName: _nameController.text.trim(),
      primaryEmail: email,
      secondaryEmail: email,
      primaryPhone: phone,
      secondaryPhone: phone,
      bio: _bioController.text.trim(),
      dob: _dobController.text.trim(),
      favoriteSports: widget.selectedSports,
      isPublicProfile: _controller.rxUser.value?.isPublicProfile ?? true,
    );

    final success = await _controller.updateUserProfile(
      updatedUser: newUser,
      imageFile: _imageFile,
    );

    if (success) {
      await UserPreferences.saveFavoriteSports(widget.selectedSports);
      await UserPreferences.setTrainer(false);
      await UserPreferences.setProfileComplete(true);

      await GlobalGroupsService.checkAndJoinAllUserGroups(targetDocId: docId);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'STEP 2 OF 2',
              style: AppTypography.labelCaps10.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(11),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(0.8)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: context.widthPct(1)),
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.heightPct(2)),
            Text(
              'Complete your profile',
              style: AppTypography.displaySm.copyWith(
                fontSize: context.responsiveFont(26),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: context.heightPct(1)),
            Text(
              'Tell us a bit about yourself to get started.',
              style: AppTypography.bodyMd.copyWith(
                fontSize: context.responsiveFont(14),
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: context.heightPct(3)),
            ProfilePhotoPicker(imageFile: _imageFile, onPickImage: _pickImage),
            SizedBox(height: context.heightPct(3)),
            ProfileSetupField(
              label: 'FULL NAME',
              hint: 'Alex Morgan',
              icon: Icons.person_rounded,
              controller: _nameController,
            ),
            SizedBox(height: context.heightPct(2)),
            ProfileSetupField(
              label: 'PHONE NUMBER',
              hint: '+1 (555) 000-1234',
              icon: Icons.phone_rounded,
              controller: _phoneController,
              readOnly: _isPhoneBound,
            ),
            SizedBox(height: context.heightPct(2)),
            ProfileSetupField(
              label: 'EMAIL ADDRESS',
              hint: 'alex.morgan@example.com',
              icon: Icons.email_rounded,
              controller: _emailController,
              readOnly: _isEmailBound,
            ),
            SizedBox(height: context.heightPct(2)),
            ProfileSetupField(
              label: 'DATE OF BIRTH',
              hint: 'mm/dd/yyyy',
              icon: Icons.calendar_today_rounded,
              controller: _dobController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 365 * 18),
                  ),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.accent,
                          onPrimary: AppColors.background,
                          surface: AppColors.surface,
                          onSurface: AppColors.textPrimary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  final month = date.month.toString().padLeft(2, '0');
                  final day = date.day.toString().padLeft(2, '0');
                  final year = date.year.toString();
                  _dobController.text = '$month/$day/$year';
                }
              },
            ),
            SizedBox(height: context.heightPct(2)),
            ProfileSetupField(
              label: 'BIO',
              hint:
                  "Tell us about your favorite sports,\nteams, or what you're looking for...",
              icon: Icons.description_rounded,
              controller: _bioController,
              maxLines: 3,
            ),
            SizedBox(height: context.heightPct(2.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Public Profile',
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.5)),
                      Text(
                        'Allow anyone to see your stats',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Switch(
                    value: _controller.rxUser.value?.isPublicProfile ?? true,
                    onChanged: (value) {
                      final user = _controller.rxUser.value;
                      if (user != null) {
                        _controller.setUser(
                          user.copyWith(isPublicProfile: value),
                        );
                      } else {
                        _controller.setUser(
                          UserProfileModel(
                            docId: 'temp',
                            isPublicProfile: value,
                          ),
                        );
                      }
                    },
                    activeThumbColor: AppColors.background,
                    activeTrackColor: AppColors.accent,
                    inactiveThumbColor: AppColors.muted,
                    inactiveTrackColor: AppColors.card,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(4)),
            SizedBox(
              width: double.infinity,
              height: context.heightPct(6).clamp(48.0, 56.0),
              child: ElevatedButton(
                onPressed: () =>
                    _controller.isLoading.value ? null : _completeSetup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(7),
                    ),
                  ),
                  elevation: 0,
                ),
                child: Obx(
                  () => _controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: AppColors.background,
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Complete Setup',
                            style: AppTypography.labelCaps10.copyWith(
                              fontSize: context.responsiveFont(16),
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(2.5)),
            Center(
              child: Text(
                'By continuing, you agree to our Terms of Service',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(11.5),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(4)),
          ],
        ),
      ),
    );
  }
}
