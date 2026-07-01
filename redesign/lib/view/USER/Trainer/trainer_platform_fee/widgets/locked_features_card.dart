import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_card_wrapper.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);
const kGreen = AppColors.accent;

class LockedFeaturesCard extends StatelessWidget {
  LockedFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FeeCardWrapper(
      title: 'LOCKED FEATURES',
      trailing:
          Icon(Icons.lock, color: kMuted),
      children: [
        LockRow('Public trainer listing & search'),
        LockRow('Receiving student leads'),
        LockRow('In-app chat with students'),
        LockRow('Accepting payments & bookings'),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          decoration: BoxDecoration(
            color: kGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: kGreen, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Unlock all features to start earning and growing your career immediately.',
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LockRow extends StatelessWidget {
  final String text;
  LockRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.lock_outline,
              color: kMuted, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: kMuted)),
          ),
        ],
      ),
    );
  }
}
