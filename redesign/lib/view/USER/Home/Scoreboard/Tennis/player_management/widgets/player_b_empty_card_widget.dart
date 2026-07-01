import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'suggested_players_widget.dart';

class PlayerBEmptyCardWidget extends StatefulWidget {
  const PlayerBEmptyCardWidget({super.key});

  @override
  State<PlayerBEmptyCardWidget> createState() => _PlayerBEmptyCardWidgetState();
}

class _PlayerBEmptyCardWidgetState extends State<PlayerBEmptyCardWidget> {
  bool _isHovered = false;
  bool _isAddActive = false;
  bool _isScanHovered = false;

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white10, // unselected
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Empty Card
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: const BoxConstraints(minHeight: 400),
            padding: const EdgeInsets.all(AppDimensions.paddingXl),
            decoration: BoxDecoration(
              color: const Color(0x991A1A1A), // glass panel
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
              // Simulating dashed border with a simple solid border in Flutter for now (as standard flutter doesn't have dashed out of the box)
              border: Border.all(
                color: _isHovered
                    ? AppColors.primaryContainer.withValues(alpha: 0.4)
                    : Colors.white10,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center icon
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.person_search,
                      size: 48,
                      color: _isHovered
                          ? AppColors.primaryContainer
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Select Opponent',
                  style: AppTypography.headlineMdSora.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Search the tournament database or register a new participant.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyInter.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Add Player Button
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
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
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusXl,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryContainer
                                        .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: AppColors.onPrimary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
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
                        const SizedBox(height: 12),

                        // Scan Accreditation Button
                        MouseRegion(
                          onEnter: (_) => setState(() => _isScanHovered = true),
                          onExit: (_) => setState(() => _isScanHovered = false),
                          child: GestureDetector(
                            onTap: () =>
                                debugPrint("Scan Accreditation clicked"),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 48,
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
                                    color: AppColors.primary,
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

        const SizedBox(height: 24),
        const SuggestedPlayersWidget(),
      ],
    );
  }
}
