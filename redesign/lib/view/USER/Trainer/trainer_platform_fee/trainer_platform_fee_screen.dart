import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'widgets/limited_access_header.dart';
import 'widgets/limited_access_banner.dart';
import 'widgets/current_status_card.dart';
import 'widgets/allowed_features_card.dart';
import 'widgets/locked_features_card.dart';
import 'widgets/limited_access_bottom_bar.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;

class TrainerLimitedAccessScreen extends StatelessWidget {
  TrainerLimitedAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            LimitedAccessHeader(),
            SliverPadding(
              padding:
                  EdgeInsets.fromLTRB(16, 12, 16, 140 + bottomInset),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  LimitedAccessBanner(),
                  SizedBox(height: 20),
                  CurrentStatusCard(),
                  SizedBox(height: 20),
                  AllowedFeaturesCard(),
                  SizedBox(height: 20),
                  LockedFeaturesCard(),
                ]),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM ACTIONS
      bottomNavigationBar: LimitedAccessBottomBar(),
    );
  }
}
