import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class FooterActions extends StatelessWidget {
  final GroupInfoController ctrl;

  FooterActions({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        _buildFooterTile(Icons.logout, "Leave Group", Colors.redAccent, () {
          _showConfirmation(context, "Leave Group", "Are you sure you want to leave this group?", ctrl.leaveGroup);
        }),
        SizedBox(height: 8),
        _buildFooterTile(Icons.thumb_down_alt_outlined, "Report Group", Colors.redAccent, () {
           Get.snackbar('Reported', 'The group has been reported for review.',
              backgroundColor: _kSurface, colorText: Colors.white);
        }),
      ],
    );
  }

  Widget _buildFooterTile(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kSurface,
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: Text(content, style: TextStyle(color: _kMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
