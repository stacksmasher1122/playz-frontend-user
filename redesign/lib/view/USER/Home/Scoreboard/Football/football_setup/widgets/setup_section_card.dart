import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool isExpanded;

  SetupSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(8)),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
              child: Icon(icon, color: kAccent, size: 20),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: kTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
                letterSpacing: 0.5,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
