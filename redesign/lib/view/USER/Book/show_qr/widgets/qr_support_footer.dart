import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrSupportFooter extends StatelessWidget {
  QrSupportFooter({super.key});

  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Having trouble at the venue? ',
          style: TextStyle(color: _kMuted),
          children: [
            TextSpan(
              text: 'Contact Support',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
