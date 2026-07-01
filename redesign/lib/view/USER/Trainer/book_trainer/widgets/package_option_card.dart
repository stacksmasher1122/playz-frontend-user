import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import '../package_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kCard = Color(0xFF1A1A1A);
const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);
const kSurface = AppColors.surface;
const kYellow = Color(0xFFF5C542);

class PackageOptionCard extends StatelessWidget {
  final PackageModel data;
  final bool selected;
  final VoidCallback onTap;

  PackageOptionCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: ResponsiveHelper.w(1.6),
            ),
            boxShadow: selected
                ? [BoxShadow(color: kGreen.withValues(alpha: 0.35), blurRadius: 16)]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (data.badge != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: data.badgeColor ?? kGreen,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                      ),
                      child: Text(
                        data.badge!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Spacer(),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? kGreen : kMuted,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                data.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                data.desc,
                style: TextStyle(color: kMuted, height: 1.4),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.chips
                    .map(
                      (e) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                        ),
                        child: Text(
                          e,
                          style: TextStyle(color: kMuted, fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 12),
              Divider(color: Colors.white10),
              Row(
                children: [
                  Text(
                    '₹${data.price}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '+${data.coins} Z Coins',
                    style: TextStyle(
                      color: kYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                data.billing,
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
