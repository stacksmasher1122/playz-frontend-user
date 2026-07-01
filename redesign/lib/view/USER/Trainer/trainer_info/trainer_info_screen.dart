import 'package:flutter/material.dart';
import 'widgets/hero_section.dart';
import 'widgets/academy_info_section.dart';
import 'widgets/activity_row.dart';
import 'widgets/student_type_selector.dart';
import 'widgets/announcement_banner.dart';
import 'widgets/location_map_card.dart';
import 'widgets/academy_packages_list.dart';
import 'widgets/facility_info_grid.dart';
import 'widgets/safety_amenities_tags.dart';
import 'widgets/academy_reviews_section.dart';
import 'widgets/academy_gallery_preview.dart';
import 'widgets/certifications_badges.dart';
import 'widgets/academy_detail_bottom_bar.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = Colors.black;

class AcademyDetailScreen extends StatefulWidget {
  AcademyDetailScreen({super.key});

  @override
  State<AcademyDetailScreen> createState() => _AcademyDetailScreenState();
}

class _AcademyDetailScreenState extends State<AcademyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          HeroSection(),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AcademyInfoSection(),
                SizedBox(height: 16),
                ActivityRow(),
                SizedBox(height: 16),
                StudentTypeSelector(),
                SizedBox(height: 16),
                AnnouncementBanner(),
                SizedBox(height: 24),
                LocationMapCard(),
                SizedBox(height: 24),
                AcademyPackagesList(),
                SizedBox(height: 24),
                FacilityInfoGrid(),
                SizedBox(height: 24),
                SafetyAmenitiesTags(),
                SizedBox(height: 24),
                AcademyReviewsSection(),
                SizedBox(height: 24),
                AcademyGalleryPreview(),
                SizedBox(height: 24),
                CertificationsBadges(),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AcademyDetailBottomBar(),
    );
  }
}
