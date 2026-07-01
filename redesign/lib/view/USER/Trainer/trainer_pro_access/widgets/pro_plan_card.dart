import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);
const kGold = Color(0xFFF5C542);
const kCard = Color(0xFF1A1A1A);

class ProPlan {
  final String title, price, monthly, subtitle;
  final String? badge, savings;

  ProPlan({
    required this.title,
    required this.price,
    required this.monthly,
    required this.subtitle,
    this.badge,
    this.savings,
  });
}

class ProPlanCard extends StatelessWidget {
  final ProPlan plan;
  final bool selected;
  final VoidCallback onTap;

  ProPlanCard({
    super.key,
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 280),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(
          color: selected ? kGreen : Colors.transparent,
          width: ResponsiveHelper.w(1.4),
        ),
        boxShadow: selected
            ? [BoxShadow(color: kGreen.withValues(alpha: 0.28), blurRadius: 5)]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.badge != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: plan.badge == 'BEST VALUE' ? kGold : kGreen,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  ),
                  child: Text(
                    plan.badge!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    plan.price,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selected)
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.check_circle, color: kGreen, size: 18),
                    ),
                ],
              ),
              SizedBox(height: 6),
              Text(plan.monthly, style: TextStyle(color: kMuted)),
              if (plan.savings != null)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    plan.savings!,
                    style: TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              SizedBox(height: 6),
              Text(
                plan.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: kMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
