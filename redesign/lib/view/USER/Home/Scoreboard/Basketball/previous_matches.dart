import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'basketball_scoreboard/widgets/match_summary_card.dart';

class PreviousMatchesScreenBasketball extends StatelessWidget {
  const PreviousMatchesScreenBasketball({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final Query<Map<String, dynamic>> matchesQuery = FirebaseFirestore.instance
        .collection('matches')
        .where('sport', isEqualTo: 'basketball')
        .where('allPlayers', arrayContains: currentUserId)
        .where('status', isEqualTo: 'completed');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Previous Basketball Matches', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: matchesQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading matches: ${snapshot.error}', style: const TextStyle(color: Colors.grey)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No completed basketball matches.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final matches = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final doc = matches[index];
              final match = BasketballMatchModel.fromMap(doc.data(), doc.id);

              return GestureDetector(
                onTap: () async {
                  final BasketballController matchController = Get.put(BasketballController());
                  await matchController.resumeMatch(match.id);
                  // wait a moment for state to parse before navigating
                  Future.delayed(const Duration(milliseconds: 300), () {
                     Get.to(() => Scaffold(
                        backgroundColor: AppColors.background,
                        appBar: AppBar(backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.white)),
                        body: BasketballMatchSummaryCard(state: matchController.liveState.value!, controller: matchController),
                     ));
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Text('COMPLETED', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                            Text(
                              DateFormat('MMM dd, yy').format(match.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(match.homeTeamName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('VS', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Text(match.awayTeamName, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
