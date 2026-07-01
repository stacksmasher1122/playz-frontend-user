import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

// Internal Widgets
import 'widgets/groups_app_bar.dart';
import 'widgets/search_and_filters.dart';
import 'widgets/my_squads_list.dart';
import 'widgets/recommended_for_you_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;

class GroupsScreen extends StatelessWidget {
  GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            GroupsAppBar(),
            SliverToBoxAdapter(child: SearchAndFilters()),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: MySquadsList()),
            SliverToBoxAdapter(child: RecommendedForYouSection()),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
