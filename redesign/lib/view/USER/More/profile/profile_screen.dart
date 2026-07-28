import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/view/USER/More/edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          /// Rounded Square Pen Edit Button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditProfileScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.4)),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Color(0xFF00E676),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.rxUser.value;
        final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'PlayZ Athlete';
        final username = user?.effectiveUsername ?? '@player';
        final bio = user?.bio.isNotEmpty == true ? user!.bio : 'Sports Enthusiast & PlayZ Athlete 🏆';
        final imageUrl = user?.profileImageUrl ?? '';
        final currentXp = user?.xpPoints ?? 100;
        final tier = TierHelper.getTierFromXp(currentXp);
        final tierGradient = TierHelper.getTierGradient(tier);
        final subStatus = user?.subscriptionStatus ?? 'FREE';
        final isPremium = subStatus.toUpperCase().contains('PREMIUM');
        final sports = user?.favoriteSports ?? ['Cricket', 'Badminton', 'Football'];

        // Calculate next tier target
        int nextTierXp = 500;
        if (currentXp >= 7500) {
          nextTierXp = 10000;
        } else if (currentXp >= 3500) {
          nextTierXp = 7500;
        } else if (currentXp >= 1500) {
          nextTierXp = 3500;
        } else if (currentXp >= 500) {
          nextTierXp = 1500;
        }
        final double xpProgress = (currentXp / nextTierXp).clamp(0.0, 1.0);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            /// PROFILE AVATAR WITH TIER GRADIENT GLOW BORDER
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 106,
                    height: 106,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: tierGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E676).withValues(alpha: 0.25),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF121212),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipOval(
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Shimmer.fromColors(
                                  baseColor: Colors.grey.shade800,
                                  highlightColor: Colors.grey.shade700,
                                  child: const CircleAvatar(backgroundColor: Color(0xFF1E1E1E)),
                                ),
                                errorWidget: (_, __, ___) => const CircleAvatar(
                                  backgroundColor: Color(0xFF1A1A1A),
                                  child: Icon(Icons.person, color: Colors.white38, size: 40),
                                ),
                              )
                            : const CircleAvatar(
                                backgroundColor: Color(0xFF1A1A1A),
                                child: Icon(Icons.person, color: Colors.white38, size: 40),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            /// NAME & USERNAME
            Center(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                username,
                style: GoogleFonts.inter(
                  color: const Color(0xFF00E676),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// BIO / DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                bio,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// TIER & XP CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// TIER PILL BADGE WITH TIER GRADIENT
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: tierGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          tier,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '$currentXp XP',
                            style: GoogleFonts.inter(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tier Progress',
                        style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        '$currentXp / $nextTierXp XP',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: xpProgress,
                      minHeight: 8,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            /// SUBSCRIPTION STATUS CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPremium ? const Color(0xFFC9A876) : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isPremium ? AppColors.tierZPremium : AppColors.tierRookie,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPremium ? Icons.workspace_premium_rounded : Icons.star_border_rounded,
                      color: isPremium ? Colors.black : Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium ? 'Z PREMIUM MEMBER' : 'FREE PLAYER PLAN',
                          style: GoogleFonts.inter(
                            color: isPremium ? const Color(0xFFC9A876) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isPremium
                              ? 'Unlimited Scoreboard sessions & VIP stats access'
                              : 'Upgrade to Z Premium for zero ads & priority slots',
                          style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            /// SPORTS PLAYED SECTION
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_soccer_rounded, color: Color(0xFF00E676), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SPORTS PLAYED',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF00E676),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sports.map((sport) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          sport,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
