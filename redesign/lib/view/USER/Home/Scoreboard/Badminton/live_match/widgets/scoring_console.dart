import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';

class ScoringConsole extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onPointSideA;
  final VoidCallback onPointSideB;
  final BadmintonController? controller;

  const ScoringConsole({
    super.key,
    required this.onUndo,
    required this.onPointSideA,
    required this.onPointSideB,
    this.controller,
  });

  String _truncateName(String name, String fallback) {
    final clean = name.trim().isEmpty ? fallback : name.trim();
    if (clean.length > 6) {
      return '${clean.substring(0, 6)}..';
    }
    return clean;
  }

  String _getInitials(String name, String fallback) {
    final cleanName = name.trim().isEmpty ? fallback : name.trim();
    final parts = cleanName.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 3) {
      return (parts[0][0] + parts[1][0] + parts[2][0]).toUpperCase();
    } else if (parts.length == 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (cleanName.length >= 3) {
      return cleanName.substring(0, 3).toUpperCase();
    }
    return cleanName.toUpperCase();
  }

  void _showConductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(20.0),
          vertical: ResponsiveHelper.h(16.0),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.w(28.0)),
          ),
          border: Border.all(color: Colors.white12, width: 1),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: ResponsiveHelper.w(40.0),
                  height: ResponsiveHelper.h(4.0),
                  margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16.0)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                  ),
                ),
              ),

              // Title Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conduct Penalty',
                        style: AppTypography.headlineLg.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(20.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4.0)),
                      Text(
                        'Select BWF penalty level to issue',
                        style: AppTypography.bodySm.copyWith(
                          color: const Color(0xFF8E8E93),
                          fontSize: ResponsiveHelper.sp(13.0),
                        ).responsive(context),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(sheetContext),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    child: Container(
                      width: ResponsiveHelper.w(32.0),
                      height: ResponsiveHelper.w(32.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1C222B),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        color: const Color(0xFF22C55E),
                        size: ResponsiveHelper.w(18.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(20.0)),

              // 1. WARNING CARD
              _buildPenaltyCard(
                context,
                title: 'Official Warning',
                subtitle: 'Log a formal BWF warning (no score change)',
                badge: 'LEVEL 1',
                icon: Icons.warning_amber_rounded,
                accentColor: const Color(0xFFF59E0B),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showSideSelectionSheet(context, 'Warning', 'warning');
                },
              ),
              SizedBox(height: ResponsiveHelper.h(12.0)),

              // 2. POINT FAULT CARD
              _buildPenaltyCard(
                context,
                title: 'Point Fault',
                subtitle: 'Award 1 point penalty to opponent side',
                badge: 'LEVEL 2',
                icon: Icons.gavel_rounded,
                accentColor: const Color(0xFFEF4444),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showSideSelectionSheet(context, 'Point Fault', 'fault');
                },
              ),
              SizedBox(height: ResponsiveHelper.h(12.0)),

              // 3. DISQUALIFY CARD
              _buildPenaltyCard(
                context,
                title: 'Disqualify Match',
                subtitle: 'End match immediately due to severe misconduct',
                badge: 'LEVEL 3',
                icon: Icons.cancel_rounded,
                accentColor: const Color(0xFFDC2626),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showSideSelectionSheet(context, 'Disqualification', 'disqualify');
                },
              ),
              SizedBox(height: ResponsiveHelper.h(12.0)),
            ],
          ),
        ),
      ),
    );
  }

  void _showSideSelectionSheet(BuildContext context, String label, String type) {
    final String homeName = controller != null && controller!.homeTeamName.value.isNotEmpty
        ? controller!.homeTeamName.value
        : 'SIDE A';
    final String awayName = controller != null && controller!.awayTeamName.value.isNotEmpty
        ? controller!.awayTeamName.value
        : 'SIDE B';

    final String initialsA = _getInitials(homeName, 'AAA');
    final String initialsB = _getInitials(awayName, 'BBB');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(20.0),
          vertical: ResponsiveHelper.h(16.0),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.w(28.0)),
          ),
          border: Border.all(color: Colors.white12, width: 1),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: ResponsiveHelper.w(40.0),
                  height: ResponsiveHelper.h(4.0),
                  margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16.0)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                  ),
                ),
              ),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Recipient',
                        style: AppTypography.headlineLg.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(20.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4.0)),
                      Text(
                        'Applying: $label',
                        style: AppTypography.bodySm.copyWith(
                          color: const Color(0xFF8E8E93),
                          fontSize: ResponsiveHelper.sp(13.0),
                        ).responsive(context),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(sheetContext),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                    child: Container(
                      width: ResponsiveHelper.w(32.0),
                      height: ResponsiveHelper.w(32.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1C222B),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        color: const Color(0xFF22C55E),
                        size: ResponsiveHelper.w(18.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // 2 Team Cards Side-by-Side
              Row(
                children: [
                  // Side A Card
                  Expanded(
                    child: _buildTeamPenaltyTargetCard(
                      context,
                      initials: initialsA,
                      teamName: homeName.toUpperCase(),
                      borderColor: const Color(0xFFEF4444),
                      backgroundColor: const Color(0xFF2A1215),
                      buttonColor: const Color(0xFFEF4444),
                      buttonText: 'PENALIZE SIDE A',
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        controller?.addConduct(PlayerSide.sideA, type);
                      },
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(14.0)),

                  // Side B Card
                  Expanded(
                    child: _buildTeamPenaltyTargetCard(
                      context,
                      initials: initialsB,
                      teamName: awayName.toUpperCase(),
                      borderColor: const Color(0xFF22C55E),
                      backgroundColor: const Color(0xFF0F2A1C),
                      buttonColor: const Color(0xFF22C55E),
                      buttonText: 'PENALIZE SIDE B',
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        controller?.addConduct(PlayerSide.sideB, type);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(16.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPenaltyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
          border: Border.all(color: accentColor.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.w(44.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: ResponsiveHelper.w(22.0),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(14.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(15.0),
                          fontWeight: FontWeight.w800,
                        ).responsive(context),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(6.0),
                          vertical: ResponsiveHelper.h(2.0),
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(4.0)),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: ResponsiveHelper.sp(10.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(4.0)),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      color: const Color(0xFF8E8E93),
                      fontSize: ResponsiveHelper.sp(12.5),
                    ).responsive(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamPenaltyTargetCard(
    BuildContext context, {
    required String initials,
    required String teamName,
    required Color borderColor,
    required Color backgroundColor,
    required Color buttonColor,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.w(52.0),
            height: ResponsiveHelper.w(52.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0D1117),
              border: Border.all(color: borderColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.4),
                  blurRadius: 10,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: AppTypography.headlineSm.copyWith(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(15.0),
                fontWeight: FontWeight.w900,
              ).responsive(context),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(10.0)),
          Text(
            teamName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelCaps.copyWith(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(13.0),
              fontWeight: FontWeight.w800,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(14.0)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                ),
              ),
              onPressed: onPressed,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(11.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final String homeName = controller != null
        ? _truncateName(controller!.homeTeamName.value, 'SIDE A')
        : 'SIDE A';
    final String awayName = controller != null
        ? _truncateName(controller!.awayTeamName.value, 'SIDE B')
        : 'SIDE B';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(16.0),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(28.0)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: +1 Side A & +1 Side B Point Assignment Buttons
            Row(
              children: [
                Expanded(
                  child: _buildPointButton(
                    context,
                    label: '+1',
                    subtitle: homeName.toUpperCase(),
                    backgroundColor: const Color(0xFF2A1215),
                    borderColor: const Color(0xFFDC2626),
                    textColor: Colors.white,
                    subtitleColor: const Color(0xFFFCA5A5),
                    onPressed: onPointSideA,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),
                Expanded(
                  child: _buildPointButton(
                    context,
                    label: '+1',
                    subtitle: awayName.toUpperCase(),
                    backgroundColor: const Color(0xFF0F2A1C),
                    borderColor: const Color(0xFF16A34A),
                    textColor: Colors.white,
                    subtitleColor: const Color(0xFF86EFAC),
                    onPressed: onPointSideB,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(14.0)),

            // Row 2: Action Control Buttons Grid (LET, SERVICE FAULT, CONDUCT FAULT, TIMEOUT)
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.sports_tennis_rounded,
                    label: 'LET',
                    hasRedUnderline: true,
                    onPressed: () {
                      controller?.addPointWithType(PlayerSide.sideA, 'let');
                    },
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.block_rounded,
                    label: 'SERVICE\nFAULT',
                    onPressed: () {
                      controller?.addPointWithType(PlayerSide.sideA, 'service_fault');
                    },
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.gavel_rounded,
                    label: 'CONDUCT\nFAULT',
                    onPressed: () => _showConductSheet(context),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.timer_outlined,
                    label: 'TIMEOUT',
                    onPressed: () {
                      controller?.startMedicalTimeout();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(14.0)),

            // Row 3: UNDO LAST ACTION Button
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(52.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1E14),
                  foregroundColor: const Color(0xFF22C55E),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF16A34A), width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                  ),
                ),
                onPressed: onUndo,
                icon: Icon(
                  Icons.undo_rounded,
                  size: ResponsiveHelper.w(20.0),
                  color: Colors.white,
                ),
                label: Text(
                  'UNDO LAST ACTION',
                  style: AppTypography.bodyMd.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(14.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ).responsive(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointButton(
    BuildContext context, {
    required String label,
    required String subtitle,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14.0)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.displayLg.copyWith(
                color: textColor,
                fontSize: ResponsiveHelper.sp(26.0),
                fontWeight: FontWeight.w900,
                height: 1.0,
              ).responsive(context),
            ),
            SizedBox(height: ResponsiveHelper.h(4.0)),
            Text(
              subtitle,
              style: AppTypography.labelCaps.copyWith(
                color: subtitleColor,
                fontSize: ResponsiveHelper.sp(11.0),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ).responsive(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool hasRedUnderline = false,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
      child: Container(
        height: ResponsiveHelper.h(70.0),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(4.0),
          vertical: ResponsiveHelper.h(8.0),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: ResponsiveHelper.w(20.0),
            ),
            SizedBox(height: ResponsiveHelper.h(4.0)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelCaps.copyWith(
                color: Colors.white70,
                fontSize: ResponsiveHelper.sp(9.5),
                fontWeight: FontWeight.w700,
                height: 1.1,
              ).responsive(context),
            ),
            if (hasRedUnderline) ...[
              SizedBox(height: ResponsiveHelper.h(3.0)),
              Container(
                width: ResponsiveHelper.w(18.0),
                height: 2.0,
                color: const Color(0xFFEF4444),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
