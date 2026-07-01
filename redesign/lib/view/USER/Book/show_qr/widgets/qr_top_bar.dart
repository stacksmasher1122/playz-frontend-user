import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrTopBar extends StatelessWidget {
  QrTopBar({super.key});

  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Show this QR Code at the Venue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your booking is confirmed. This is your entry pass.',
                style: TextStyle(color: _kMuted, fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
