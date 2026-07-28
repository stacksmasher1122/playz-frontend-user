import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PenaltyBottomSheet extends StatefulWidget {
  final String teamAName;
  final String teamBName;
  final Function(String team, String cardType, String reason) onPenaltyIssued;

  const PenaltyBottomSheet({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.onPenaltyIssued,
  });

  @override
  State<PenaltyBottomSheet> createState() => _PenaltyBottomSheetState();
}

class _PenaltyBottomSheetState extends State<PenaltyBottomSheet> {
  String? selectedTeam;
  String? selectedCard;
  
  final List<String> reasons = [
    'Unsportsmanlike Conduct',
    'Delay of Game',
    'Abusive Language',
    'Aggressive Behavior',
    'Illegal Substitution'
  ];
  String selectedReason = 'Unsportsmanlike Conduct';

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ISSUE PENALTY CARD', style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.muted),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            SizedBox(height: 24),
            
            Text('1. SELECT TEAM', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTeamCard(widget.teamAName)),
                SizedBox(width: 16),
                Expanded(child: _buildTeamCard(widget.teamBName)),
              ],
            ),
            SizedBox(height: 24),
            
            Text('2. SELECT CARD', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildCardSelection('Yellow Card', Colors.amber, 'Warning')),
                SizedBox(width: 16),
                Expanded(child: _buildCardSelection('Red Card', AppColors.error, 'Penalty Point')),
              ],
            ),
            SizedBox(height: 24),
            
            Text('3. REASON', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedReason,
                  isExpanded: true,
                  dropdownColor: AppColors.card,
                  icon: Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
                  style: AppTypography.bodyMd.copyWith(color: Colors.white),
                  items: reasons.map((String reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedReason = val);
                  },
                ),
              ),
            ),
            
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(56),
              child: ElevatedButton(
                onPressed: (selectedTeam != null && selectedCard != null) ? () {
                  Navigator.pop(context);
                  widget.onPenaltyIssued(selectedTeam!, selectedCard!, selectedReason);
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCard == 'Red Card' ? AppColors.error : AppColors.accent,
                  disabledBackgroundColor: AppColors.card,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                ),
                child: Text('ISSUE PENALTY', style: AppTypography.headlineMd.copyWith(
                  color: (selectedTeam != null && selectedCard != null) 
                      ? (selectedCard == 'Red Card' ? Colors.white : Colors.black) 
                      : AppColors.muted, 
                  fontWeight: FontWeight.bold
                )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(String teamName) {
    bool isSelected = selectedTeam == teamName;
    return GestureDetector(
      onTap: () => setState(() => selectedTeam = teamName),
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
          teamName, 
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

  Widget _buildCardSelection(String cardName, Color cardColor, String subtitle) {
    bool isSelected = selectedCard == cardName;
    return GestureDetector(
      onTap: () => setState(() => selectedCard = cardName),
      child: Container(
        height: ResponsiveHelper.h(80),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? cardColor.withValues(alpha: 0.1) : AppColors.card,
          border: Border.all(color: isSelected ? cardColor : AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 24, height: 32, decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(4))),
            SizedBox(height: 8),
            Text(subtitle, style: AppTypography.labelCaps10.copyWith(color: isSelected ? cardColor : AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
