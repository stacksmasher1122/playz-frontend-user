import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'widgets/success_ripple.dart';
import 'widgets/membership_summary_card.dart';
import 'widgets/benefits_unlocked_card.dart';
import 'widgets/next_steps_card.dart';
import 'widgets/payment_details_card.dart';
import 'widgets/fee_success_bottom_bar.dart';

const kBg = AppColors.background;
const kMuted = Color(0xFFA7A7A7);

class TrainerPaymentSuccessScreen extends StatefulWidget {
  const TrainerPaymentSuccessScreen({super.key});

  @override
  State<TrainerPaymentSuccessScreen> createState() =>
      _TrainerPaymentSuccessScreenState();
}

class _TrainerPaymentSuccessScreenState
    extends State<TrainerPaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 40, 16, 140 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SuccessRipple(),
              SizedBox(height: 24),

              /// SUCCESS TEXT
              Text(
                'Payment Successful!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Your Trainer Pro membership is now active',
                style: TextStyle(color: kMuted, fontSize: 14),
              ),

              SizedBox(height: 28),

              /// MEMBERSHIP CARD
              MembershipSummaryCard(),

              SizedBox(height: 20),

              /// BENEFITS
              BenefitsUnlockedCard(),

              SizedBox(height: 20),

              /// NEXT STEPS
              NextStepsCard(),

              SizedBox(height: 20),

              /// PAYMENT DETAILS
              PaymentDetailsCard(),
            ],
          ),
        ),
      ),

      /// BOTTOM CTA
      bottomNavigationBar: const FeeSuccessBottomBar(),
    );
  }
}
