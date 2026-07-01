import 'package:flutter/material.dart';
import 'select_sport_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kMuted = Color(0xFF9E9E9E);

class SelectSportCategorySection extends StatelessWidget {
  final String title;
  final List<SportItem> sports;
  final bool expanded;
  final String? selectedSport;
  final String searchQuery;
  final VoidCallback onToggle;

  SelectSportCategorySection({
    super.key,
    required this.title,
    required this.sports,
    required this.expanded,
    required this.selectedSport,
    required this.searchQuery,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final filtered = sports
        .where((s) => s.name.toLowerCase().contains(searchQuery))
        .toList();

    if (filtered.isEmpty) {
      return SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final isExpanded = expanded || searchQuery.isNotEmpty;

    return SliverList(
      delegate: SliverChildListDelegate([
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: kMuted,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = width > 900
                    ? 5
                    : width > 600
                    ? 4
                    : 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) {
                    final sport = filtered[i];
                    return SelectSportTile(
                      sport: sport,
                      selected: sport.name == selectedSport,
                    );
                  },
                );
              },
            ),
          ),
        Divider(color: Colors.white12),
      ]),
    );
  }
}
