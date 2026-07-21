import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      // Filter: access == 'public' OR organizerId == currentUserId
      // Note: Firestore doesn't support logical OR. We use Filter.or
      stream: FirebaseFirestore.instance
          .collection('tournaments')
          .where(Filter.or(
            Filter('access', isEqualTo: 'public'),
            Filter('organizerId', isEqualTo: currentUserId),
          ))
          .orderBy('startDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error loading tournaments", style: AppTypography.bodyLg.copyWith(color: AppColors.error)),
          );
        }

        final docs = snapshot.data?.docs ?? [];

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
