import 'package:flutter/material.dart';
import 'fee_card_wrapper.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);
const kAmber = Color(0xFFF5C542);

class CurrentStatusCard extends StatelessWidget {
  CurrentStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FeeCardWrapper(
      title: 'CURRENT STATUS',
      children: [
        StatusRow('Membership Plan', 'None'),
        StatusRow(
          'Access Level',
          'Limited',
          badge: true,
        ),
        StatusRow('Visibility', 'Private'),
      ],
    );
  }
}

class StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final bool badge;

  StatusRow(
    this.label,
    this.value, {
    super.key,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style:
                    TextStyle(color: kMuted)),
          ),
          badge
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
                  decoration: BoxDecoration(
                    color: kAmber.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(ResponsiveHelper.w(20)),
                  ),
                  child: Text(
                    'Limited',
                    style: TextStyle(
                      color: kAmber,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Text(value,
                  style: TextStyle(
                      color: Colors.white)),
        ],
      ),
    );
  }
}
