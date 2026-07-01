import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class WicketWizardSheet extends StatefulWidget {
  final List<Player> battingTeam;
  final List<Player> bowlingTeam;
  final Player? striker;
  final Player? nonStriker;
  final Function(DismissalType, String?, Player?, bool, String?, bool)
  onComplete;

  WicketWizardSheet({
    super.key,
    required this.battingTeam,
    required this.bowlingTeam,
    required this.striker,
    required this.nonStriker,
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

  List<Player> get availableBatters => widget.battingTeam
      .where(
        (p) =>
            !p.isOut &&
            p.name != widget.striker?.name &&
            p.name != widget.nonStriker?.name,
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(
        left: ResponsiveHelper.w(20),
        right: ResponsiveHelper.w(20),
        top: ResponsiveHelper.h(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Wicket Wizard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text('Step ${step + 1}/4', style: TextStyle(color: AppColors.muted)),
            ],
          ),
          SizedBox(height: 20),
          if (step == 0) _dismissalStep(),
          if (step == 1) _fielderStep(),
          if (step == 2) _newBatterStep(),
          if (step == 3) _confirmStep(),
        ],
      ),
    );
  }

  Widget _dismissalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How was the batter dismissed?',
          style: TextStyle(color: AppColors.muted),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DismissalType.values.map((t) {
            final sel = dismissalType == t;
            return GestureDetector(
              onTap: () => setState(() {
                dismissalType = t;
                if (availableBatters.isEmpty) {
                  step = 3; // Jump directly to confirm if no batters left
                } else {
                  step = 1;
                }
              }),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: sel ? AppColors.error.withValues(alpha: 0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: sel ? Border.all(color: AppColors.error) : null,
                ),
                child: Text(
                  t.name.toUpperCase(),
                  style: TextStyle(color: sel ? AppColors.error : Colors.white),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _fielderStep() {
    final needsFielder =
        dismissalType == DismissalType.caught ||
        dismissalType == DismissalType.runOut ||
        dismissalType == DismissalType.stumped;
    if (!needsFielder) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && step == 1) {
          if (availableBatters.isEmpty) {
            setState(() => step = 3);
          } else {
            setState(() => step = 2);
          }
        }
      });
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select fielder', style: TextStyle(color: AppColors.muted)),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.bowlingTeam.map((p) {
            final sel = fielder == p.name;
            return GestureDetector(
              onTap: () => setState(() {
                fielder = p.name;
                if (availableBatters.isEmpty) {
                  step = 3;
                } else {
                  step = 2;
                }
              }),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: sel ? Colors.blue.withValues(alpha: 0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                ),
                child: Text(
                  p.name,
                  style: TextStyle(
                    color: sel ? Colors.blue : Colors.white,
                    fontSize: ResponsiveHelper.sp(13),
                  ),
                ),
              ),
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
        Text('Select new batter', style: TextStyle(color: AppColors.muted)),
        SizedBox(height: 12),
        ...availableBatters.map(
          (p) => ListTile(
            title: Text(p.name, style: TextStyle(color: Colors.white)),
            trailing: newBatter?.name == p.name
                ? Icon(Icons.check_circle, color: AppColors.accent)
                : null,
            onTap: () => setState(() {
              newBatter = p;
              step = 3;
            }),
          ),
        ),
      ],
    );
  }

  Widget _confirmStep() {
    // Resolve the actual batter name based on outPlayer selection
    final outBatterName = outPlayer == 'striker'
        ? (widget.striker?.name ?? 'Striker')
        : (widget.nonStriker?.name ?? 'Non-Striker');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$outBatterName — ${dismissalType?.name.toUpperCase()}',
          style: TextStyle(
            color: AppColors.error,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (fielder != null)
          Text('Fielder: $fielder', style: TextStyle(color: AppColors.muted)),
        if (newBatter != null)
          Text(
            'New Batter: ${newBatter!.name}',
            style: TextStyle(color: AppColors.muted),
          ),
        SizedBox(height: 16),
        if (dismissalType == DismissalType.runOut) ...[
          SizedBox(height: 16),
          Row(
            children: [
              Text('Who is out?', style: TextStyle(color: AppColors.muted)),
              Spacer(),
              ChoiceChip(
                label: Text('Striker'),
                selected: outPlayer == 'striker',
                onSelected: (val) => setState(() => outPlayer = 'striker'),
              ),
              SizedBox(width: 8),
              ChoiceChip(
                label: Text('Non-Striker'),
                selected: outPlayer == 'nonStriker',
                onSelected: (val) => setState(() => outPlayer = 'nonStriker'),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('Did batters cross?', style: TextStyle(color: AppColors.muted)),
              Spacer(),
              Switch(
                value: crossed,
                onChanged: (v) => setState(() => crossed = v),
                activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
        ],
        SizedBox(height: 16),
        if (newBatter != null)
          Row(
            children: [
              Text(
                'New batter on strike?',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Switch(
                value: newBatterOnStrike,
                onChanged: (v) => setState(() => newBatterOnStrike = v),
                activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
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
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
            ),
            child: Text(
              'CONFIRM WICKET',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
