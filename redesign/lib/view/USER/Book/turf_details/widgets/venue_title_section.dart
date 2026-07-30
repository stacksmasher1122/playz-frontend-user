import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueTitleSection extends StatelessWidget {
  final String turfId;
  final String turfName;
  final String location;
  final bool isOpen;
  final String statusText;
  final double rating;

  const VenueTitleSection({
    super.key,
    required this.turfId,
    required this.turfName,
    required this.location,
    required this.isOpen,
    required this.statusText,
    this.rating = 4.5,
  });

  Future<int> _fetchReviewCount() async {
    final db = FirebaseFirestore.instance;
    try {
      final snap1 = await db.collection('Turf').doc(turfId).collection('reviews').get();
      if (snap1.docs.isNotEmpty) return snap1.docs.length;

      final groupSnap = await db.collectionGroup('reviews').get();
      int count = 0;
      for (final doc in groupSnap.docs) {
        final parentId = doc.reference.parent.parent?.id;
        final docTurfId = doc.data()['turfId']?.toString() ?? '';
        if (parentId == turfId || docTurfId == turfId) count++;
      }
      if (count > 0) return count;

      final snap3 = await db.collection('turfs').doc(turfId).collection('reviews').get();
      if (snap3.docs.isNotEmpty) return snap3.docs.length;
    } catch (e) {
      debugPrint('🔴 [VenueTitleSection] Count fetch error: $e');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final displayRating = rating > 0 ? rating.toStringAsFixed(1) : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// VENUE INFO
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.heightPct(1)),
              Text(
                turfName,
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(24),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.heightPct(0.6)),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.muted, size: 16),
                  SizedBox(width: context.widthPct(1)),
                  Expanded(
                    child: Text(
                      location,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3),
                      vertical: context.heightPct(0.6),
                    ),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                    ),
                    child: Text(
                      statusText,
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w600,
                        color: isOpen ? AppColors.accent : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: context.heightPct(1)),

        /// REAL RATING ROW & DYNAMIC REVIEW COUNT
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < rating.floor() ? Colors.amber : AppColors.muted,
                  ),
                ),
              ),
              SizedBox(width: context.widthPct(2)),
              Text(
                displayRating,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
              SizedBox(width: context.widthPct(1.5)),
              FutureBuilder<int>(
                future: _fetchReviewCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return Text(
                    '($count ${count == 1 ? 'Review' : 'Reviews'})',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
