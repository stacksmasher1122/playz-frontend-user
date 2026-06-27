import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'widgets/limited_access_header.dart';
import 'widgets/limited_access_banner.dart';
import 'widgets/current_status_card.dart';
import 'widgets/allowed_features_card.dart';
import 'widgets/locked_features_card.dart';
import 'widgets/limited_access_bottom_bar.dart';

const kBg = AppColors.background;

class TrainerLimitedAccessScreen extends StatelessWidget {
  const TrainerLimitedAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const LimitedAccessHeader(),
            SliverPadding(
              padding:
                  EdgeInsets.fromLTRB(16, 12, 16, 140 + bottomInset),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const LimitedAccessBanner(),
                  const SizedBox(height: 20),
                  const CurrentStatusCard(),
                  const SizedBox(height: 20),
                  const AllowedFeaturesCard(),
                  const SizedBox(height: 20),
                  const LockedFeaturesCard(),
                ]),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM ACTIONS
      bottomNavigationBar: const LimitedAccessBottomBar(),
    );
  }
}
