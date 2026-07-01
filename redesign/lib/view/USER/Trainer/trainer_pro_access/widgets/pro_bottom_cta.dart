import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'pro_plan_card.dart';
import 'package:redesign/view/USER/Trainer/trainer_platform_fee/trainer_platform_fee_screen.dart';
import 'package:redesign/view/USER/Trainer/trainer_platform_fee_success/trainer_platform_fee_success_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class ProBottomCTA extends StatelessWidget {
  final List<ProPlan> plans;
  final ValueNotifier<int> selectedIndex;

  ProBottomCTA({
    super.key,
    required this.plans,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SafeArea(
      top: false,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (_, i, __) {
          final plan = plans[i];

          return Container(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
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
                          Text(
                            'Selected Plan',
                            style: TextStyle(
                              color: kMuted,
                              fontSize: ResponsiveHelper.sp(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.sp(14.5),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      plan.price,
                      style: TextStyle(
                        color: kGreen,
                        fontSize: ResponsiveHelper.sp(18),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                /// ───── Primary CTA Button ─────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TrainerPaymentSuccessScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
                      ),
                    ),
                    child: Text(
                      'Continue to Payment',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                /// ───── Skip Option ─────
                GestureDetector(
                  onTap: () {
                    // handle skip
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrainerLimitedAccessScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Skip for now (Limited Access)',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: ResponsiveHelper.sp(13),
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
