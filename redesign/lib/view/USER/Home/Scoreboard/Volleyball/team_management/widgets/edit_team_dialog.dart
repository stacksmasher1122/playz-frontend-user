import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EditTeamDialog extends StatefulWidget {
  final bool isTeamA;
  final VolleyballTeamModel team;
  final VolleyballTeamManagementController controller;

  EditTeamDialog({super.key, required this.isTeamA, required this.team, required this.controller});

  @override
  State<EditTeamDialog> createState() => _EditTeamDialogState();
}

class _EditTeamDialogState extends State<EditTeamDialog> {
  late TextEditingController nameController;
  late TextEditingController coachController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.team.teamName);
    coachController = TextEditingController(text: widget.team.coachName);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Dialog(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(20))),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(24.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Team Details', style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            TextField(
              controller: nameController,
              style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
              decoration: InputDecoration(
                labelText: 'Team Name',
                labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: coachController,
              style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
              decoration: InputDecoration(
                labelText: 'Coach Name',
                labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                  ),
                  onPressed: () {
                    widget.controller.updateTeamDetails(widget.isTeamA, nameController.text, coachController.text);
                    Navigator.pop(context);
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
