import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;

class BuildSquadCTA extends StatelessWidget {
  BuildSquadCTA({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(18)),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(22)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build a New Squad',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Book turfs faster with your team.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
                ),
              ),
              child: Text('Start Now'),
            ),
          ],
        ),
      ),
    );
  }
}
