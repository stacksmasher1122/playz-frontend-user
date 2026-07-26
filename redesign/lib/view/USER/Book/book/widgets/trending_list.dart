import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'trending_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrendingList extends StatelessWidget {
  TrendingList({super.key});

  final _controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      height: ResponsiveHelper.h(170),
      child: Obx(() {
        // Loading state
        if (_controller.isLoadingTurfs.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(width: 14),
            itemBuilder: (_, i) => Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade800,
              child: Container(
                width: ResponsiveHelper.w(150),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                ),
              ),
            ),
          );
        }

        // Take first 5 verified turfs as "trending"
        final trending = _controller.allTurfs.take(5).toList();

        if (trending.isEmpty) {
          return Center(
            child: Text(
              'No trending turfs',
              style: TextStyle(color: AppColors.muted),
            ),
          );
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
          itemCount: trending.length,
          separatorBuilder: (_, __) => SizedBox(width: 14),
          itemBuilder: (_, i) => TrendingTile(turf: trending[i]),
        );
      }),
    );
  }
}
