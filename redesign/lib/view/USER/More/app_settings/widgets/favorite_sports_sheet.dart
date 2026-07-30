import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FavoriteSportsSheet extends StatefulWidget {
  final List<String> allSports;
  final List<String> selectedSports;
  final ValueChanged<String> onToggle;

  const FavoriteSportsSheet({
    super.key,
    required this.allSports,
    required this.selectedSports,
    required this.onToggle,
  });

  @override
  State<FavoriteSportsSheet> createState() => _FavoriteSportsSheetState();
}

class _FavoriteSportsSheetState extends State<FavoriteSportsSheet> {
  late final TextEditingController _searchController;
  late Set<String> _selectedSports;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedSports = Set<String>.from(widget.selectedSports);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        if (_selectedSports.length > 1) {
          _selectedSports.remove(sport);
        }
      } else {
        _selectedSports.add(sport);
      }
    });
    widget.onToggle(sport);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final filteredSports = _searchQuery.isEmpty
        ? widget.allSports
        : widget.allSports
            .where((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    final sheetHeight = context.heightPct(75).clamp(450.0, 680.0);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: sheetHeight,
        padding: EdgeInsets.all(context.widthPct(6)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.minDimensionPct(6)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HANDLE BAR
            Center(
              child: Container(
                width: context.widthPct(10),
                height: context.heightPct(0.5).clamp(4.0, 6.0),
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(2)),

            /// HEADER TITLE
            Row(
              children: [
                const Icon(Icons.sports_soccer, color: AppColors.accent, size: 24),
                SizedBox(width: context.widthPct(2.5)),
                Expanded(
                  child: Text(
                    'Customize Favorite Sports',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(18),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(0.6)),
            Text(
              'Select sports to customize your home feed and join sport community groups.',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
            SizedBox(height: context.heightPct(2)),

            /// SEARCH BAR
            TextField(
              controller: _searchController,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
              ),
              decoration: InputDecoration(
                hintText: 'Search sports...',
                hintStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.muted, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceElevated,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(4),
                  vertical: context.heightPct(1.2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                  borderSide: const BorderSide(color: AppColors.accent, width: 1),
                ),
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
            ),
            SizedBox(height: context.heightPct(2)),

            /// SPOTIFY-STYLE PILLS WRAP (SCROLLABLE)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: filteredSports.isNotEmpty
                    ? Wrap(
                        spacing: context.widthPct(2.5),
                        runSpacing: context.heightPct(1.2),
                        children: filteredSports.map((sport) {
                          final isSelected = _selectedSports.contains(sport);
                          return GestureDetector(
                            onTap: () => _toggleSport(sport),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(4.5),
                                vertical: context.heightPct(1.1),
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(
                                  context.minDimensionPct(6),
                                ),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.borderDark,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                sport,
                                style: AppTypography.bodySm.copyWith(
                                  color: isSelected
                                      ? AppColors.background
                                      : AppColors.textPrimary,
                                  fontWeight:
                                      isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: context.responsiveFont(13),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: context.heightPct(4)),
                        alignment: Alignment.center,
                        child: Text(
                          'No sports matching "$_searchQuery"',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(13),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(height: context.heightPct(2)),

            /// DONE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(
                    vertical: context.heightPct(1.6),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(3.5),
                    ),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Done',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
