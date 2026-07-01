import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SoloQueueOptions extends StatelessWidget {
  final bool soloQueue;
  final int players;
  final double radius;
  final bool splitAndPay;
  final bool bringOwnEquipment;
  final int baseSlotPrice;
  final ValueChanged<bool> onSoloQueueChanged;
  final ValueChanged<int> onPlayersChanged;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<bool> onSplitAndPayChanged;
  final ValueChanged<bool> onBringOwnEquipmentChanged;

  SoloQueueOptions({
    super.key,
    required this.soloQueue,
    required this.players,
    required this.radius,
    required this.splitAndPay,
    required this.bringOwnEquipment,
    required this.baseSlotPrice,
    required this.onSoloQueueChanged,
    required this.onPlayersChanged,
    required this.onRadiusChanged,
    required this.onSplitAndPayChanged,
    required this.onBringOwnEquipmentChanged,
  });

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.surface, // Spotify dark surface
          border: Border.all(color: _kGreen),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SOLO QUEUE TOGGLE
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: soloQueue,
              activeThumbColor: _kGreen,
              title: Text(
                'Solo Queue Mode',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Allow others to join and split cost',
                style: TextStyle(color: _kMuted),
              ),
              onChanged: onSoloQueueChanged,
            ),

            /// EXTRA OPTIONS (ONLY WHEN ENABLED)
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              secondChild: _soloQueueExtras(context),
              crossFadeState: soloQueue
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 250),
              sizeCurve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _soloQueueExtras(BuildContext context) {
    final int perPersonAmount = splitAndPay
        ? (baseSlotPrice / players).ceil()
        : baseSlotPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),

        /// TOTAL PLAYERS
        Text(
          'Total Players Needed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: players > 1 ? () => onPlayersChanged(players - 1) : null,
              icon: Icon(Icons.remove),
              color: Colors.white,
            ),
            Text(
              '$players Players',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => onPlayersChanged(players + 1),
              icon: Icon(Icons.add),
              color: Colors.white,
            ),
          ],
        ),

        SizedBox(height: 20),

        /// SPLIT & PAY TOGGLE
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: splitAndPay,
          activeThumbColor: _kGreen,
          title: Text(
            'Split & Pay',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            splitAndPay
                ? 'Each player pays ₹$perPersonAmount'
                : 'Host pays full amount',
            style: TextStyle(color: _kMuted),
          ),
          onChanged: onSplitAndPayChanged,
        ),

        SizedBox(height: 16),

        /// MATCHMAKING RADIUS (UP TO 20 KM)
        Text(
          'Matchmaking Radius',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: _kGreen, // background of label
            valueIndicatorTextStyle: TextStyle(
              color: Colors.black, // 👈 label text color
              fontWeight: FontWeight.w500,
            ),
            activeTrackColor: _kGreen,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: _kGreen,
          ),
          child: Slider(
            value: radius,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${radius.toInt()} km',
            onChanged: onRadiusChanged,
            activeColor: _kGreen,
          ),
        ),

        SizedBox(height: 12),

        /// BRING YOUR OWN EQUIPMENT
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: bringOwnEquipment,
          activeThumbColor: _kGreen,
          title: Text(
            'Bring Your Own Equipment',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Players will bring their own gear',
            style: TextStyle(color: _kMuted),
          ),
          onChanged: onBringOwnEquipmentChanged,
        ),

        SizedBox(height: 12),

        /// SUMMARY CARD
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
          decoration: BoxDecoration(
            border: Border.all(color: _kGreen),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            color: AppColors.surface,
          ),
          child: Text(
            splitAndPay
                ? 'Posting for $players Players • ₹$perPersonAmount / person • ${radius.toInt()} km'
                : 'Posting for $players Players • Host pays ₹$baseSlotPrice • ${radius.toInt()} km'
                      '${bringOwnEquipment ? ' • BYO Equipment' : ''}',
            style: TextStyle(color: _kGreen, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
