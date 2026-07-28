import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
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

      Get.snackbar("Success", accept ? "Referee invite accepted" : "Referee invite declined", backgroundColor: AppColors.success, colorText: AppColors.onPrimary);
    } catch (e) {
      Get.snackbar("Error", "Failed to update status: $e", backgroundColor: AppColors.error, colorText: AppColors.onPrimary);
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
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.onPrimary,
            fontSize: context.responsiveFont(18),
          ),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),
      body: _userDocIds.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', whereIn: _userDocIds)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.accent));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No notifications",
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(14),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(3),
                    vertical: context.heightPct(1),
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    final doc = snapshot.data!.docs[i];
                    final data = doc.data() as Map<String, dynamic>;

                    Widget cardContent;

                    if (data['type'] == 'referee_invite') {
                      final scheduledStr = _formatDate(data['scheduledDate']);
                      final createdStr = _formatDate(data['createdAt']);

                      cardContent = Card(
                        color: AppColors.card,
                        margin: EdgeInsets.symmetric(
                          horizontal: context.widthPct(1),
                          vertical: context.heightPct(0.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(context.widthPct(3.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(context.widthPct(2)),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.sports,
                                      color: AppColors.accent,
                                      size: context.minDimensionPct(5).clamp(18.0, 24.0),
                                    ),
                                  ),
                                  SizedBox(width: context.widthPct(2.5)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Referee Invitation",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.headlineSm.copyWith(
                                            color: AppColors.accent,
                                            fontSize: context.responsiveFont(15),
                                          ),
                                        ),
                                        if (createdStr.isNotEmpty)
                                          Text(
                                            createdStr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodySm.copyWith(
                                              color: AppColors.muted,
                                              fontSize: context.responsiveFont(10),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: context.widthPct(2)),
                                  // Status badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.widthPct(2),
                                      vertical: context.heightPct(0.4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: data['status'] == 'accepted'
                                          ? AppColors.success.withValues(alpha: 0.2)
                                          : data['status'] == 'declined'
                                              ? AppColors.error.withValues(alpha: 0.2)
                                              : AppColors.warning.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      (data['status'] ?? 'pending').toString().capitalizeFirst!,
                                      style: AppTypography.bodyXs.copyWith(
                                        color: data['status'] == 'accepted'
                                            ? AppColors.success
                                            : data['status'] == 'declined'
                                                ? AppColors.error
                                                : AppColors.warning,
                                        fontSize: context.responsiveFont(10),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.heightPct(1.2)),

                              // Tournament name
                              Row(
                                children: [
                                  const Icon(Icons.emoji_events_outlined, size: 16, color: AppColors.muted),
                                  SizedBox(width: context.widthPct(1.5)),
                                  Expanded(
                                    child: Text(
                                      data['tournamentName'] ?? 'Tournament',
                                      style: AppTypography.bodyLg.copyWith(
                                        color: AppColors.onPrimary,
                                        fontSize: context.responsiveFont(14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.heightPct(0.6)),

                              // Match label (A vs B)
                              Row(
                                children: [
                                  const Icon(Icons.sports_tennis, size: 16, color: AppColors.muted),
                                  SizedBox(width: context.widthPct(1.5)),
                                  Expanded(
                                    child: Text(
                                      data['matchLabel'] ?? '',
                                      style: AppTypography.bodyMd.copyWith(
                                        color: AppColors.onPrimary,
                                        fontSize: context.responsiveFont(13),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),

                              // Scheduled date (if available)
                              if (scheduledStr.isNotEmpty) ...[
                                SizedBox(height: context.heightPct(0.6)),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 14, color: AppColors.muted),
                                    SizedBox(width: context.widthPct(1.5)),
                                    Expanded(
                                      child: Text(
                                        scheduledStr,
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.muted,
                                          fontSize: context.responsiveFont(11),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              SizedBox(height: context.heightPct(1.2)),

                              // Action buttons
                              if (data['status'] == 'pending')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.widthPct(3.5),
                                          vertical: context.heightPct(0.8),
                                        ),
                                      ),
                                      onPressed: () => _handleInviteAction(context, doc.id, data, false),
                                      child: Text(
                                        "Decline",
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.error,
                                          fontSize: context.responsiveFont(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: context.widthPct(2.5)),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.widthPct(4.5),
                                          vertical: context.heightPct(0.8),
                                        ),
                                      ),
                                      onPressed: () => _handleInviteAction(context, doc.id, data, true),
                                      child: Text(
                                        "Accept",
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.background,
                                          fontSize: context.responsiveFont(12),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              else if (data['status'] == 'accepted')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Accepted",
                                          style: AppTypography.bodySm.copyWith(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w600,
                                            fontSize: context.responsiveFont(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.widthPct(3),
                                          vertical: context.heightPct(0.8),
                                        ),
                                      ),
                                      icon: const Icon(Icons.scoreboard, size: 16, color: AppColors.background),
                                      onPressed: () => _openScoreboard(data),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Open Scoreboard",
                                          style: AppTypography.bodySm.copyWith(
                                            color: AppColors.background,
                                            fontSize: context.responsiveFont(11),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              else if (data['status'] == 'declined')
                                Row(
                                  children: [
                                    const Icon(Icons.cancel, color: AppColors.error, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Declined",
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                        fontSize: context.responsiveFont(12),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      cardContent = Card(
                        color: AppColors.card,
                        margin: EdgeInsets.symmetric(
                          horizontal: context.widthPct(1),
                          vertical: context.heightPct(0.8),
                        ),
                        child: ListTile(
                          title: Text(
                            data['type'] ?? "Notification",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.onPrimary,
                              fontSize: context.responsiveFont(14),
                            ),
                          ),
                          subtitle: Text(
                            data['message'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                        ),
                      );
                    }

                    // Wrap in Dismissible for swipe-to-delete
                    return Dismissible(
                      key: Key(doc.id),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: context.widthPct(6)),
                        margin: EdgeInsets.symmetric(
                          horizontal: context.widthPct(1),
                          vertical: context.heightPct(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 28),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: context.widthPct(6)),
                        margin: EdgeInsets.symmetric(
                          horizontal: context.widthPct(1),
                          vertical: context.heightPct(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 28),
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
