import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

// Internal Widgets
import 'widgets/groups_app_bar.dart';
import 'widgets/search_and_filters.dart';
import 'widgets/my_squads_list.dart';
import 'widgets/recommended_for_you_section.dart';

const kBg = AppColors.background;

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
