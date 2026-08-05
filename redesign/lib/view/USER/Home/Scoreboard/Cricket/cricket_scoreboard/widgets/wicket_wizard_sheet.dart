import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A modern, step-by-step Wicket Wizard Bottom Sheet for recording cricket dismissals.
/// Excludes retirement options (retiredHurt, retiredOut) as retirement is handled separately.
class WicketWizardSheet extends StatefulWidget {
  final List<Player> battingTeam;
  final List<Player> bowlingTeam;
  final Player? striker;
  final Player? nonStriker;
  final bool isFreeHit;
  final Function(
    DismissalType type,
    String? fielder,
    Player? newBatter,
    bool newBatterOnStrike,
    String outPlayer,
    bool crossed,
  ) onComplete;

  const WicketWizardSheet({
    super.key,
    required this.battingTeam,
    required this.bowlingTeam,
    required this.striker,
    required this.nonStriker,
    this.isFreeHit = false,
    required this.onComplete,
  });

  @override
  State<WicketWizardSheet> createState() => _WicketWizardSheetState();
}

class _WicketWizardSheetState extends State<WicketWizardSheet> {
  int step = 0;
  DismissalType? dismissalType;
  String? fielder;
  Player? newBatter;
  bool newBatterOnStrike = true;
  String outPlayer = 'striker';
  bool crossed = false;

  @override
  void initState() {
    super.initState();
    _autoSetRemainingBatter();
  }

  void _autoSetRemainingBatter() {
    if (availableBatters.length == 1) {
      newBatter = availableBatters.first;
    } else if (availableBatters.isEmpty) {
      final remaining = widget.battingTeam.where((p) => !p.isOut).toList();
      if (remaining.length == 1) {
        newBatter = remaining.first;
      }
    }
  }

  List<Player> get availableBatters => widget.battingTeam
      .where(
        (p) =>
            !p.isOut &&
            p.name != widget.striker?.name &&
            p.name != widget.nonStriker?.name,
      )
      .toList();

  /// Returns valid dismissal types. Retiring (retiredHurt, retiredOut) is filtered out.
  List<DismissalType> get availableDismissals {
    if (widget.isFreeHit) {
      return [
        DismissalType.runOut,
        DismissalType.obstructingField,
        DismissalType.hitBallTwice,
        DismissalType.handledBall,
      ];
    }
    return DismissalType.values
        .where((t) => t != DismissalType.retiredHurt && t != DismissalType.retiredOut)
        .toList();
  }

  String _formatDismissalName(DismissalType type) {
    switch (type) {
      case DismissalType.bowled:
        return 'BOWLED';
      case DismissalType.caught:
        return 'CAUGHT';
      case DismissalType.lbw:
        return 'LBW';
      case DismissalType.runOut:
        return 'RUN OUT';
      case DismissalType.stumped:
        return 'STUMPED';
      case DismissalType.hitWicket:
        return 'HIT WICKET';
      case DismissalType.obstructingField:
        return 'OBSTRUCTING FIELD';
      case DismissalType.hitBallTwice:
        return 'HIT BALL TWICE';
      case DismissalType.handledBall:
        return 'HANDLED BALL';
      case DismissalType.timedOut:
        return 'TIMED OUT';
      default:
        return type.name.toUpperCase();
    }
  }

  IconData _getDismissalIcon(DismissalType type) {
    switch (type) {
      case DismissalType.bowled:
        return Icons.sports_cricket_rounded;
      case DismissalType.caught:
        return Icons.pan_tool_rounded;
      case DismissalType.lbw:
        return Icons.accessibility_new_rounded;
      case DismissalType.runOut:
        return Icons.directions_run_rounded;
      case DismissalType.stumped:
        return Icons.flash_on_rounded;
      case DismissalType.hitWicket:
        return Icons.center_focus_strong_rounded;
      default:
        return Icons.do_not_disturb_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveHelper.w(20.0),
        right: ResponsiveHelper.w(20.0),
        top: ResponsiveHelper.h(16.0),
        bottom: MediaQuery.of(context).viewInsets.bottom + ResponsiveHelper.h(20.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // Header with Back Button & Step Badge
            Row(
              children: [
                if (step > 0)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        step--;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: ResponsiveHelper.w(18.0),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (step > 0) SizedBox(width: ResponsiveHelper.w(10.0)),
                Text(
                  'WICKET WIZARD',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.error,
                    fontSize: ResponsiveHelper.sp(18.0),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ).responsive(context),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16.0)),

            // Active Step Content
            if (step == 0) _dismissalStep(),
            if (step == 1) _fielderStep(),
            if (step == 2) _newBatterStep(),
            if (step == 3) _confirmStep(),
          ],
        ),
      ),
    );
  }

  Widget _dismissalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isFreeHit
              ? '⚡ FREE HIT ACTIVE — Non-bowler dismissals only:'
              : 'Select Dismissal Method:',
          style: AppTypography.bodySm.copyWith(
            color: widget.isFreeHit ? const Color(0xFFF7E7A1) : AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(13.0),
            fontWeight: widget.isFreeHit ? FontWeight.bold : FontWeight.normal,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(14.0)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: ResponsiveHelper.w(10.0),
            mainAxisSpacing: ResponsiveHelper.h(10.0),
          ),
          itemCount: availableDismissals.length,
          itemBuilder: (context, index) {
            final t = availableDismissals[index];
            final sel = dismissalType == t;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() {
                  dismissalType = t;
                  _autoSetRemainingBatter();
                  final needsFielder = t == DismissalType.caught ||
                      t == DismissalType.runOut ||
                      t == DismissalType.stumped;
                  if (needsFielder) {
                    step = 1;
                  } else if (availableBatters.length > 1) {
                    step = 2;
                  } else {
                    step = 3;
                  }
                }),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12.0)),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.error.withValues(alpha: 0.2)
                        : const Color(0xFF131313),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                    border: Border.all(
                      color: sel ? AppColors.error : Colors.white.withValues(alpha: 0.08),
                      width: sel ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getDismissalIcon(t),
                        color: sel ? AppColors.error : AppColors.mutedText,
                        size: ResponsiveHelper.w(18.0),
                      ),
                      SizedBox(width: ResponsiveHelper.w(8.0)),
                      Expanded(
                        child: Text(
                          _formatDismissalName(t),
                          style: AppTypography.bodySm.copyWith(
                            color: sel ? AppColors.error : AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: sel ? FontWeight.bold : FontWeight.w600,
                          ).responsive(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _fielderStep() {
    final needsFielder = dismissalType == DismissalType.caught ||
        dismissalType == DismissalType.runOut ||
        dismissalType == DismissalType.stumped;

    if (!needsFielder) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && step == 1) {
          _autoSetRemainingBatter();
          if (availableBatters.length > 1) {
            setState(() => step = 2);
          } else {
            setState(() => step = 3);
          }
        }
      });
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Fielder:',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(13.0),
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(12.0)),
        Wrap(
          spacing: ResponsiveHelper.w(10.0),
          runSpacing: ResponsiveHelper.h(10.0),
          children: widget.bowlingTeam.map((p) {
            final sel = fielder == p.name;
            return ChoiceChip(
              label: Text(
                p.name,
                style: AppTypography.bodySm.copyWith(
                  color: sel ? AppColors.background : AppColors.textPrimary,
                  fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                ).responsive(context),
              ),
              selected: sel,
              selectedColor: AppColors.accent,
              backgroundColor: const Color(0xFF131313),
              side: BorderSide(
                color: sel ? AppColors.accent : Colors.white.withValues(alpha: 0.1),
              ),
              onSelected: (val) {
                setState(() {
                  fielder = p.name;
                  _autoSetRemainingBatter();
                  if (availableBatters.length > 1) {
                    step = 2;
                  } else {
                    step = 3;
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _newBatterStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Next Batter:',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(13.0),
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(12.0)),
        if (availableBatters.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16.0)),
            child: Text(
              'No remaining batters available in team roster.',
              style: AppTypography.bodySm.copyWith(color: AppColors.mutedText).responsive(context),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableBatters.length,
            separatorBuilder: (c, i) => SizedBox(height: ResponsiveHelper.h(8.0)),
            itemBuilder: (context, index) {
              final p = availableBatters[index];
              final isSel = newBatter?.name == p.name;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() {
                    newBatter = p;
                    step = 3;
                  }),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(16.0),
                      vertical: ResponsiveHelper.h(12.0),
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : const Color(0xFF131313),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                      border: Border.all(
                        color: isSel ? AppColors.accent : Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: ResponsiveHelper.w(16.0),
                          backgroundColor: isSel ? AppColors.accent : const Color(0xFF2A2A2A),
                          child: Text(
                            p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: isSel ? AppColors.background : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.w(12.0)),
                        Expanded(
                          child: Text(
                            p.name,
                            style: AppTypography.bodyMd.copyWith(
                              color: isSel ? AppColors.accent : AppColors.textPrimary,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            ).responsive(context),
                          ),
                        ),
                        if (isSel)
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.accent,
                            size: ResponsiveHelper.w(20.0),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _confirmStep() {
    final outBatterName = outPlayer == 'striker'
        ? (widget.striker?.name ?? 'Striker')
        : (widget.nonStriker?.name ?? 'Non-Striker');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Box
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF131313),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DISMISSAL SUMMARY',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.error,
                  fontSize: ResponsiveHelper.sp(11.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    outBatterName,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(18.0),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                  Text(
                    _formatDismissalName(dismissalType ?? DismissalType.bowled),
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.error,
                      fontSize: ResponsiveHelper.sp(14.0),
                      fontWeight: FontWeight.w800,
                    ).responsive(context),
                  ),
                ],
              ),
              if (fielder != null) ...[
                SizedBox(height: ResponsiveHelper.h(4.0)),
                Text(
                  'Fielder: $fielder',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(13.0),
                  ).responsive(context),
                ),
              ],
              if (newBatter != null) ...[
                SizedBox(height: ResponsiveHelper.h(4.0)),
                Text(
                  'New Batter: ${newBatter!.name}',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(13.0),
                    fontWeight: FontWeight.w600,
                  ).responsive(context),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),

        // Run Out Specific Controls
        if (dismissalType == DismissalType.runOut) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Who is out?',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                ).responsive(context),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Striker'),
                    selected: outPlayer == 'striker',
                    selectedColor: AppColors.error,
                    backgroundColor: const Color(0xFF131313),
                    onSelected: (val) => setState(() => outPlayer = 'striker'),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8.0)),
                  ChoiceChip(
                    label: const Text('Non-Striker'),
                    selected: outPlayer == 'nonStriker',
                    selectedColor: AppColors.error,
                    backgroundColor: const Color(0xFF131313),
                    onSelected: (val) => setState(() => outPlayer = 'nonStriker'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Did batters cross?',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                ).responsive(context),
              ),
              Switch(
                value: crossed,
                onChanged: (v) => setState(() => crossed = v),
                activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8.0)),
        ],

        if (newBatter != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New batter on strike?',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ).responsive(context),
              ),
              Switch(
                value: newBatterOnStrike,
                onChanged: (v) => setState(() => newBatterOnStrike = v),
                activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),

        SizedBox(height: ResponsiveHelper.h(20.0)),

        // Confirm Wicket Button
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.h(54.0),
          child: ElevatedButton(
            onPressed: () => widget.onComplete(
              dismissalType!,
              fielder,
              newBatter,
              newBatterOnStrike,
              outPlayer,
              crossed,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
              ),
            ),
            child: Text(
              'CONFIRM WICKET',
              style: AppTypography.headlineSm.copyWith(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16.0),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ).responsive(context),
            ),
          ),
        ),
      ],
    );
  }
}
