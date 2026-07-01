import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(label, style: GoogleFonts.inter(color: color)),
        trailing: Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}
