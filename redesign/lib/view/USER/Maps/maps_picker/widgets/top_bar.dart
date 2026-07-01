import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MapPickerTopBar extends StatelessWidget {
  MapPickerTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 4),
          Text(
            "Select Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
