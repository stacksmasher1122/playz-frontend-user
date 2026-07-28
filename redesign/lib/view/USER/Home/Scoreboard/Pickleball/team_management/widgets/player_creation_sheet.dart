import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';

class PlayerCreationSheet extends StatefulWidget {
  final int teamIndex;
  final PickleballTeamManagementController controller;

  const PlayerCreationSheet({
    super.key,
    required this.teamIndex,
    required this.controller,
  });

  @override
  State<PlayerCreationSheet> createState() => _PlayerCreationSheetState();
}

class _PlayerCreationSheetState extends State<PlayerCreationSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _clubController = TextEditingController();

  void _createPlayer() {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Invalid Input",
        "Player name cannot be empty.",
        backgroundColor: AppColors.error,
        colorText: AppColors.onPrimary,
      );
      return;
    }

    final newPlayer = PickleballPlayerModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      club: _clubController.text.trim().isNotEmpty ? _clubController.text.trim() : "Independent",
      rating: _ratingController.text.trim().isNotEmpty ? _ratingController.text.trim() : "Unrated",
      country: "US",
      image: "", // Mocking image upload for now
      gender: "U",
    );

    widget.controller.addPlayer(widget.teamIndex, newPlayer);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratingController.dispose();
    _clubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: ResponsiveHelper.w(40),
                  height: ResponsiveHelper.h(4),
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text("Create New Player", style: AppTypography.headlineLg.copyWith(color: AppColors.onPrimary)),
              SizedBox(height: 24),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: ResponsiveHelper.w(80),
                      height: ResponsiveHelper.w(80),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                      ),
                      child: Icon(Icons.person, color: AppColors.muted, size: 40),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.black, size: 16),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 32),
              _buildTextField(label: "Player Name *", controller: _nameController, hint: "e.g. Marcus Vance"),
              SizedBox(height: 16),
              _buildTextField(label: "DUPR Rating", controller: _ratingController, hint: "e.g. 4.5"),
              SizedBox(height: 16),
              _buildTextField(label: "Club Name", controller: _clubController, hint: "e.g. Northside Club"),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: ResponsiveHelper.h(56),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _createPlayer,
                  child: Text("ADD PLAYER", style: AppTypography.headlineMd.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.accent),
            ),
          ),
        ),
      ],
    );
  }
}
