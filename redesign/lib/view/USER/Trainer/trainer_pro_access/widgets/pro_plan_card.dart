import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);
const kGold = Color(0xFFF5C542);
const kCard = Color(0xFF1A1A1A);

class ProPlan {
  final String title, price, monthly, subtitle;
  final String? badge, savings;

  const ProPlan({
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

  const ProPlanCard({
    super.key,
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? kGreen : Colors.transparent,
          width: 1.4,
        ),
        boxShadow: selected
            ? [BoxShadow(color: kGreen.withOpacity(0.28), blurRadius: 5)]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: plan.badge == 'BEST VALUE' ? kGold : kGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    plan.badge!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    plan.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selected)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.check_circle, color: kGreen, size: 18),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(plan.monthly, style: const TextStyle(color: kMuted)),
              if (plan.savings != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    plan.savings!,
                    style: const TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                plan.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: kMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
