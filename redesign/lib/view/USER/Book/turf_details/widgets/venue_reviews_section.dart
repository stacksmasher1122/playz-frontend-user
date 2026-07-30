import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../all_reviews_screen.dart';

class VenueReviewsSection extends StatelessWidget {
  final String turfId;
  final String turfName;
  final double rating;

  const VenueReviewsSection({
    super.key,
    required this.turfId,
    required this.turfName,
    this.rating = 4.5,
  });

  Future<List<ReviewModel>> _fetchTurfReviews() async {
    final List<ReviewModel> list = [];
    final db = FirebaseFirestore.instance;

    try {
      final snap1 = await db.collection('Turf').doc(turfId).collection('reviews').get();
      if (snap1.docs.isNotEmpty) {
        return snap1.docs.map((d) => ReviewModel.fromFirestore(d)).toList();
      }

      final groupSnap = await db.collectionGroup('reviews').get();
      for (final doc in groupSnap.docs) {
        final parentId = doc.reference.parent.parent?.id;
        final docTurfId = doc.data()['turfId']?.toString() ?? '';
        if (parentId == turfId || docTurfId == turfId) {
          list.add(ReviewModel.fromFirestore(doc));
        }
      }
      if (list.isNotEmpty) return list;

      final snap3 = await db.collection('turfs').doc(turfId).collection('reviews').get();
      if (snap3.docs.isNotEmpty) {
        return snap3.docs.map((d) => ReviewModel.fromFirestore(d)).toList();
      }
    } catch (e) {
      debugPrint('🔴 [VenueReviewsSection] Review fetch error: $e');
    }

    return list;
  }

  Widget _buildUserAvatar(String url, {double radius = 18}) {
    final cleanUrl = url.trim();
    if (cleanUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.surfaceElevated,
        child: Icon(Icons.person, size: radius * 1.1, color: AppColors.muted),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceElevated,
      foregroundImage: NetworkImage(cleanUrl),
      onForegroundImageError: (_, __) {},
      child: Icon(Icons.person, size: radius * 1.1, color: AppColors.muted),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return FutureBuilder<List<ReviewModel>>(
      future: _fetchTurfReviews(),
      builder: (context, snapshot) {
        final List<ReviewModel> reviews = snapshot.data ?? [];
        final reviewCount = reviews.length;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Reviews',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllReviewsScreen(
                            turfId: turfId,
                            turfName: turfName,
                            overallRating: rating,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View All ($reviewCount)',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(13),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(1.2)),

              if (reviews.isNotEmpty)
                ...reviews.take(2).map((r) => Padding(
                      padding: EdgeInsets.only(bottom: context.heightPct(1.2)),
                      child: _reviewCard(context, r.userName, r.userPic, r.rating, r.comment),
                    ))
              else
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(1)),
                  child: Text(
                    'No reviews yet for this turf.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _reviewCard(
      BuildContext context, String name, String picUrl, double ratingVal, String comment) {
    final avatarRadius = context.minDimensionPct(5).clamp(18.0, 24.0);

    return Container(
      padding: EdgeInsets.all(context.widthPct(3)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserAvatar(picUrl, radius: avatarRadius),
          SizedBox(width: context.widthPct(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 13,
                          color: index < ratingVal.floor() ? Colors.amber : AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  comment.isNotEmpty ? comment : 'No detailed message provided.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
