import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'suggested_players_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerBEmptyCardWidget extends StatefulWidget {
  PlayerBEmptyCardWidget({super.key});

  @override
  State<PlayerBEmptyCardWidget> createState() => _PlayerBEmptyCardWidgetState();
}

class _PlayerBEmptyCardWidgetState extends State<PlayerBEmptyCardWidget> {
  bool _isHovered = false;
  bool _isAddActive = false;
  bool _isScanHovered = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PLAYER B (RECEIVER)',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.muted,
              ),
            ),
            Container(
              width: ResponsiveHelper.w(48),
              height: ResponsiveHelper.h(4),
              decoration: BoxDecoration(
                color: Colors.white10, // unselected
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Empty Card
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            constraints: BoxConstraints(minHeight: 400),
            padding: EdgeInsets.all(AppDimensions.paddingXl),
            decoration: BoxDecoration(
              color: Color(0x991A1A1A), // glass panel
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
              // Simulating dashed border with a simple solid border in Flutter for now (as standard flutter doesn't have dashed out of the box)
              border: Border.all(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.4)
                    : Colors.white10,
                width: ResponsiveHelper.w(2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center icon
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    width: ResponsiveHelper.w(96),
                    height: ResponsiveHelper.h(96),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.outlineVariant,
                    ),
                    child: Icon(
                      Icons.person_search,
                      size: 48,
                      color: _isHovered
                          ? AppColors.accent
                          : AppColors.muted,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Text(
                  'Select Opponent',
                  style: AppTypography.headlineMdSora.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(40.0)),
                  child: Text(
                    'Search the tournament database or register a new participant.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyInter.copyWith(
                      color: AppColors.muted.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Add Player Button
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 240),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTapDown: (_) => setState(() => _isAddActive = true),
                          onTapUp: (_) => setState(() => _isAddActive = false),
                          onTapCancel: () =>
                              setState(() => _isAddActive = false),
                          onTap: () => debugPrint("Add Player B clicked"),
                          child: AnimatedScale(
                            scale: _isAddActive ? 0.95 : 1.0,
                            duration: Duration(milliseconds: 100),
                            child: Container(
                              height: ResponsiveHelper.h(48),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusXl,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.onPrimary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'ADD PLAYER B',
                                    style: AppTypography.labelCaps.copyWith(
                                      color: AppColors.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Scan Accreditation Button
                        MouseRegion(
                          onEnter: (_) => setState(() => _isScanHovered = true),
                          onExit: (_) => setState(() => _isScanHovered = false),
                          child: GestureDetector(
                            onTap: () =>
                                debugPrint("Scan Accreditation clicked"),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: ResponsiveHelper.h(48),
                              decoration: BoxDecoration(
                                color: _isScanHovered
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusXl,
                                ),
                                border: Border.all(
                                  color: AppColors.outlineVariant,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'SCAN ACCREDITATION',
                                  style: AppTypography.labelCaps.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24),
        SuggestedPlayersWidget(),
      ],
    );
  }
}
