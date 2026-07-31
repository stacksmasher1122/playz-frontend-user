import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (currentUserId == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournaments')
          .where('access', isEqualTo: 'public')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
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

        // 1. Client-side filtering check for safety (includes public or own tournaments)
        docs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final access = data['access'] as String?;
          final organizerId = data['organizerId'] as String?;
          final isOrganizerOrPublic = access == 'public' || organizerId == currentUserId;
          if (!isOrganizerOrPublic) return false;

          // 2. Hide past tournaments 2 days after end date
          final Timestamp? endTs = data['endDate'] ?? data['startDate'];
          if (endTs != null) {
            final endDate = endTs.toDate();
            final expiryCutoff = endDate.add(const Duration(days: 2));
            if (now.isAfter(expiryCutoff)) {
              // Hide past tournament because 2 days have passed since end date
              return false;
            }
          }
          return true;
        }).toList();

        // 3. Client-side sorting by startDate
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
          itemCount: docs.length + 1, // +1 for CreateTournamentCard at top
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

            final docIndex = index - 1;
            if (docs.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: context.heightPct(4)),
                child: Center(
                  child: Text(
                    "No active or upcoming tournaments found.",
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                ),
              );
            }

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
    );
  }
}
