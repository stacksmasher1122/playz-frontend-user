import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
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
    setState(() {
      currentUserId = docId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Center(
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
          return Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        if (snapshot.hasError) {
          debugPrint("Error loading tournaments: ${snapshot.error}");
          return Center(
            child: Text("Error loading tournaments", style: AppTypography.bodyLg.copyWith(color: AppColors.error)),
          );
        }

        var docs = snapshot.data?.docs ?? [];

        // Client-side filtering check for safety (includes public or own tournaments)
        docs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final access = data['access'] as String?;
          final organizerId = data['organizerId'] as String?;
          return access == 'public' || organizerId == currentUserId;
        }).toList();

        // Client-side sorting by startDate
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

        if (docs.isEmpty) {
          return Center(
            child: Text("No upcoming tournaments found.", style: AppTypography.bodyLg.copyWith(color: AppColors.muted)),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final id = docs[index].id;
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
