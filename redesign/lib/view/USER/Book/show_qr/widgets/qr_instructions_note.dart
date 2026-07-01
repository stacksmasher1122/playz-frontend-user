import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrInstructionsNote extends StatelessWidget {
  QrInstructionsNote({super.key});

  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Text(
      'This QR code is valid only for the selected slot.\n'
      'Keep your screen brightness high and show it at the gate or reception for a quick check-in.',
      style: TextStyle(color: _kMuted, height: 1.4),
    );
  }
}
