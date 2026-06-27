import 'package:flutter/material.dart';

class QrSupportFooter extends StatelessWidget {
  const QrSupportFooter({super.key});

  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: const TextSpan(
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
