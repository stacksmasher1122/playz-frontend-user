import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

// Internal Widgets
import 'widgets/groups_app_bar.dart';
import 'widgets/search_and_filters.dart';
import 'widgets/my_squads_list.dart';
import 'widgets/recommended_for_you_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const GroupsAppBar(),
            const SliverToBoxAdapter(child: SearchAndFilters()),
            SliverToBoxAdapter(child: SizedBox(height: context.heightPct(2))),
            const SliverToBoxAdapter(child: MySquadsList()),
            const SliverToBoxAdapter(child: RecommendedForYouSection()),
            SliverToBoxAdapter(child: SizedBox(height: context.heightPct(4))),
          ],
        ),
      ),
    );
  }
}
