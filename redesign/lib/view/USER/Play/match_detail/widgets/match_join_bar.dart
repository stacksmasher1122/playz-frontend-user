import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchJoinBar extends StatelessWidget {
  MatchJoinBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 36),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.95)],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MatchDetailColors.primary,
            foregroundColor: Colors.black,
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(40)),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Join Match",
                style: TextStyle(fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    "₹200",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "₹150",
                    style: TextStyle(fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
