import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrCheckinModalWidget extends StatefulWidget {
  QrCheckinModalWidget({super.key});

  @override
  State<QrCheckinModalWidget> createState() => _QrCheckinModalWidgetState();
}

class _QrCheckinModalWidgetState extends State<QrCheckinModalWidget>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  late final AnimationController _scanLineController;
  late final Animation<double> _scanLineAnimation;

  bool _isCloseHovered = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanLineController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();

    return Positioned.fill(
      child: GestureDetector(
        onTap: controller.hideQrModal, // backdrop dismiss
        child: Container(
          color: AppColors.background.withValues(alpha: 0.95),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent click-through
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24)),
                  padding: EdgeInsets.all(AppDimensions.paddingXl),
                  decoration: BoxDecoration(
                    color: Color(0x991A1A1A), // glass-panel
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)), // 2xl
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 48,
                            color: AppColors.accent,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Player Check-In',
                            style: AppTypography.headlineMdSora.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Scan player accreditation QR code or enter PIN manually.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyInter.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Scanner Area
                          _buildScannerArea(),

                          SizedBox(height: 24),

                          // Manual input
                          _buildManualInputRow(),
                        ],
                      ),

                      // Close button
                      Positioned(
                        top: -10,
                        right: -10,
                        child: MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isCloseHovered = true),
                          onExit: (_) =>
                              setState(() => _isCloseHovered = false),
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: controller.hideQrModal,
                            child: Icon(
                              Icons.close,
                              color: _isCloseHovered
                                  ? AppColors.accent
                                  : AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScannerArea() {
    return Container(
      constraints: BoxConstraints(maxWidth: 280),

      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.2),
          width: ResponsiveHelper.w(2),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Icon
          Icon(
            Icons.qr_code_2,
            size: 120,
            color: Colors
                .white10, // white/5 is practically very dim, white10 looks a bit better
          ),

          // Inner pulsing border
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.all(ResponsiveHelper.w(32)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.accent.withValues(
                      alpha: _pulseAnimation.value,
                    ),
                    width: ResponsiveHelper.w(2),
                  ),
                ),
              );
            },
          ),

          // Scan line
          AnimatedBuilder(
            animation: _scanLineAnimation,
            builder: (context, child) {
              return Align(
                alignment: Alignment(
                  0,
                  -1.0 + (_scanLineAnimation.value * 2.0),
                ),
                child: Container(
                  height: ResponsiveHelper.h(4),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(
                          alpha: 0.5,
                        ),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildManualInputRow() {
    return Container(
      height: ResponsiveHelper.h(40),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(Icons.link, size: 18, color: AppColors.muted),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: AppTypography.bodyInter.copyWith(color: AppColors.accent),
              decoration: InputDecoration(
                hintText: 'Enter PIN manually...',
                hintStyle: AppTypography.bodyInter.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
