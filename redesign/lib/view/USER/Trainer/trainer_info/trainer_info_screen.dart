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

const Color kBg = Colors.black;

class AcademyDetailScreen extends StatefulWidget {
  const AcademyDetailScreen({super.key});

  @override
  State<AcademyDetailScreen> createState() => _AcademyDetailScreenState();
}

class _AcademyDetailScreenState extends State<AcademyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          const HeroSection(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const AcademyInfoSection(),
                const SizedBox(height: 16),
                const ActivityRow(),
                const SizedBox(height: 16),
                const StudentTypeSelector(),
                const SizedBox(height: 16),
                const AnnouncementBanner(),
                const SizedBox(height: 24),
                const LocationMapCard(),
                const SizedBox(height: 24),
                const AcademyPackagesList(),
                const SizedBox(height: 24),
                const FacilityInfoGrid(),
                const SizedBox(height: 24),
                const SafetyAmenitiesTags(),
                const SizedBox(height: 24),
                const AcademyReviewsSection(),
                const SizedBox(height: 24),
                const AcademyGalleryPreview(),
                const SizedBox(height: 24),
                const CertificationsBadges(),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AcademyDetailBottomBar(),
    );
  }
}
