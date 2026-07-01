import 'package:flutter/material.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

import 'package:redesign/view/USER/Maps/maps_setup/widgets/interactive_search_bar.dart';

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
    return Container(
      height: maxExtent,
      color: kBg,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 14),
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
