import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OfferTimerBanner extends StatelessWidget {
  final String text;
  OfferTimerBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'SPECIAL OFFER ENDS IN $text',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveHelper.sp(12.5),
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
