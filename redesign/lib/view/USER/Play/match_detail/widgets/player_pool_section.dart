import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerPoolSection extends StatelessWidget {
  PlayerPoolSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Player Pool",
          style: TextStyle(fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: ResponsiveHelper.h(110),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => SizedBox(width: 18),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(3)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.yellow, Colors.red],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?u=$index",
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Player ${index + 1}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
