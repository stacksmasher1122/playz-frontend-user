import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ReviewModel {
  final String id;
  final String userName;
  final String userPic;
  final double rating;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userPic,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ReviewModel(
      id: doc.id,
      userName: data['userName'] ??
          data['name'] ??
          data['user'] ??
          data['displayName'] ??
          data['userNameText'] ??
          'Anonymous Player',
      userPic: data['userPic'] ??
          data['imageUrl'] ??
          data['userImage'] ??
          data['photoUrl'] ??
          data['avatar'] ??
          '',
      rating: (data['rating'] ?? data['stars'] ?? data['score'] ?? 5.0).toDouble(),
      comment: data['comment'] ??
          data['review'] ??
          data['feedback'] ??
          data['message'] ??
          data['text'] ??
          '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class AllReviewsScreen extends StatefulWidget {
  final String turfId;
  final String turfName;
  final double overallRating;

  const AllReviewsScreen({
    super.key,
    required this.turfId,
    required this.turfName,
    required this.overallRating,
  });

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  int _selectedStar = 0; // 0 = All

  Future<List<ReviewModel>> _fetchTurfReviews() async {
    final List<ReviewModel> list = [];
    final db = FirebaseFirestore.instance;

    try {
      // 1. Direct subcollection Turf/{turfId}/reviews
      final snap1 = await db.collection('Turf').doc(widget.turfId).collection('reviews').get();
      if (snap1.docs.isNotEmpty) {
        return snap1.docs.map((d) => ReviewModel.fromFirestore(d)).toList();
      }

      // 2. collectionGroup('reviews') for matching turfId
      final groupSnap = await db.collectionGroup('reviews').get();
      for (final doc in groupSnap.docs) {
        final parentId = doc.reference.parent.parent?.id;
        final docTurfId = doc.data()['turfId']?.toString() ?? '';
        if (parentId == widget.turfId || docTurfId == widget.turfId) {
          list.add(ReviewModel.fromFirestore(doc));
        }
      }
      if (list.isNotEmpty) return list;

      // 3. turfs/{turfId}/reviews
      final snap3 = await db.collection('turfs').doc(widget.turfId).collection('reviews').get();
      if (snap3.docs.isNotEmpty) {
        return snap3.docs.map((d) => ReviewModel.fromFirestore(d)).toList();
      }
    } catch (e) {
      debugPrint('🔴 [AllReviewsScreen] Review fetch error: $e');
    }

    return list;
  }

  Widget _buildUserAvatar(String url, {double radius = 20}) {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'REVIEWS',
          style: AppTypography.displayLg.copyWith(
            color: AppColors.accent,
            fontSize: context.responsiveFont(18),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FutureBuilder<List<ReviewModel>>(
        future: _fetchTurfReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          final List<ReviewModel> reviews = snapshot.data ?? [];

          // Apply star filter
          final filteredReviews = _selectedStar == 0
              ? reviews
              : reviews.where((r) => r.rating.round() == _selectedStar).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Rating Overview Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(context.widthPct(4)),
                  child: Container(
                    padding: EdgeInsets.all(context.widthPct(4)),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.overallRating > 0
                                  ? widget.overallRating.toStringAsFixed(1)
                                  : '0.0',
                              style: AppTypography.displayLg.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(36),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: i < widget.overallRating.floor()
                                      ? Colors.amber
                                      : AppColors.muted,
                                ),
                              ),
                            ),
                            SizedBox(height: context.heightPct(0.4)),
                            Text(
                              '${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'}',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: context.responsiveFont(12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: context.widthPct(5)),
                        Expanded(
                          child: Column(
                            children: List.generate(5, (index) {
                              final starCount = 5 - index;
                              final count = reviews
                                  .where((r) => r.rating.round() == starCount)
                                  .length;
                              final pct = reviews.isNotEmpty
                                  ? count / reviews.length
                                  : 0.0;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.heightPct(0.3),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '$starCount★',
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: context.responsiveFont(11),
                                      ),
                                    ),
                                    SizedBox(width: context.widthPct(2)),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: pct,
                                          backgroundColor: AppColors.card,
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            AppColors.accent,
                                          ),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Spotify-style Star Filter Chips (Fixed Size & Alignment)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                    children: [
                      _buildFilterChip('All', 0),
                      _buildFilterChip('5 ⭐', 5),
                      _buildFilterChip('4 ⭐', 4),
                      _buildFilterChip('3 ⭐', 3),
                      _buildFilterChip('2 ⭐', 2),
                      _buildFilterChip('1 ⭐', 1),
                    ],
                  ),
                ),
              ),

              // Spacing sliver
              SliverToBoxAdapter(
                child: SizedBox(height: context.heightPct(2)),
              ),

              // Reviews List
              filteredReviews.isNotEmpty
                  ? SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final r = filteredReviews[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
                              padding: EdgeInsets.all(context.widthPct(3.5)),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                                border: Border.all(color: AppColors.borderDark),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildUserAvatar(r.userPic, radius: 20),
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
                                                r.userName,
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
                                                (i) => Icon(
                                                  Icons.star,
                                                  size: 13,
                                                  color: i < r.rating.floor()
                                                      ? Colors.amber
                                                      : AppColors.muted,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: context.heightPct(0.4)),
                                        Text(
                                          r.comment.isNotEmpty
                                              ? r.comment
                                              : 'No detailed message provided.',
                                          style: AppTypography.bodySm.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: context.responsiveFont(13),
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: filteredReviews.length,
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(context.widthPct(8)),
                        child: Center(
                          child: Text(
                            reviews.isEmpty
                                ? 'No reviews yet for this turf.'
                                : 'No reviews match this star rating.',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(14),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int value) {
    final isActive = _selectedStar == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedStar = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.borderDark,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: isActive ? AppColors.background : AppColors.textPrimary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: context.responsiveFont(12),
          ),
        ),
      ),
    );
  }
}
