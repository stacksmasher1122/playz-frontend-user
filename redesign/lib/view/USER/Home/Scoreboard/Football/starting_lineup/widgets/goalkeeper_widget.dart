import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/player_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GoalkeeperWidget extends StatelessWidget {
  final PlayerModel? goalkeeper;
  final VoidCallback onTap;

  GoalkeeperWidget({
    super.key,
    required this.goalkeeper,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    if (goalkeeper == null) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveHelper.w(50),
              height: ResponsiveHelper.h(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFC6FF00), width: 2),
                color: Colors.green.shade900.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Icon(Icons.add, color: Color(0xFFC6FF00), size: 24),
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text(
                'GK',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.w(50),
            height: ResponsiveHelper.h(50),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade900, // distinctive GK color
              border: Border.all(color: Color(0xFFC6FF00), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC6FF00).withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: goalkeeper!.avatarImage != null
                  ? Image.network(goalkeeper!.avatarImage!, fit: BoxFit.cover)
                  : Icon(Icons.person, color: Colors.grey.shade400, size: 30),
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
            ),
            child: Text(
              goalkeeper!.name.toUpperCase(),
              style: TextStyle(
                color: Color(0xFFC6FF00),
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
