import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballInitializeMatchScreen extends StatefulWidget {
  const VolleyballInitializeMatchScreen({super.key});

  @override
  State<VolleyballInitializeMatchScreen> createState() =>
      _VolleyballInitializeMatchScreenState();
}

class _VolleyballInitializeMatchScreenState
    extends State<VolleyballInitializeMatchScreen> {
  late VolleyballInitializeMatchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballInitializeMatchController());
  }

  @override
  void dispose() {
    Get.delete<VolleyballInitializeMatchController>();
    super.dispose();
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
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MATCH ARENA',
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setup Match',
                style: AppTypography.headlineLg.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Configure your arena rules and draft your\nsquads.',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32),

              Text(
                'MATCH FORMAT',
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 16),

              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(20),
                    vertical: ResponsiveHelper.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value:
                          controller.format.value.isEmpty ||
                              controller.format.value == 'B3'
                          ? 'Best of 3'
                          : controller.format.value,
                      isExpanded: true,
                      dropdownColor: AppColors.card,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.accent,
                      ),
                      style: AppTypography.bodyMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      items: ['Best of 3', 'Best of 5', 'Best of 8'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) controller.selectMatchFormat(val);
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32),

              _buildStepperCard(
                title: 'SQUAD LIMIT',
                mainText: 'Players per\nTeam',
                valueStream: controller.squadLimit,
                onDecrement: controller.decrementSquadLimit,
                onIncrement: controller.incrementSquadLimit,
              ),
              SizedBox(height: 16),

              _buildSwitchCard(
                title: 'Substitute Players',
                subtitle: 'Enable mid-match\nrotations',
                valueStream: controller.subsEnabled,
                onChanged: controller.toggleSubs,
                icon: Icons.swap_horiz_rounded,
              ),
              SizedBox(height: 16),

              Obx(
                () => controller.subsEnabled.value
                    ? Column(
                        children: [
                          _buildStepperCard(
                            title: 'RESERVES',
                            titleColor: AppColors.accent,
                            mainText: 'Max\nSubstitutes',
                            valueStream: controller.maxSubstitutes,
                            onDecrement: controller.decrementSubs,
                            onIncrement: controller.incrementSubs,
                          ),
                          SizedBox(height: 32),
                        ],
                      )
                    : SizedBox(height: 16),
              ),

              Text(
                'BATTLE ROSTERS',
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 16),

              _buildTeamCard(
                context: context,
                titleStream: controller.homeTeamName,
                textController: controller.homeTeamController,
                dotColor: AppColors.error, // Team Red
              ),
              SizedBox(height: 16),

              _buildTeamCard(
                context: context,
                titleStream: controller.awayTeamName,
                textController: controller.awayTeamController,
                dotColor: Colors.blue, // Team Blue
              ),
              SizedBox(height: 32),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: ResponsiveHelper.h(60),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.loading.value
                          ? AppColors.muted
                          : AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.w(16),
                        ),
                      ),
                    ),
                    onPressed: controller.loading.value
                        ? null
                        : () => controller.initializeMatch(context),
                    child: controller.loading.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.background,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'START MATCH',
                                style: AppTypography.headlineSm.copyWith(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.sports, color: AppColors.background),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperCard({
    required String title,
    required String mainText,
    required RxInt valueStream,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    Color? titleColor,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelCaps10.copyWith(
                  color: titleColor ?? AppColors.muted,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                mainText,
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildRoundButton(
                Icons.remove,
                onDecrement,
                AppColors.background,
              ),
              SizedBox(width: 16),
              Obx(
                () => Text(
                  valueStream.value.toString(),
                  style: AppTypography.headlineMd.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              _buildRoundButton(
                Icons.add,
                onIncrement,
                AppColors.accent,
                iconColor: AppColors.background,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(
    IconData icon,
    VoidCallback onTap,
    Color bgColor, {
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(10)),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor ?? AppColors.accent, size: 24),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required RxBool valueStream,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Icon(icon, color: AppColors.accent),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLg.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: AppColors.background,
              activeTrackColor: AppColors.accent,
              inactiveThumbColor: AppColors.muted,
              inactiveTrackColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard({
    required BuildContext context,
    required RxString titleStream,
    required TextEditingController textController,
    required Color dotColor,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  titleStream.value.toUpperCase(),
                  style: AppTypography.labelCaps10.copyWith(
                    color: dotColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: textController,
            style: AppTypography.headlineSm.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (val) => titleStream.value = val,
          ),
        ],
      ),
    );
  }
}
