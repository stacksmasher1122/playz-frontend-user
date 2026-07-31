import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/widgets/create_tournament_card.dart';
import 'package:redesign/view/USER/Tournament/create_tournament/create_tournament_screen.dart';
import 'widgets/tournament_card.dart';

class TournamentsListScreen extends StatefulWidget {
  const TournamentsListScreen({super.key});

  @override
  State<TournamentsListScreen> createState() => _TournamentsListScreenState();
}

class _TournamentsListScreenState extends State<TournamentsListScreen> {
  String? currentUserId;

  String selectedSport = 'All';
  DateTime? selectedSingleDate;
  DateTimeRange? selectedDateRange;

  final List<(String, IconData)> _sportsList = const [
    ('All', Icons.sports),
    ('Football', Icons.sports_soccer),
    ('Cricket', Icons.sports_cricket),
    ('Badminton', Icons.sports_tennis),
    ('Basketball', Icons.sports_basketball),
    ('Tennis', Icons.sports_tennis),
    ('Volleyball', Icons.sports_volleyball),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final docId = await UserPreferences.getDocId();
    if (mounted) {
      setState(() {
        currentUserId = docId;
      });
    }
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange:
          selectedDateRange ??
          DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.background,
              surface: AppColors.card,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: AppColors.card),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        selectedSingleDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (currentUserId == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    final dates = List.generate(
      14,
      (i) => DateTime.now().add(Duration(days: i)),
    );

    final isAnyFilterActive =
        selectedSport != 'All' ||
        selectedSingleDate != null ||
        selectedDateRange != null;

    return Column(
      children: [
        SizedBox(height: context.heightPct(1)),

        /// ── 1. SPORTS FILTER ROW ──
        SizedBox(
          height: context.heightPct(4.8).clamp(38.0, 46.0),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            scrollDirection: Axis.horizontal,
            itemCount: _sportsList.length,
            separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2)),
            itemBuilder: (context, i) {
              final sportName = _sportsList[i].$1;
              final icon = _sportsList[i].$2;
              final isActive =
                  selectedSport.toLowerCase() == sportName.toLowerCase();

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSport = sportName;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(3.5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(5),
                    ),
                    border: Border.all(
                      color: isActive ? AppColors.accent : AppColors.borderDark,
                      width: isActive ? 1.5 : 1.0,
                    ),
                    color: isActive
                        ? AppColors.accent.withValues(alpha: 0.18)
                        : AppColors.surface,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 15,
                        color: isActive ? AppColors.accent : AppColors.muted,
                      ),
                      SizedBox(width: context.widthPct(1.5)),
                      Text(
                        sportName,
                        style: AppTypography.headlineSm.copyWith(
                          color: isActive
                              ? AppColors.accent
                              : AppColors.textPrimary,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: context.heightPct(1)),

        /// ── 2. DAY DATE ROW WITH RANGE PICKER ──
        SizedBox(
          height: context.heightPct(9.0).clamp(70.0, 84.0),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            scrollDirection: Axis.horizontal,
            children: [
              // 1) All Dates Chip
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSingleDate = null;
                    selectedDateRange = null;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: context.widthPct(17).clamp(60.0, 74.0),
                  margin: EdgeInsets.only(right: context.widthPct(2.5)),
                  decoration: BoxDecoration(
                    color:
                        (selectedSingleDate == null &&
                            selectedDateRange == null)
                        ? AppColors.accent
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(3.5),
                    ),
                    border: Border.all(
                      color:
                          (selectedSingleDate == null &&
                              selectedDateRange == null)
                          ? AppColors.accent
                          : AppColors.borderDark,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color:
                            (selectedSingleDate == null &&
                                selectedDateRange == null)
                            ? AppColors.background
                            : AppColors.muted,
                      ),
                      SizedBox(height: context.heightPct(0.4)),
                      Text(
                        'All',
                        style: AppTypography.headlineSm.copyWith(
                          fontSize: context.responsiveFont(13),
                          fontWeight: FontWeight.bold,
                          color:
                              (selectedSingleDate == null &&
                                  selectedDateRange == null)
                              ? AppColors.background
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2) Date Range Picker Button
              GestureDetector(
                onTap: () => _pickDateRange(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: context.widthPct(20).clamp(70.0, 86.0),
                  margin: EdgeInsets.only(right: context.widthPct(2.5)),
                  decoration: BoxDecoration(
                    color: selectedDateRange != null
                        ? AppColors.accent
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(3.5),
                    ),
                    border: Border.all(
                      color: selectedDateRange != null
                          ? AppColors.accent
                          : AppColors.borderDark,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 18,
                        color: selectedDateRange != null
                            ? AppColors.background
                            : AppColors.accent,
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        'Range',
                        style: AppTypography.headlineSm.copyWith(
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.bold,
                          color: selectedDateRange != null
                              ? AppColors.background
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3) Single Day Cards (Next 14 Days)
              ...dates.map((d) {
                final isSelected =
                    selectedSingleDate != null &&
                    selectedSingleDate!.year == d.year &&
                    selectedSingleDate!.month == d.month &&
                    selectedSingleDate!.day == d.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSingleDate = d;
                      selectedDateRange = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: context.widthPct(15).clamp(52.0, 66.0),
                    margin: EdgeInsets.only(right: context.widthPct(2.5)),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(3.5),
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.borderDark,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMM').format(d),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelCaps10.copyWith(
                            fontSize: context.responsiveFont(11),
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.background
                                : AppColors.muted,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.2)),
                        Text(
                          '${d.day}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: context.responsiveFont(16),
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.background
                                : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.2)),
                        Text(
                          DateFormat('EEE').format(d),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyXs.copyWith(
                            fontSize: context.responsiveFont(11),
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? AppColors.background
                                : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // Active Filter Badges (Sport / Date Range)
        if (isAnyFilterActive) ...[
          SizedBox(height: context.heightPct(1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            child: Row(
              children: [
                if (selectedSport != 'All') ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3),
                      vertical: context.heightPct(0.5),
                    ),
                    margin: EdgeInsets.only(right: context.widthPct(2)),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sports,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        Text(
                          selectedSport,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsiveFont(12),
                          ),
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSport = 'All';
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (selectedDateRange != null ||
                    selectedSingleDate != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3),
                      vertical: context.heightPct(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_alt,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        Text(
                          selectedDateRange != null
                              ? '${DateFormat('MMM d').format(selectedDateRange!.start)} - ${DateFormat('MMM d').format(selectedDateRange!.end)}'
                              : DateFormat(
                                  'EEE, MMM d',
                                ).format(selectedSingleDate!),
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsiveFont(12),
                          ),
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSingleDate = null;
                              selectedDateRange = null;
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],

        SizedBox(height: context.heightPct(1)),

        /// ── TOURNAMENTS STREAM LIST ──
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tournaments')
                .where('access', isEqualTo: 'public')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                );
              }

              if (snapshot.hasError) {
                debugPrint("Error loading tournaments: ${snapshot.error}");
                return Center(
                  child: Text(
                    "Error loading tournaments",
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.error,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                );
              }

              var docs = snapshot.data?.docs ?? [];
              final now = DateTime.now();

              // 1. Client-side filtering check (public/organizer + past cutoff + sports filter + date filter)
              docs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final access = data['access'] as String?;
                final organizerId = data['organizerId'] as String?;
                final isOrganizerOrPublic =
                    access == 'public' || organizerId == currentUserId;
                if (!isOrganizerOrPublic) return false;

                // Hide past tournaments 2 days after end date
                final Timestamp? endTs = data['endDate'] ?? data['startDate'];
                if (endTs != null) {
                  final endDate = endTs.toDate();
                  final expiryCutoff = endDate.add(const Duration(days: 2));
                  if (now.isAfter(expiryCutoff)) {
                    return false;
                  }
                }

                // 2. Sport filtering
                if (selectedSport != 'All') {
                  final tSport =
                      (data['sport'] ??
                              data['sportName'] ??
                              data['game'] ??
                              data['category'] ??
                              '')
                          .toString()
                          .toLowerCase();
                  final target = selectedSport.toLowerCase();
                  if (!tSport.contains(target) && !target.contains(tSport)) {
                    return false;
                  }
                }

                // 3. Date filtering (Range or Single Date)
                if (selectedDateRange != null) {
                  final rangeStart = DateTime(
                    selectedDateRange!.start.year,
                    selectedDateRange!.start.month,
                    selectedDateRange!.start.day,
                  );
                  final rangeEnd = DateTime(
                    selectedDateRange!.end.year,
                    selectedDateRange!.end.month,
                    selectedDateRange!.end.day,
                    23,
                    59,
                    59,
                  );

                  final Timestamp? startTs = data['startDate'];
                  final Timestamp? tourneyEndTs = data['endDate'];
                  if (startTs == null && tourneyEndTs == null) return false;

                  final tStart = (startTs ?? tourneyEndTs!).toDate();
                  final tEnd = (tourneyEndTs ?? startTs!).toDate();

                  if (tStart.isAfter(rangeEnd) || tEnd.isBefore(rangeStart)) {
                    return false;
                  }
                } else if (selectedSingleDate != null) {
                  final sDay = DateTime(
                    selectedSingleDate!.year,
                    selectedSingleDate!.month,
                    selectedSingleDate!.day,
                  );
                  final sDayEnd = DateTime(
                    selectedSingleDate!.year,
                    selectedSingleDate!.month,
                    selectedSingleDate!.day,
                    23,
                    59,
                    59,
                  );

                  final Timestamp? startTs = data['startDate'];
                  final Timestamp? tourneyEndTs = data['endDate'];
                  if (startTs == null && tourneyEndTs == null) return false;

                  final tStart = (startTs ?? tourneyEndTs!).toDate();
                  final tEnd = (tourneyEndTs ?? startTs!).toDate();

                  if (tStart.isAfter(sDayEnd) || tEnd.isBefore(sDay)) {
                    return false;
                  }
                }

                return true;
              }).toList();

              // 4. Client-side sorting by startDate
              docs.sort((a, b) {
                final dataA = a.data() as Map<String, dynamic>;
                final dataB = b.data() as Map<String, dynamic>;
                final dateA = dataA['startDate'] as Timestamp?;
                final dateB = dataB['startDate'] as Timestamp?;
                if (dateA == null && dateB == null) return 0;
                if (dateA == null) return 1;
                if (dateB == null) return -1;
                return dateA.compareTo(dateB);
              });

              return ListView.builder(
                padding: EdgeInsets.all(context.widthPct(4)),
                itemCount: docs.isEmpty
                    ? 2
                    : docs.length + 1, // +1 for CreateTournamentCard at top
                itemBuilder: (context, index) {
                  // First item: Create Tournament Card
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.heightPct(2)),
                      child: CreateTournamentCard(
                        onTap: () {
                          Get.to(() => const CreateTournamentScreen());
                        },
                      ),
                    );
                  }

                  if (docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: context.heightPct(4)),
                      child: Center(
                        child: Text(
                          "No active or upcoming tournaments found for the selected filters.",
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLg.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(14),
                          ),
                        ),
                      ),
                    );
                  }

                  final docIndex = index - 1;
                  final data = docs[docIndex].data() as Map<String, dynamic>;
                  final id = docs[docIndex].id;
                  return TournamentCard(
                    tournamentId: id,
                    data: data,
                    currentUserId: currentUserId!,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
