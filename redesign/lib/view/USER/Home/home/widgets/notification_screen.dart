import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<void> _handleInviteAction(BuildContext context, String notificationId, Map<String, dynamic> notifData, bool accept) async {
    try {
      final matchRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(notifData['tournamentId'])
          .collection('bracket')
          .doc(notifData['bracketMatchId']);

      final notifRef = FirebaseFirestore.instance.collection('notifications').doc(notificationId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final matchDoc = await transaction.get(matchRef);
        if (matchDoc.exists) {
          final data = matchDoc.data()!;
          if (data['referee'] != null && data['referee']['status'] == 'invited') {
             transaction.update(matchRef, {
               'referee.status': accept ? 'accepted' : 'none',
               'referee.respondedAt': FieldValue.serverTimestamp(),
             });
          }
        }
        transaction.update(notifRef, {'status': accept ? 'accepted' : 'declined'});
      });

      Get.snackbar("Success", accept ? "Referee invite accepted" : "Referee invite declined", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update status: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _openScoreboard(Map<String, dynamic> notifData) {
    // Only fetch current match data and jump into scoreboard if it's assigned
    final tId = notifData['tournamentId'];
    final bId = notifData['bracketMatchId'];

    FirebaseFirestore.instance
        .collection('tournaments')
        .doc(tId)
        .collection('bracket')
        .doc(bId)
        .get()
        .then((doc) {
      if (doc.exists && doc.data()?['liveMatchId'] != null) {
        final liveMatchId = doc.data()!['liveMatchId'];

        Get.put(BadmintonController()); // Add controller to be used
        final controller = Get.find<BadmintonController>();

        controller.resumeTournamentMatch(
          tId: tId,
          bMatchId: bId,
          matchId: liveMatchId,
        );
      } else {
        Get.snackbar("Match Not Started", "The organizer hasn't started this match yet.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: AppColors.onPrimary)),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
      ),
      body: userId == null ? Center(child: Text("Not logged in")) : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No notifications", style: TextStyle(color: AppColors.muted)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              final doc = snapshot.data!.docs[i];
              final data = doc.data() as Map<String, dynamic>;

              if (data['type'] == 'referee_invite') {
                return Card(
                  color: AppColors.surface,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Referee Invite", style: AppTypography.headlineSm.copyWith(color: AppColors.accent)),
                        SizedBox(height: 8),
                        Text(data['tournamentName'] ?? '', style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
                        Text(data['matchLabel'] ?? '', style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                        SizedBox(height: 12),

                        if (data['status'] == 'pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _handleInviteAction(context, doc.id, data, false),
                                child: Text("Decline", style: TextStyle(color: Colors.redAccent)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                                onPressed: () => _handleInviteAction(context, doc.id, data, true),
                                child: Text("Accept", style: TextStyle(color: AppColors.background)),
                              )
                            ],
                          )
                        else if (data['status'] == 'accepted')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Accepted", style: TextStyle(color: Colors.green)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                                onPressed: () => _openScoreboard(data),
                                child: Text("Open Scoreboard", style: TextStyle(color: AppColors.background)),
                              )
                            ],
                          )
                        else if (data['status'] == 'declined')
                          Text("Declined", style: TextStyle(color: Colors.redAccent))
                      ],
                    ),
                  ),
                );
              }

              return ListTile(
                title: Text("Unknown notification", style: TextStyle(color: AppColors.onPrimary)),
              );
            },
          );
        },
      ),
    );
  }
}
