import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Trainer/trainer_payment/trainer_payment_screen.dart';
import '../package_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class PackageSelectionBottomCta extends StatelessWidget {
  final List<PackageModel> packages;
  final ValueNotifier<int> selectedIndex;

  PackageSelectionBottomCta({
    super.key,
    required this.packages,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (_, i, __) {
        final p = packages[i];
        return Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(color: Colors.black),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selected: ${p.title}',
                style: TextStyle(color: kMuted),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PaymentSuccessScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                    ),
                  ),
                  child: Text(
                    'Continue — ₹${p.price}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
