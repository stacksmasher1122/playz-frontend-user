import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';

class AddPlayerDialog extends StatefulWidget {
  final bool isTeamA;
  final VolleyballTeamManagementController controller;

  const AddPlayerDialog({super.key, required this.isTeamA, required this.controller});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String selectedPosition = 'Outside Hitter (OH)';
  bool isCaptain = false;
  bool isLibero = false;

  final List<String> positions = [
    'Setter (S)',
    'Outside Hitter (OH)',
    'Middle Blocker (MB)',
    'Opposite (OPP)',
    'Libero (L)',
    'Defensive Specialist (DS)',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Player', style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
              decoration: InputDecoration(
                labelText: 'Player Name',
                labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
              decoration: InputDecoration(
                labelText: 'Jersey Number',
                labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPosition,
              decoration: InputDecoration(
                labelText: 'Position',
                labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              dropdownColor: AppColors.surfaceContainerHigh,
              items: positions.map((pos) => DropdownMenuItem(
                value: pos,
                child: Text(pos, style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
              )).toList(),
              onChanged: (val) {
                setState(() {
                  selectedPosition = val!;
                  if (val.contains('Libero')) isLibero = true;
                  else isLibero = false;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isCaptain,
                  onChanged: (val) => setState(() => isCaptain = val ?? false),
                  activeColor: AppColors.primaryContainer,
                ),
                Text('Team Captain', style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                      final newPlayer = VolleyballPlayerModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        jerseyNumber: numberController.text,
                        position: selectedPosition,
                        isCaptain: isCaptain,
                        isLibero: isLibero,
                      );
                      widget.controller.addPlayer(widget.isTeamA, newPlayer);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Player'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
