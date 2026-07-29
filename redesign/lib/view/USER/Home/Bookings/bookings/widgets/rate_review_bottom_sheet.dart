import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   RATE & REVIEW BOTTOM SHEET
   ============================================================ */
class RateReviewBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const RateReviewBottomSheet({super.key, this.bookingData});

  @override
  State<RateReviewBottomSheet> createState() => _RateReviewBottomSheetState();
}

class _RateReviewBottomSheetState extends State<RateReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  bool _isSubmitting = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final existingRating = widget.bookingData?['userRating'] ??
        widget.bookingData?['rating'];
    if (existingRating is num) {
      _rating = existingRating.toDouble().roundToDouble();
      _isEditing = true;
    }
    final existingText = widget.bookingData?['userReviewText'] ??
        widget.bookingData?['reviewText'];
    if (existingText is String) {
      _reviewController.text = existingText;
    }
    _fetchExistingReview();
  }

  Future<void> _fetchExistingReview() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefDocId = await UserPreferences.getDocId();
      final userId = prefDocId ?? user?.email ?? user?.uid ?? '';
      final bookingId = (widget.bookingData?['bookingId'] ??
              widget.bookingData?['id'] ??
              '')
          .toString();

      if (userId.isNotEmpty && bookingId.isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .collection('bookings')
            .doc(bookingId)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final rating = data['userRating'] ?? data['rating'];
          final text = data['userReviewText'] ?? data['reviewText'];

          if (mounted) {
            setState(() {
              if (rating is num) {
                _rating = rating.toDouble().roundToDouble();
                _isEditing = true;
              }
              if (text is String && text.isNotEmpty) {
                _reviewController.text = text;
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching existing review: $e');
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String _getRatingText(double rating) {
    if (rating <= 0.0) return 'Tap or slide stars to rate';
    final int intRating = rating.round().clamp(1, 5);
    switch (intRating) {
      case 1:
        return '1 / 5 • Poor 😞';
      case 2:
        return '2 / 5 • Average 😐';
      case 3:
        return '3 / 5 • Good 😀';
      case 4:
        return '4 / 5 • Great Experience! ✨';
      case 5:
        return '5 / 5 • Outstanding! 🏆';
      default:
        return 'Tap or slide stars to rate';
    }
  }

  Future<void> _submitReview() async {
    if (_rating <= 0.0) {
      Get.snackbar(
        'Rating Required',
        'Please tap or slide the stars to choose a rating.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefDocId = await UserPreferences.getDocId();
      final userId = prefDocId ?? user?.email ?? user?.uid ?? '';
      final userName = await UserPreferences.getUserName() ??
          user?.displayName ??
          'PlayZ Player';
      final userPic = await UserPreferences.getProfileImageUrl() ??
          user?.photoURL ??
          '';

      final bookingId = (widget.bookingData?['bookingId'] ??
              widget.bookingData?['id'] ??
              '')
          .toString();
      final turfId = (widget.bookingData?['turfId'] ??
              widget.bookingData?['venueId'] ??
              '')
          .toString();
      final ownerId = (widget.bookingData?['ownerId'] ??
              widget.bookingData?['turfOwnerId'] ??
              '')
          .toString();
      final turfName = (widget.bookingData?['turfName'] ??
              widget.bookingData?['venueName'] ??
              'PlayZ Arena')
          .toString();
      final reviewText = _reviewController.text.trim();

      // 1. Check for existing review doc to avoid creating duplicates when editing
      DocumentReference reviewRef;
      if (bookingId.isNotEmpty && userId.isNotEmpty) {
        final existingQuery = await FirebaseFirestore.instance
            .collection('Turf_Reviews')
            .where('bookingId', isEqualTo: bookingId)
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

        if (existingQuery.docs.isNotEmpty) {
          reviewRef = existingQuery.docs.first.reference;
        } else {
          reviewRef = FirebaseFirestore.instance.collection('Turf_Reviews').doc();
        }
      } else {
        reviewRef = FirebaseFirestore.instance.collection('Turf_Reviews').doc();
      }

      final reviewData = {
        'reviewId': reviewRef.id,
        'bookingId': bookingId,
        'turfId': turfId,
        'ownerId': ownerId,
        'turfName': turfName,
        'userId': userId,
        'userName': userName,
        'userProfilePic': userPic,
        'rating': _rating,
        'reviewText': reviewText,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await reviewRef.set(reviewData, SetOptions(merge: true));

      // 2. Update Booking Document in User's bookings collection
      if (userId.isNotEmpty && bookingId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .collection('bookings')
            .doc(bookingId)
            .set({
          'isReviewed': true,
          'userRating': _rating,
          'userReviewText': reviewText,
          'reviewId': reviewRef.id,
          'reviewedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // 3. Write to Turf Owner's subcollection if ownerId & turfId exist
      if (ownerId.isNotEmpty && turfId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('owners')
            .doc(ownerId)
            .collection('turfs')
            .doc(turfId)
            .collection('reviews')
            .doc(reviewRef.id)
            .set(reviewData, SetOptions(merge: true));

        // 4. Update average rating on owner's turf doc
        final reviewsSnap = await FirebaseFirestore.instance
            .collection('owners')
            .doc(ownerId)
            .collection('turfs')
            .doc(turfId)
            .collection('reviews')
            .get();

        if (reviewsSnap.docs.isNotEmpty) {
          final totalRating = reviewsSnap.docs.fold<double>(
              0.0,
              (acc, doc) =>
                  acc +
                  ((doc.data()['rating'] as num?)?.toDouble() ?? 0.0));
          final count = reviewsSnap.docs.length;
          final avg = double.parse((totalRating / count).toStringAsFixed(1));

          await FirebaseFirestore.instance
              .collection('owners')
              .doc(ownerId)
              .collection('turfs')
              .doc(turfId)
              .update({
            'rating': avg,
            'totalReviews': count,
          });
        }
      }

      if (mounted) {
        Navigator.pop(context);
        Get.snackbar(
          _isEditing ? 'Review Updated! 🌟' : 'Review Submitted! 🌟',
          _isEditing
              ? 'Your review for $turfName has been updated.'
              : 'Thank you for reviewing $turfName.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.surface,
          colorText: AppColors.textPrimary,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('🔴 Error submitting review: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to submit review: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.card,
          colorText: AppColors.textPrimary,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final turfName = widget.bookingData?['turfName'] ??
        widget.bookingData?['venueName'] ??
        'the Venue';

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(5),
        context.heightPct(2),
        context.widthPct(5),
        MediaQuery.of(context).viewInsets.bottom + context.heightPct(3),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.minDimensionPct(6)),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: context.heightPct(2)),

              /// TITLE
              Text(
                'Rate & Review',
                style: AppTypography.headlineLgMobile.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.heightPct(0.5)),
              Text(
                'How was your experience at $turfName?',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: context.responsiveFont(13),
                ),
              ),
              SizedBox(height: context.heightPct(2.5)),

              /// GLOWING INTERACTIVE 0.5 STAR RATING BAR
              InteractiveStarRating(
                initialRating: _rating,
                starSize: context.minDimensionPct(10).clamp(32.0, 44.0),
                onRatingChanged: (val) {
                  setState(() {
                    _rating = val;
                  });
                },
              ),

              SizedBox(height: context.heightPct(1.5)),

              /// RATING LABEL
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _getRatingText(_rating),
                  key: ValueKey(_rating),
                  style: AppTypography.headlineSm.copyWith(
                    color: _rating > 0 ? const Color(0xFFFFD700) : AppColors.muted,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: context.heightPct(2.5)),

              /// REVIEW TEXT INPUT
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(3.5),
                  vertical: context.heightPct(1),
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLength: 250,
                  maxLines: 4,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(13),
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Write a review... (e.g. Excellent turf quality, great lighting and facilities)',
                    hintStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(12),
                    ),
                    border: InputBorder.none,
                    counterStyle: AppTypography.bodyXs.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.heightPct(2.5)),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: context.heightPct(6).clamp(44.0, 52.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.minDimensionPct(3.5)),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitReview,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColors.background,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _isEditing ? 'Update Review' : 'Submit Review',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(15),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   INTERACTIVE STAR RATING WIDGET (WHOLE NUMBERS + SOFT GLOW)
   ============================================================ */
class InteractiveStarRating extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final double starSize;

  const InteractiveStarRating({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingChanged,
    this.starSize = 38.0,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating.roundToDouble();
  }

  @override
  void didUpdateWidget(covariant InteractiveStarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _currentRating = widget.initialRating.roundToDouble();
    }
  }

  void _updateRatingFromOffset(Offset localOffset, double totalWidth) {
    if (totalWidth <= 0) return;
    final double raw = (localOffset.dx / totalWidth) * 5.0;
    // Snap strictly to whole numbers (1 to 5)
    final double snapped = raw.ceil().clamp(1, 5).toDouble();

    if (snapped != _currentRating) {
      setState(() {
        _currentRating = snapped;
      });
      widget.onRatingChanged(snapped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _updateRatingFromOffset(details.localPosition, totalWidth),
          onPanStart: (details) =>
              _updateRatingFromOffset(details.localPosition, totalWidth),
          onPanUpdate: (details) =>
              _updateRatingFromOffset(details.localPosition, totalWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final starValue = index + 1.0;
              final isFull = _currentRating >= starValue;

              return Icon(
                isFull ? Icons.star_rounded : Icons.star_border_rounded,
                size: widget.starSize,
                color: isFull ? const Color(0xFFFFD700) : AppColors.borderDark,
                shadows: isFull
                    ? const [
                        Shadow(
                          color: Color(0x80FFD700),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              );
            }),
          ),
        );
      },
    );
  }
}
