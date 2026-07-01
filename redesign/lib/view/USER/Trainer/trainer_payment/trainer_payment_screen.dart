import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'widgets/payment_ripple_effect.dart';
import 'widgets/academy_summary_card.dart';
import 'widgets/package_purchased_card.dart';
import 'widgets/trainer_action_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;
const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class PaymentSuccessScreen extends StatefulWidget {
  PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _successController;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();

    _successController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..forward();

    _rippleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _successController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// SUCCESS ICON
              SizedBox(
                height: ResponsiveHelper.h(140),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PaymentRippleEffect(controller: _rippleController),
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _successController,
                        curve: Curves.easeOutBack,
                      ),
                      child: Container(
                        width: ResponsiveHelper.w(64),
                        height: ResponsiveHelper.h(64),
                        decoration: BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kGreen.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.black,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              /// SUCCESS TEXT
              FadeTransition(
                opacity: _successController,
                child: Column(
                  children: [
                    Text(
                      'Payment Successful!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You are successfully enrolled in the\n1-Day Trial Access program.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kMuted,
                        fontSize: ResponsiveHelper.sp(14),
                        height: ResponsiveHelper.h(1.4),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28),

              /// ACADEMY CARD
              AcademySummaryCard(),

              SizedBox(height: 16),

              /// PACKAGE CARD
              PackagePurchasedCard(),

              SizedBox(height: 28),

              /// ACTIONS
              TrainerActionButton(
                text: 'Chat with Academy',
                icon: Icons.chat_bubble_outline,
                onTap: () {
                  // navigate to chat
                },
              ),

              SizedBox(height: 16),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: ResponsiveHelper.sp(14),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
