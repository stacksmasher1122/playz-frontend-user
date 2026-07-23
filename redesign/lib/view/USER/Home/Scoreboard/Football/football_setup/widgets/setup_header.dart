import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupHeader extends StatelessWidget {
  final MatchMode mode;

  SetupHeader({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
      color: kBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: kTextPrimary),
          Text(
            mode == MatchMode.friendly ? 'FRIENDLY MATCH' : 'TOURNAMENT SETUP',
            style: TextStyle(
              color: kTextPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: ResponsiveHelper.sp(14),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: kTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
