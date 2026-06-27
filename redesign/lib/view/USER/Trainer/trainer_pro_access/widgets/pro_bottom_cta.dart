import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'pro_plan_card.dart';
import 'package:redesign/view/USER/Trainer/trainer_platform_fee/trainer_platform_fee_screen.dart';
import 'package:redesign/view/USER/Trainer/trainer_platform_fee_success/trainer_platform_fee_success_screen.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class ProBottomCTA extends StatelessWidget {
  final List<ProPlan> plans;
  final ValueNotifier<int> selectedIndex;

  const ProBottomCTA({
    super.key,
    required this.plans,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (_, i, __) {
          final plan = plans[i];

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: kCard)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ───── Selected Plan Row ─────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Plan',
                            style: TextStyle(
                              color: kMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      plan.price,
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ───── Primary CTA Button ─────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TrainerPaymentSuccessScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'Continue to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// ───── Skip Option ─────
                GestureDetector(
                  onTap: () {
                    // handle skip
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TrainerLimitedAccessScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip for now (Limited Access)',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
