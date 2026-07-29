import 'package:flutter/material.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'interactive_search_bar.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final MapsController mapsCtrl;

  SearchBarDelegate(this.searchController, this.mapsCtrl);

  @override
  double get minExtent => 74;

  @override
  double get maxExtent => 74;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    ResponsiveHelper.init(context);
    return Container(
      height: maxExtent,
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.5),
        context.widthPct(4),
        context.heightPct(1.8),
      ),
      child: InteractiveSearchBar(
        controller: searchController,
        mapsCtrl: mapsCtrl,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
