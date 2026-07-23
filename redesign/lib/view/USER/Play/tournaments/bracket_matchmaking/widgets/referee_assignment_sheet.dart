import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/services/user_search_service.dart';

class RefereeAssignmentSheet extends StatefulWidget {
  final String tournamentId;
  final String matchId;
  final Map<String, dynamic>? currentReferee;
  final String teamA;
  final String teamB;
  final int round;

  const RefereeAssignmentSheet({
    super.key,
    required this.tournamentId,
    required this.matchId,
    this.currentReferee,
    required this.teamA,
    required this.teamB,
    required this.round,
  });

  @override
  State<RefereeAssignmentSheet> createState() => _RefereeAssignmentSheetState();
}

class _RefereeAssignmentSheetState extends State<RefereeAssignmentSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final docId = await UserPreferences.getDocId();
    if (mounted) {
      setState(() {
        _currentUserId = docId;
      });
    }
  }

  void _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final matches = await UserSearchService.searchUsers(
        query,
        currentUserId: _currentUserId ?? '',
      );

      setState(() {
        _searchResults = matches;
      });
    } catch (e) {
      // Ignore
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _assignReferee(Map<String, dynamic> selectedUser) async {
    try {
      final userId = (selectedUser['userId'] ?? selectedUser['id'] ?? '').toString();
      final userEmail = (selectedUser['primaryEmail'] ?? '').toString();
      final userName = (selectedUser['fullName'] ?? selectedUser['rawName'] ?? 'User').toString();

      // 1. Fetch tournament name and match scheduled date for notification
      final tourneyDoc = await FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).get();
      final tourneyName = tourneyDoc.data()?['name'] ?? 'Tournament';

      final matchDoc = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .collection('bracket')
          .doc(widget.matchId)
          .get();
      final matchData = matchDoc.data();
      final Timestamp? scheduledTs = matchData?['scheduledDate'] as Timestamp?;

      // 2. Write Notification FIRST (store both userId and userEmail so query matches reliably)
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'userEmail': userEmail,
        'type': 'referee_invite',
        'tournamentId': widget.tournamentId,
        'bracketMatchId': widget.matchId,
        'tournamentName': tourneyName,
        'matchLabel': 'Round ${widget.round}: ${widget.teamA} vs ${widget.teamB}',
        'scheduledDate': scheduledTs,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Update bracket match SECOND (status: 'invited', NOT 'accepted')
      final matchRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .collection('bracket')
          .doc(widget.matchId);

      await matchRef.update({
        'referee': {
          'userId': userId,
          'userEmail': userEmail,
          'userName': userName,
          'status': 'invited',
          'invitedAt': FieldValue.serverTimestamp(),
        }
      });

      Get.back();
      Get.snackbar("Success", "Referee invitation sent to $userName", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to invite referee: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _revokeReferee() async {
    try {
      final matchRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .collection('bracket')
          .doc(widget.matchId);

      await matchRef.update({
        'referee.status': 'revoked',
      });

      Get.back();
      Get.snackbar("Success", "Referee revoked", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to revoke referee: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Assign Referee", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
              SizedBox(height: ResponsiveHelper.h(16)),

              if (widget.currentReferee != null && widget.currentReferee!['status'] != 'revoked' && widget.currentReferee!['status'] != 'none') ...[
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current Referee", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
                            SizedBox(height: 4),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('User').doc(widget.currentReferee!['userId']).get(),
                              builder: (context, snap) {
                                if (!snap.hasData) return Text("Loading...", style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary));
                                final uData = snap.data?.data() as Map<String, dynamic>?;
                                final name = uData != null ? (uData['fullName'] ?? uData['primaryEmail'] ?? 'User') : 'User';
                                final isMe = widget.currentReferee!['userId'] == _currentUserId;
                                return Text(
                                  isMe ? "$name (you)" : name,
                                  style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                            ),
                            SizedBox(height: 4),
                            Text("Status: ${widget.currentReferee!['status']}", style: AppTypography.labelCaps.copyWith(color: widget.currentReferee!['status'] == 'accepted' ? AppColors.accent : Colors.orange)),
                          ],
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(8)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: _revokeReferee,
                        child: Text("Revoke", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(16)),
                Text("Reassign to someone else:", style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                SizedBox(height: ResponsiveHelper.h(8)),
              ],

              TextField(
                controller: _searchCtrl,
                style: TextStyle(color: AppColors.onPrimary),
                decoration: InputDecoration(
                  hintText: "Search user by name or email...",
                  hintStyle: TextStyle(color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: Icon(Icons.search, color: AppColors.muted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _searchUsers,
              ),
              SizedBox(height: ResponsiveHelper.h(16)),

              if (_isSearching)
                Center(child: CircularProgressIndicator(color: AppColors.accent))
              else if (_searchResults.isEmpty && _searchCtrl.text.isNotEmpty)
                Center(child: Text("No users found", style: TextStyle(color: AppColors.muted)))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, i) {
                    final user = _searchResults[i];
                    final isMe = user['id'] == _currentUserId || user['primaryEmail'] == _currentUserId;
                    final rawName = user['fullName'] ?? user['primaryEmail'] ?? 'User';
                    final displayName = isMe ? "$rawName (you)" : rawName;
                    final photoUrl = (user['profileImageUrl'] ?? '').toString();

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.surface,
                        backgroundImage: photoUrl.isNotEmpty
                            ? CachedNetworkImageProvider(photoUrl)
                            : null,
                        child: photoUrl.isEmpty ? Icon(Icons.person, color: AppColors.muted) : null,
                      ),
                      title: Text(
                        displayName,
                        style: TextStyle(color: AppColors.onPrimary, fontWeight: isMe ? FontWeight.bold : FontWeight.normal),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        user['primaryEmail'] ?? '',
                        style: TextStyle(color: AppColors.muted),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: Size(0, 30),
                        ),
                        onPressed: () => _assignReferee(user),
                        child: Text("Assign", style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }
                ),
            ],
          ),
        ),
      ),
    );
  }
}
