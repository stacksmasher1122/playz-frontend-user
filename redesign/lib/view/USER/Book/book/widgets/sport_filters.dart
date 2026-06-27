import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';

class SportFilters extends StatefulWidget {
  const SportFilters({super.key});

  @override
  State<SportFilters> createState() => _SportFiltersState();
}

class _SportFiltersState extends State<SportFilters> {
  int _selectedIndex = 0;

  final List<String> sports = const [
    'All Sports',
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final bool isSelected = i == _selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                _selectedIndex = i;
              });

              /// 🔮 Future upgrade hook:
              /// trigger filter logic / API / analytics here
              // onSportSelected(sports[i]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent // green background
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                sports[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
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
