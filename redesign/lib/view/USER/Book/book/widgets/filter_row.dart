import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FilterRow extends StatefulWidget {
  FilterRow({super.key});

  @override
  State<FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  int _selectedIndex = 0;

  final List<String> filters = [
    'Filters',
    'Nearest',
    'Top Rated',
    'Low Price',
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      height: ResponsiveHelper.h(40),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (_, index) {
          final bool isSelected = index == _selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });

              /// 🔮 Future upgrade hook
              /// sort / filter logic can be triggered here
              // onFilterSelected(filters[index]);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(8)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent // green
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.white24,
                ),
              ),
              child: Text(
                filters[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors
                            .black // 🔥 black text on green
                      : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
