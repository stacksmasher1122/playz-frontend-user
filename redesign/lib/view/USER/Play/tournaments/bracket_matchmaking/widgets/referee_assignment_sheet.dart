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
      Get.snackbar(
        "Success",
        "Referee invitation sent to $userName",
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to invite referee: $e",
        backgroundColor: AppColors.card,
        colorText: AppColors.error,
      );
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
      Get.snackbar(
        "Success",
        "Referee revoked",
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to revoke referee: $e",
        backgroundColor: AppColors.card,
        colorText: AppColors.error,
      );
    }
  }

  Widget _buildSearchResultsList(BuildContext context) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }
    if (_searchResults.isEmpty && _searchCtrl.text.isNotEmpty) {
      return Center(
        child: Text(
          "No users found",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13),
          ),
        ),
      );
    }
    return ListView.builder(
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
            child: photoUrl.isEmpty ? const Icon(Icons.person, color: AppColors.muted) : null,
          ),
          title: Text(
            displayName,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
              fontSize: context.responsiveFont(14),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            user['primaryEmail'] ?? '',
            style: AppTypography.bodyXs.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(12),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(3)),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
              ),
            ),
            onPressed: () => _assignReferee(user),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Assign",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: context.heightPct(85),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(4))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.widthPct(4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assign Referee",
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.heightPct(2)),

              if (widget.currentReferee != null && widget.currentReferee!['status'] != 'revoked' && widget.currentReferee!['status'] != 'none') ...[
                Container(
                  padding: EdgeInsets.all(context.widthPct(3)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Referee",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontSize: context.responsiveFont(12),
                              ),
                            ),
                            SizedBox(height: context.heightPct(0.5)),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('User').doc(widget.currentReferee!['userId']).get(),
                              builder: (context, snap) {
                                if (!snap.hasData) {
                                  return Text(
                                    "Loading...",
                                    style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
                                  );
                                }
                                final uData = snap.data?.data() as Map<String, dynamic>?;
                                final name = uData != null ? (uData['fullName'] ?? uData['primaryEmail'] ?? 'User') : 'User';
                                final isMe = widget.currentReferee!['userId'] == _currentUserId;
                                return Text(
                                  isMe ? "$name (you)" : name,
                                  style: AppTypography.headlineSm.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: context.responsiveFont(14),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                            SizedBox(height: context.heightPct(0.5)),
                            Text(
                              "Status: ${widget.currentReferee!['status']}",
                              style: AppTypography.labelCaps10.copyWith(
                                color: widget.currentReferee!['status'] == 'accepted' ? AppColors.accent : AppColors.warning,
                                fontSize: context.responsiveFont(11),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: context.widthPct(2)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                          ),
                        ),
                        onPressed: _revokeReferee,
                        child: Text(
                          "Revoke",
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.heightPct(2)),
                Text(
                  "Reassign to someone else:",
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightPct(1)),
              ],

              TextField(
                controller: _searchCtrl,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(14),
                ),
                decoration: InputDecoration(
                  hintText: "Search user by name or email...",
                  hintStyle: AppTypography.bodySm.copyWith(
                    color: AppColors.muted.withValues(alpha: 0.6),
                    fontSize: context.responsiveFont(13),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(Icons.search, color: AppColors.accent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                    borderSide: const BorderSide(color: AppColors.borderDark),
                  ),
                ),
                onChanged: _searchUsers,
              ),
              SizedBox(height: context.heightPct(2)),
              _buildSearchResultsList(context),
            ],
          ),
        ),
      ),
    );
  }
}
