import 'package:flutter/material.dart';

import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CoinTossBottomSheet extends StatefulWidget {
  final String teamAName;
  final String teamBName;
  final Function(bool teamAServesFirst) onTossComplete;

  const CoinTossBottomSheet({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.onTossComplete,
  });

  @override
  State<CoinTossBottomSheet> createState() => _CoinTossBottomSheetState();
}

class _CoinTossBottomSheetState extends State<CoinTossBottomSheet> {
  String? tossWinner;
  String? decision; // 'Serve' or 'Receive'

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('COIN TOSS', style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.muted),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          SizedBox(height: 24),
          
          Text('Who won the toss?', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildOptionCard(
                  title: widget.teamAName,
                  isSelected: tossWinner == widget.teamAName,
                  onTap: () => setState(() => tossWinner = widget.teamAName),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildOptionCard(
                  title: widget.teamBName,
                  isSelected: tossWinner == widget.teamBName,
                  onTap: () => setState(() => tossWinner = widget.teamBName),
                ),
              ),
            ],
          ),
          
          if (tossWinner != null) ...[
            SizedBox(height: 24),
            Text('What did $tossWinner choose?', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    title: 'Serve',
                    isSelected: decision == 'Serve',
                    onTap: () => setState(() => decision = 'Serve'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildOptionCard(
                    title: 'Receive',
                    isSelected: decision == 'Receive',
                    onTap: () => setState(() => decision = 'Receive'),
                  ),
                ),
              ],
            ),
          ],
          
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(56),
            child: ElevatedButton(
              onPressed: (tossWinner != null && decision != null) ? () {
                bool teamAWonToss = tossWinner == widget.teamAName;
                bool choseToServe = decision == 'Serve';
                
                // If Team A won the toss and chose Serve -> Team A serves first
                // If Team A won the toss and chose Receive -> Team B serves first
                // If Team B won the toss and chose Serve -> Team B serves first
                // If Team B won the toss and chose Receive -> Team A serves first
                bool teamAServesFirst = teamAWonToss ? choseToServe : !choseToServe;
                
                Navigator.pop(context);
                widget.onTossComplete(teamAServesFirst);
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.card,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
              ),
              child: Text('CONFIRM TOSS & START', style: AppTypography.headlineMd.copyWith(
                color: (tossWinner != null && decision != null) ? Colors.black : AppColors.muted, 
                fontWeight: FontWeight.bold
              )),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildOptionCard({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ResponsiveHelper.h(60),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.card,
          border: Border.all(color: isSelected ? AppColors.accent : AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Text(
          title, 
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMd.copyWith(
            color: isSelected ? AppColors.accent : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          )
        ),
      ),
    );
  }
}
