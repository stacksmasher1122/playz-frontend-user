import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cricket_setup_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SwitchCard extends StatelessWidget {
  final RxBool valueStream;
  final Function(bool) onChanged;
  final String title;
  final String subtitle;
  final IconData icon;

  SwitchCard({
    super.key,
    required this.valueStream,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: Color(0xFF28362B),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            child: Icon(
              icon,
              color: kGreen,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: kMutedText,
                    fontSize: ResponsiveHelper.sp(13),
                    height: ResponsiveHelper.h(1.2),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: kGreen,
              inactiveThumbColor: kMutedText,
              inactiveTrackColor: Color(0xFF2C2C2C),
              thumbColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.black;
                }
                return kMutedText;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
