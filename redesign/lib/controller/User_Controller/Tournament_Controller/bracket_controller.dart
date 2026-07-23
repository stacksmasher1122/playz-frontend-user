import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:redesign/theme/app_colors.dart';

import '../../../model/User_Models/Tournament_Model/bracket_model.dart';
import '../../../model/User_Models/Tournament_Model/tournament_team_model.dart';

class BracketController extends GetxController {
  final String tournamentId;
  final bool isOrganizer;

  BracketController({
    required this.tournamentId,
    required this.isOrganizer,
  });

  final RxList<BracketMatchModel> matches = <BracketMatchModel>[].obs;
  final RxList<TournamentTeamModel> teams = <TournamentTeamModel>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool canShuffle = false.obs;
  final RxString tournamentStatus = 'upcoming'.obs;

  late String matchType; // knockout, roundRobinSingle, roundRobinDouble, groupToKnockout

  bool get isTournamentStarted => tournamentStatus.value == 'in_progress' || tournamentStatus.value == 'completed';

  @override
  void onInit() {
    super.onInit();
    _loadTournamentConfig();
  }

  Future<void> _loadTournamentConfig() async {
    try {
      // Listen to tournament status live
      FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .snapshots()
          .listen((snap) {
        if (snap.exists) {
          tournamentStatus.value = snap.data()?['status'] ?? 'upcoming';
        }
      });

      final doc = await FirebaseFirestore.instance.collection('tournaments').doc(tournamentId).get();
      if (doc.exists) {
        final data = doc.data()!;
        matchType = data['format']?['matchType'] ?? 'knockout';
        tournamentStatus.value = data['status'] ?? 'upcoming';

        // Listen to teams
        FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .collection('teams')
            .snapshots()
            .listen((snapshot) {
          teams.value = snapshot.docs.map((d) {
            final Map<String, dynamic> td = d.data();
            td['id'] = d.id; // ensure ID is passed
            return TournamentTeamModel(
              id: d.id,
              name: td['name'] ?? 'Unknown',
              registeredBy: td['registeredBy'] ?? '',
              players: [], // Not needed for bracket logic
              paymentStatus: td['paymentStatus'] ?? '',
            );
          }).toList();

          generateBracketDraft();
        });

        // Listen to bracket matches
        FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .collection('bracket')
            .snapshots()
            .listen((snapshot) {
          matches.value = snapshot.docs.map((d) => BracketMatchModel.fromMap(d.id, d.data())).toList();
          _checkCanShuffle();
          isLoading.value = false;
        });
      }
    } catch (e) {
      print("Error loading config: $e");
      isLoading.value = false;
    }
  }

  Future<void> startTournament(BuildContext context) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.play_circle_fill, color: AppColors.accent, size: 28),
            const SizedBox(width: 10),
            Text("Start Tournament?", style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Are you sure you want to start the tournament?\n\nOnce started, assigned referees and organizers will be able to start and score matches in the bracket.",
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel", style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Get.back(result: true),
            child: Text("Start Tournament", style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .update({
          'status': 'in_progress',
          'startedAt': FieldValue.serverTimestamp(),
        });
        tournamentStatus.value = 'in_progress';
        Get.snackbar(
          "Tournament Started",
          "Matches can now be started and scored.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to start tournament: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _checkCanShuffle() {
    if (!isOrganizer) {
      canShuffle.value = false;
      return;
    }
    // Can only shuffle if no matches are completed or scheduled (strictly speaking, completed)
    bool hasStarted = matches.any((m) => m.status == 'completed' || m.status == 'scheduled');
    canShuffle.value = !hasStarted && teams.length > 1;
  }

  Future<void> generateBracketDraft({bool forceShuffle = false, bool forceGenerate = false, bool setInProgress = false}) async {
    // Fetch existing matches directly from Firestore
    final oldMatches = await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(tournamentId)
        .collection('bracket')
        .get();

    // Only auto-generate if bracket does not exist in Firestore yet
    if (oldMatches.docs.isNotEmpty && !forceShuffle && !forceGenerate) {
      return;
    }

    if (teams.length < 2) return;

    List<TournamentTeamModel> teamList = List.from(teams);
    if (forceShuffle) {
      teamList.shuffle(Random());
    } else {
      // Deterministic sort to keep draft stable as teams join
      teamList.sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
    }

    List<BracketMatchModel> newMatches = [];

    if (matchType == 'knockout') {
      newMatches = _generateKnockout(teamList);
    } else if (matchType == 'roundRobinSingle') {
      newMatches = _generateRoundRobin(teamList, 1);
    } else if (matchType == 'roundRobinDouble') {
      newMatches = _generateRoundRobin(teamList, 2);
    } else if (matchType == 'groupToKnockout') {
      newMatches = _generateGroupStage(teamList);
    }

    // Write to Firestore as a batch
    final batch = FirebaseFirestore.instance.batch();

    // Clear old draft
    for (var doc in oldMatches.docs) {
      batch.delete(doc.reference);
    }

    // Add new
    for (var m in newMatches) {
      final docRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .collection('bracket')
          .doc(m.id);
      batch.set(docRef, m.toMap());
    }

    if (setInProgress) {
      final tourneyRef = FirebaseFirestore.instance.collection('tournaments').doc(tournamentId);
      batch.update(tourneyRef, {'status': 'in_progress'});
    }

    await batch.commit();
  }

  List<BracketMatchModel> _generateKnockout(List<TournamentTeamModel> teamList) {
    int totalTeams = teamList.length;
    if (totalTeams < 2) return [];

    int nextPowerOf2 = pow(2, (log(totalTeams) / log(2)).ceil()).toInt();
    int byes = nextPowerOf2 - totalTeams;

    List<BracketMatchModel> allMatches = [];
    final uuid = const Uuid();

    // Map: Round -> List of Matches
    Map<int, List<BracketMatchModel>> bracketRounds = {};

    // First, generate the structure for all rounds
    int currentRoundTeams = nextPowerOf2;
    int currentRound = 1;

    while (currentRoundTeams > 1) {
      int matchesInRound = currentRoundTeams ~/ 2;
      bracketRounds[currentRound] = [];
      for (int i = 0; i < matchesInRound; i++) {
        bracketRounds[currentRound]!.add(BracketMatchModel(
          id: uuid.v4(),
          round: currentRound,
          status: 'unscheduled',
        ));
      }
      currentRoundTeams = matchesInRound;
      currentRound++;
    }

    // Link matches to their next matches
    for (int r = 1; r < bracketRounds.length; r++) {
      List<BracketMatchModel> currentRoundMatches = bracketRounds[r]!;
      List<BracketMatchModel> nextRoundMatches = bracketRounds[r + 1]!;

      for (int i = 0; i < currentRoundMatches.length; i++) {
        int nextMatchIndex = i ~/ 2;
        String nextSlot = (i % 2 == 0) ? 'A' : 'B';
        assert(nextSlot == 'A' || nextSlot == 'B', "nextMatchSlot must be 'A' or 'B'");

        // Recreate the match with nextMatchId and nextMatchSlot
        currentRoundMatches[i] = BracketMatchModel(
          id: currentRoundMatches[i].id,
          round: currentRoundMatches[i].round,
          teamAId: currentRoundMatches[i].teamAId,
          teamBId: currentRoundMatches[i].teamBId,
          status: currentRoundMatches[i].status,
          nextMatchId: nextRoundMatches[nextMatchIndex].id,
          nextMatchSlot: nextSlot,
        );
      }
    }

    // Fill round 1 teams
    List<BracketMatchModel> round1 = bracketRounds[1]!;
    int teamIdx = 0;

    // Fill standard matches
    int standardMatches = (totalTeams - byes) ~/ 2;
    for (int i = 0; i < standardMatches; i++) {
      round1[i] = BracketMatchModel(
        id: round1[i].id,
        round: round1[i].round,
        teamAId: teamList[teamIdx++].id,
        teamBId: teamList[teamIdx++].id,
        status: round1[i].status,
        nextMatchId: round1[i].nextMatchId,
        nextMatchSlot: round1[i].nextMatchSlot,
      );
    }

    // Fill byes
    for (int i = standardMatches; i < standardMatches + byes; i++) {
      round1[i] = BracketMatchModel(
        id: round1[i].id,
        round: round1[i].round,
        teamAId: teamList[teamIdx++].id,
        teamBId: null, // Bye
        status: round1[i].status,
        nextMatchId: round1[i].nextMatchId,
        nextMatchSlot: round1[i].nextMatchSlot,
      );
    }

    // Flatten all matches
    for (var matchesInRound in bracketRounds.values) {
      allMatches.addAll(matchesInRound);
    }

    return allMatches;
  }

  List<BracketMatchModel> _generateRoundRobin(List<TournamentTeamModel> teamList, int times) {
    List<BracketMatchModel> matches = [];
    final uuid = const Uuid();

    // Circle method
    List<TournamentTeamModel?> localTeams = List.from(teamList);
    if (localTeams.length % 2 != 0) {
      localTeams.add(null); // Dummy for bye
    }

    int numRounds = localTeams.length - 1;
    int halfSize = localTeams.length ~/ 2;

    for (int loop = 0; loop < times; loop++) {
      // Re-initialize for double round robin to keep schedule linear
      List<TournamentTeamModel?> currentPositions = List.from(localTeams);

      for (int r = 0; r < numRounds; r++) {
        for (int i = 0; i < halfSize; i++) {
          final t1 = currentPositions[i];
          final t2 = currentPositions[localTeams.length - 1 - i];

          if (t1 != null && t2 != null) {
            matches.add(BracketMatchModel(
              id: uuid.v4(),
              round: r + 1 + (loop * numRounds),
              teamAId: loop == 0 ? t1.id : t2.id, // Swap home/away on second loop
              teamBId: loop == 0 ? t2.id : t1.id,
              status: 'unscheduled',
            ));
          }
        }
        // Rotate
        currentPositions.insert(1, currentPositions.removeLast());
      }
    }

    return matches;
  }

  List<BracketMatchModel> _generateGroupStage(List<TournamentTeamModel> teamList) {
    List<BracketMatchModel> matches = [];

    // Auto-calculate the number of groups so they are as evenly sized as possible.
    // Defaulting to roughly 4 teams per group.
    int totalTeams = teamList.length;
    int numGroups = (totalTeams / 4).ceil();
    if (numGroups == 0) numGroups = 1;

    // Distribute teams evenly
    List<List<TournamentTeamModel>> groups = List.generate(numGroups, (_) => []);
    for (int i = 0; i < totalTeams; i++) {
      groups[i % numGroups].add(teamList[i]);
    }

    // We could validate advancing teams here, but the strict UI enforcement would prevent getting here in a bad state.
    // For bracket generation, we just generate the RR part of the group stage initially.
    // Once group matches finish, we would calculate standings and generate the knockout stage,
    // which is beyond the scope of this initial draft generation.

    final uuid = const Uuid();
    for (int g = 0; g < groups.length; g++) {
      final groupName = String.fromCharCode(65 + g); // A, B, C...
      final rrMatches = _generateRoundRobin(groups[g], 1);
      for (var m in rrMatches) {
        matches.add(BracketMatchModel(
          id: uuid.v4(),
          round: m.round,
          teamAId: m.teamAId,
          teamBId: m.teamBId,
          status: 'unscheduled',
          groupName: "Group $groupName",
        ));
      }
    }

    return matches;
  }

  void shuffleBracket() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Shuffle Bracket?", style: TextStyle(color: Colors.white)),
        content: const Text("This will re-randomize team placements. Are you sure?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Get.back();
              generateBracketDraft(forceShuffle: true);
            },
            child: const Text("Shuffle"),
          ),
        ],
      )
    );
  }

  Future<void> scheduleMatch(BracketMatchModel match, BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: match.scheduledDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: match.scheduledDate != null
            ? TimeOfDay.fromDateTime(match.scheduledDate!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        final finalDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

        await FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .collection('bracket')
            .doc(match.id)
            .update({
          'scheduledDate': Timestamp.fromDate(finalDateTime),
          'status': 'scheduled',
        });
      }
    }
  }
}
