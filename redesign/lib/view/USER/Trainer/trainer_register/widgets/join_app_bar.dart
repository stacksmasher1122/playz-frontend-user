import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);

class JoinAppBar extends StatelessWidget {
  JoinAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join as a Trainer',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Complete your profile to start earning',
              style: TextStyle(color: kMuted, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
