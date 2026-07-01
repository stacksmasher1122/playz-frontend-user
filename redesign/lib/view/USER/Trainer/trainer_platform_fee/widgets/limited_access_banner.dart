import 'package:flutter/material.dart';

const kMuted = Color(0xFFA7A7A7);
const kAmber = Color(0xFFF5C542);

class LimitedAccessBanner extends StatelessWidget {
  const LimitedAccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            kAmber.withValues(alpha: 0.25),
            Colors.black,
          ],
        ),
        border: Border.all(
          color: kAmber.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.warning_amber_rounded,
              color: kAmber, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "You're in Limited Access",
                  style: TextStyle(
                    color: kAmber,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Some trainer features are locked until you activate a Trainer Pro plan.',
                  style:
                      TextStyle(color: kMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
