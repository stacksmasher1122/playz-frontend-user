import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

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

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('User')
          .orderBy('username')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .limit(10)
          .get();

      setState(() {
        _searchResults = snapshot.docs.map((d) {
          var data = d.data();
          data['id'] = d.id;
          return data;
        }).toList();
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

  Future<void> _assignReferee(String userId) async {
    try {
      // 1. Update bracket match
      final matchRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .collection('bracket')
          .doc(widget.matchId);

      await matchRef.update({
        'referee': {
          'userId': userId,
          'status': 'invited',
          'invitedAt': FieldValue.serverTimestamp(),
        }
      });

      // 2. Fetch tournament name for notification
      final tourneyDoc = await FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).get();
      final tourneyName = tourneyDoc.data()?['name'] ?? 'Tournament';

      // 3. Create Notification
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'type': 'referee_invite',
        'tournamentId': widget.tournamentId,
        'bracketMatchId': widget.matchId,
        'tournamentName': tourneyName,
        'matchLabel': 'Round ${widget.round}: ${widget.teamA} vs ${widget.teamB}',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar("Success", "Referee invite sent", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to assign referee: $e", backgroundColor: Colors.red, colorText: Colors.white);
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
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
      ),
      child: SafeArea(
        child: Padding(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Referee", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
                          SizedBox(height: 4),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('User').doc(widget.currentReferee!['userId']).get(),
                            builder: (context, snap) {
                              if (!snap.hasData) return Text("Loading...", style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary));
                              return Text(snap.data?.data() != null ? (snap.data!.data() as Map<String,dynamic>)['username'] ?? 'User' : 'User', style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary));
                            }
                          ),
                          SizedBox(height: 4),
                          Text("Status: ${widget.currentReferee!['status']}", style: AppTypography.labelCaps.copyWith(color: widget.currentReferee!['status'] == 'accepted' ? AppColors.accent : Colors.orange)),
                        ],
                      ),
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
                  hintText: "Search user by username...",
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: ResponsiveHelper.h(200)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, i) {
                      final user = _searchResults[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.surface,
                          child: Icon(Icons.person, color: AppColors.muted),
                        ),
                        title: Text(user['username'] ?? 'User', style: TextStyle(color: AppColors.onPrimary)),
                        subtitle: Text(user['name'] ?? '', style: TextStyle(color: AppColors.muted)),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: Size(0, 30),
                          ),
                          onPressed: () => _assignReferee(user['id']),
                          child: Text("Assign", style: TextStyle(color: AppColors.background)),
                        ),
                      );
                    }
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
