import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import '../cricket_setup_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StartMatchButton extends StatelessWidget {
  final CricketController controller;

  StartMatchButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.only(left: ResponsiveHelper.w(20), right: ResponsiveHelper.w(20), bottom: ResponsiveHelper.h(30), top: 10),
      color: kBg,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (controller.homeTeamName.value.trim().isEmpty ||
                      controller.awayTeamName.value.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter names for both teams'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoinFlipScreen(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            foregroundColor: Colors.black,
            disabledBackgroundColor: kGreen.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: ResponsiveHelper.w(24),
                  height: ResponsiveHelper.h(24),
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'START MATCH',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.sports_cricket_rounded, size: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
