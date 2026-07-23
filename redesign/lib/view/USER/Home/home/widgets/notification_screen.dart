import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';

import 'package:redesign/shared_preferences/userPreferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> _userDocIds = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final docId = await UserPreferences.getDocId();
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    final authEmail = FirebaseAuth.instance.currentUser?.email;
    final ids = <String>{};
    if (docId != null && docId.isNotEmpty) ids.add(docId);
    if (authUid != null && authUid.isNotEmpty) ids.add(authUid);
    if (authEmail != null && authEmail.isNotEmpty) ids.add(authEmail);

    if (mounted) {
      setState(() {
        _userDocIds = ids.toList();
      });
    }
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return '';
    try {
      final DateTime dt = (ts as Timestamp).toDate();
      return DateFormat('MMM d, yyyy • h:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }

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
          if (data['referee'] != null) {
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

        final controller = Get.put(BadmintonController());

        controller.resumeTournamentMatch(
          tId: tId,
          bMatchId: bId,
          matchId: liveMatchId,
          readOnly: false,
        );
      } else {
        Get.snackbar("Match Ready", "Opening match bracket...");
        Get.toNamed('/bracket_matchmaking', arguments: {
          'tournamentId': tId,
          'isOrganizer': false,
        });
      }
    });
  }

  Future<void> _deleteNotification(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(docId).delete();
    } catch (e) {
      debugPrint('Failed to delete notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: AppColors.onPrimary)),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
      ),
      body: _userDocIds.isEmpty
          ? Center(child: CircularProgressIndicator(color: AppColors.accent))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', whereIn: _userDocIds)
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

              Widget cardContent;

              if (data['type'] == 'referee_invite') {
                final scheduledStr = _formatDate(data['scheduledDate']);
                final createdStr = _formatDate(data['createdAt']);

                cardContent = Card(
                  color: AppColors.surface,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.sports, color: AppColors.accent, size: 20),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Referee Invitation", style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontSize: 15)),
                                  if (createdStr.isNotEmpty)
                                    Text(createdStr, style: AppTypography.bodySm.copyWith(color: AppColors.muted, fontSize: 10)),
                                ],
                              ),
                            ),
                            // Status badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: data['status'] == 'accepted'
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : data['status'] == 'declined'
                                        ? Colors.red.withValues(alpha: 0.2)
                                        : Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (data['status'] ?? 'pending').toString().capitalizeFirst!,
                                style: TextStyle(
                                  color: data['status'] == 'accepted'
                                      ? Colors.green
                                      : data['status'] == 'declined'
                                          ? Colors.redAccent
                                          : Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Tournament name
                        Row(
                          children: [
                            Icon(Icons.emoji_events_outlined, size: 16, color: AppColors.muted),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                data['tournamentName'] ?? 'Tournament',
                                style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),

                        // Match label (A vs B)
                        Row(
                          children: [
                            Icon(Icons.sports_tennis, size: 16, color: AppColors.muted),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                data['matchLabel'] ?? '',
                                style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Scheduled date (if available)
                        if (scheduledStr.isNotEmpty) ...[
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: AppColors.muted),
                              SizedBox(width: 6),
                              Text(
                                scheduledStr,
                                style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 12),

                        // Action buttons
                        if (data['status'] == 'pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                onPressed: () => _handleInviteAction(context, doc.id, data, false),
                                child: Text("Decline", style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                ),
                                onPressed: () => _handleInviteAction(context, doc.id, data, true),
                                child: Text("Accept", style: TextStyle(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        else if (data['status'] == 'accepted')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text("Accepted", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                icon: Icon(Icons.scoreboard, size: 16, color: AppColors.background),
                                onPressed: () => _openScoreboard(data),
                                label: Text("Open Scoreboard", style: TextStyle(color: AppColors.background, fontSize: 12, fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        else if (data['status'] == 'declined')
                          Row(
                            children: [
                              Icon(Icons.cancel, color: Colors.redAccent, size: 16),
                              SizedBox(width: 4),
                              Text("Declined", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                cardContent = Card(
                  color: AppColors.surface,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(data['type'] ?? "Notification", style: TextStyle(color: AppColors.onPrimary)),
                    subtitle: Text(data['message'] ?? '', style: TextStyle(color: AppColors.muted)),
                  ),
                );
              }

              // Wrap in Dismissible for swipe-to-delete
              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.horizontal,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 24),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 24),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                ),
                onDismissed: (_) => _deleteNotification(doc.id),
                child: cardContent,
              );
            },
          );
        },
      ),
    );
  }
}
