import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Trainer/book_trainer/book_trainer_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kGreen = AppColors.accent;

class AcademyDetailBottomBar extends StatelessWidget {
  AcademyDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.7),
            border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: kGreen),
                    foregroundColor: kGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                  ),
                  child: Text('Chat with Academy'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ChoosePackageScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                  ),
                  child: Text('Book Trial'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
