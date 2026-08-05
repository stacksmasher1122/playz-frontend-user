import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Data class representing a key performer or highlight item in match end summary.
class MatchHighlightItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const MatchHighlightItem({
    required this.icon,
    this.iconColor = AppColors.accent,
    required this.label,
    required this.value,
  });
}

/// A common, app-themed modal bottom sheet for displaying Match, Set, or Innings
/// completion summaries with auto-finalizing countdown and score undo message actions.
class CommonMatchEndSheet extends StatefulWidget {
  final String title;
  final IconData titleIcon;
  final Color titleIconColor;
  final String resultBannerText;
  final String team1Name;
  final String team1Score;
  final String team2Name;
  final String team2Score;
  final List<MatchHighlightItem> highlights;
  final int autoFinalizeSeconds;
  final String timerPrefix;
  final bool canUndo;
  final String undoButtonText;
  final String finishButtonText;
  final VoidCallback? onUndo;
  final VoidCallback? onFinish;

  const CommonMatchEndSheet({
    super.key,
    this.title = 'MATCH COMPLETED',
    this.titleIcon = Icons.emoji_events_rounded,
    this.titleIconColor = AppColors.accent,
    required this.resultBannerText,
    required this.team1Name,
    required this.team1Score,
    required this.team2Name,
    required this.team2Score,
    this.highlights = const [],
    this.autoFinalizeSeconds = 60,
    this.timerPrefix = 'Finalizing in',
    this.canUndo = true,
    this.undoButtonText = 'UNDO',
    this.finishButtonText = 'FINISH MATCH',
    this.onUndo,
    this.onFinish,
  });

  /// Helper static method to display the common match end bottom sheet cleanly.
  static Future<void> show(
    BuildContext context, {
    String title = 'MATCH COMPLETED',
    IconData titleIcon = Icons.emoji_events_rounded,
    Color titleIconColor = AppColors.accent,
    required String resultBannerText,
    required String team1Name,
    required String team1Score,
    required String team2Name,
    required String team2Score,
    List<MatchHighlightItem> highlights = const [],
    int autoFinalizeSeconds = 60,
    String timerPrefix = 'Finalizing in',
    bool canUndo = true,
    String undoButtonText = 'UNDO',
    String finishButtonText = 'FINISH MATCH',
    VoidCallback? onUndo,
    VoidCallback? onFinish,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      builder: (sheetContext) => CommonMatchEndSheet(
        title: title,
        titleIcon: titleIcon,
        titleIconColor: titleIconColor,
        resultBannerText: resultBannerText,
        team1Name: team1Name,
        team1Score: team1Score,
        team2Name: team2Name,
        team2Score: team2Score,
        highlights: highlights,
        autoFinalizeSeconds: autoFinalizeSeconds,
        timerPrefix: timerPrefix,
        canUndo: canUndo,
        undoButtonText: undoButtonText,
        finishButtonText: finishButtonText,
        onUndo: () {
          Navigator.pop(sheetContext);
          onUndo?.call();
        },
        onFinish: () {
          Navigator.pop(sheetContext);
          onFinish?.call();
        },
      ),
    );
  }

  /// Helper static method for Innings Break / Set Break / Mid-Match breaks.
  static Future<void> showInningsBreak(
    BuildContext context, {
    String title = 'INNINGS BREAK',
    IconData titleIcon = Icons.pause_circle_outline_rounded,
    Color titleIconColor = AppColors.accent,
    required String targetText,
    required String team1Name,
    required String team1Score,
    required String team2Name,
    required String team2Score,
    List<MatchHighlightItem> highlights = const [],
    int autoFinalizeSeconds = 60,
    String timerPrefix = '2nd Innings starts in',
    bool canUndo = true,
    String undoButtonText = 'UNDO LAST BALL',
    String finishButtonText = 'START 2ND INNINGS',
    VoidCallback? onUndo,
    VoidCallback? onFinish,
  }) {
    return show(
      context,
      title: title,
      titleIcon: titleIcon,
      titleIconColor: titleIconColor,
      resultBannerText: targetText,
      team1Name: team1Name,
      team1Score: team1Score,
      team2Name: team2Name,
      team2Score: team2Score,
      highlights: highlights,
      autoFinalizeSeconds: autoFinalizeSeconds,
      timerPrefix: timerPrefix,
      canUndo: canUndo,
      undoButtonText: undoButtonText,
      finishButtonText: finishButtonText,
      onUndo: onUndo,
      onFinish: onFinish,
    );
  }

  @override
  State<CommonMatchEndSheet> createState() => _CommonMatchEndSheetState();
}

class _CommonMatchEndSheetState extends State<CommonMatchEndSheet> {
  late int timeLeft;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.autoFinalizeSeconds;
    if (timeLeft > 0) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeLeft > 0) {
          if (mounted) {
            setState(() {
              timeLeft--;
            });
          }
        } else {
          timer.cancel();
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
            widget.onFinish?.call();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final String formattedTime =
        '00:${timeLeft.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(16.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Drag Handle Pill
            Center(
              child: Container(
                width: ResponsiveHelper.w(44.0),
                height: ResponsiveHelper.h(4.5),
                margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16.0)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
              ),
            ),

            // Title Badge & Icon
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
              decoration: BoxDecoration(
                color: widget.titleIconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.titleIcon,
                color: widget.titleIconColor,
                size: ResponsiveHelper.w(32.0),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(10.0)),
            Text(
              widget.title,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveHelper.sp(18.0),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ).responsive(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.h(16.0)),

            // Result Banner
            if (widget.resultBannerText.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(16.0),
                  vertical: ResponsiveHelper.h(14.0),
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: Text(
                  widget.resultBannerText,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(16.0),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(16.0)),
            ],

            // Team Scores Breakdown Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
              decoration: BoxDecoration(
                color: const Color(0xFF131313),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.team1Name,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      Text(
                        widget.team1Score,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ).responsive(context),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.team2Name,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      Text(
                        widget.team2Score,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Performers & Highlights List (if provided)
            if (widget.highlights.isNotEmpty) ...[
              SizedBox(height: ResponsiveHelper.h(14.0)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
                decoration: BoxDecoration(
                  color: const Color(0xFF181818),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.highlights.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < widget.highlights.length - 1
                            ? ResponsiveHelper.h(6.0)
                            : 0,
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, color: item.iconColor, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${item.label}: ${item.value}',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(13.0),
                              ).responsive(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            SizedBox(height: ResponsiveHelper.h(16.0)),

            // Timer Badge
            if (widget.autoFinalizeSeconds > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(14.0),
                  vertical: ResponsiveHelper.h(6.0),
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.mutedText, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.timerPrefix} $formattedTime',
                      style: AppTypography.bodySm.copyWith(
                        color: Colors.white70,
                        fontSize: ResponsiveHelper.sp(13.0),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),

            SizedBox(height: ResponsiveHelper.h(20.0)),

            // Action Buttons Row
            Row(
              children: [
                if (widget.canUndo) ...[
                  Expanded(
                    child: SizedBox(
                      height: ResponsiveHelper.h(48.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error.withValues(alpha: 0.15),
                          foregroundColor: AppColors.error,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(8.0),
                          ),
                          side: const BorderSide(color: AppColors.error, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                          ),
                        ),
                        onPressed: widget.onUndo,
                        icon: Icon(
                          Icons.undo_rounded,
                          size: ResponsiveHelper.w(18.0),
                          color: AppColors.error,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.undoButtonText,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.error,
                              fontSize: ResponsiveHelper.sp(13.0),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ).responsive(context),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12.0)),
                ],
                Expanded(
                  child: SizedBox(
                    height: ResponsiveHelper.h(48.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(8.0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                        ),
                      ),
                      onPressed: widget.onFinish,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.finishButtonText,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.background,
                            fontSize: ResponsiveHelper.sp(14.0),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ).responsive(context),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(10.0)),
          ],
        ),
      ),
    );
  }
}
