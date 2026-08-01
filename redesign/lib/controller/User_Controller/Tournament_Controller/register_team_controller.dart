import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../model/User_Models/Tournament_Model/tournament_team_model.dart';
import '../../../services/user_search_service.dart';
import '../../../services/xp_reward_service.dart';

class RegisterTeamController extends GetxController {
  final String tournamentId;
  final Map<String, dynamic> tournamentData;
  final String currentUserId;

  late Razorpay _razorpay;

  RegisterTeamController({
    required this.tournamentId,
    required this.tournamentData,
    required this.currentUserId,
  });

  // Team Basics
  final TextEditingController teamNameController = TextEditingController();
  final RxString teamLogoPath = "".obs;

  // Players & Search
  final RxList<TournamentPlayerModel> selectedPlayers =
      <TournamentPlayerModel>[].obs;
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;

  // State
  final RxBool isRegistering = false.obs;
  final RxInt currentStep =
      1.obs; // 1: Basics, 2: Players & Roles, 3: Payment/Confirm

  // Derived tournament format data
  late final String sport;
  late final int teamSize;
  late final bool isFree;
  late final num entryFeeAmount;
  late final Map<String, String> availableRoles;

  @override
  void onInit() {
    super.onInit();
    _initTournamentData();
    _initRazorpay();
  }

  Future<void> addCurrentUserAction() async {
    await _addCurrentUser();
  }

  @override
  void onClose() {
    teamNameController.dispose();
    searchController.dispose();
    _razorpay.clear();
    super.onClose();
  }

  Future<void> _initTournamentData() async {
    _parseDataMap(tournamentData);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .get();
      if (doc.exists && doc.data() != null) {
        _parseDataMap(doc.data()!);
      }
    } catch (e) {
      debugPrint(
        "🔴 [TeamRegistration] Error fetching fresh tournament data: $e",
      );
    }
  }

  void _parseDataMap(Map<String, dynamic> data) {
    sport = data['sport'] ?? 'Football';
    teamSize = data['format']?['teamSize'] ?? 11;

    final entryFee = data['entryFee'] ?? {};
    isFree = entryFee['isFree'] ?? true;
    entryFeeAmount = entryFee['amount'] ?? 0;

    _setAvailableRoles();
  }

  void _setAvailableRoles() {
    if (sport == 'Cricket') {
      availableRoles = {
        'Batter': 'Batter',
        'Bowler': 'Bowler',
        'All-rounder': 'All-rounder',
        'Wicketkeeper': 'Wicketkeeper',
        'Captain': 'Captain',
      };
    } else if (sport == 'Football') {
      availableRoles = {
        'Goalkeeper': 'Goalkeeper',
        'Defender': 'Defender',
        'Midfielder': 'Midfielder',
        'Forward': 'Forward',
        'Captain': 'Captain',
      };
    } else if (sport == 'Volleyball') {
      availableRoles = {
        'Setter': 'Setter',
        'Libero': 'Libero',
        'Attacker': 'Attacker',
        'Blocker': 'Blocker',
        'Captain': 'Captain',
      };
    } else if (sport == 'Basketball') {
      availableRoles = {
        'Point Guard': 'Point Guard',
        'Shooting Guard': 'Shooting Guard',
        'Small Forward': 'Small Forward',
        'Power Forward': 'Power Forward',
        'Center': 'Center',
        'Captain': 'Captain',
      };
    } else if (sport == 'Badminton' ||
        sport == 'Tennis' ||
        sport == 'Table Tennis') {
      availableRoles = {'Player': 'Player', 'Captain': 'Captain'};
    } else {
      availableRoles = {'Player': 'Player', 'Captain': 'Captain'};
    }
  }

  Future<void> _addCurrentUser() async {
    try {
      if (selectedPlayers.any((p) => p.userId == currentUserId)) return;
      if (selectedPlayers.length >= teamSize) {
        Get.snackbar(
          "Team Full",
          "You have reached the maximum team size of $teamSize.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserId)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final rawName = data['fullName'] ?? data['primaryEmail'] ?? 'User';
        final photo = data['profileImageUrl'] ?? '';

        selectedPlayers.add(
          TournamentPlayerModel(
            userId: currentUserId,
            name: rawName,
            profileImageUrl: photo,
            sportRole: availableRoles.keys.first,
          ),
        );

        if (teamNameController.text.trim().isEmpty) {
          teamNameController.text = rawName;
        }
      }
    } catch (e) {
      debugPrint("🔴 [TeamRegistration] Error fetching current user: $e");
    }
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    debugPrint("💳 [TeamRegistration] Razorpay listeners initialized.");
  }

  Future<void> pickTeamLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      teamLogoPath.value = pickedFile.path;
    }
  }

  Future<void> searchUser(String query) async {
    debugPrint("🔍 [TeamRegistration] Searching players with query: '$query'");
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final results = await UserSearchService.searchUsers(
        query,
        currentUserId: currentUserId,
      );
      searchResults.value = results
          .where((u) => u['userId'] != currentUserId)
          .toList();
      debugPrint(
        "🔍 [TeamRegistration] Found ${searchResults.length} player search results.",
      );
    } catch (e) {
      debugPrint("🔴 [TeamRegistration] Error searching users: $e");
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> searchPlayers(String query) => searchUser(query);

  void addPlayerFromSearch(Map<String, dynamic> playerData) {
    debugPrint(
      "➕ [TeamRegistration] Adding player from search: ${playerData['name'] ?? playerData['fullName']} (id: ${playerData['userId']})",
    );
    if (selectedPlayers.any((p) => p.userId == playerData['userId'])) {
      Get.snackbar(
        "Already Added",
        "This player is already in your team.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedPlayers.length >= teamSize) {
      Get.snackbar(
        "Team Full",
        "You have reached the maximum team size of $teamSize.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    selectedPlayers.add(
      TournamentPlayerModel(
        userId: playerData['userId'],
        name: playerData['fullName'] ?? playerData['name'] ?? 'Player',
        profileImageUrl: playerData['profileImageUrl'] ?? '',
        sportRole: availableRoles.keys.first,
      ),
    );

    searchResults.removeWhere((p) => p['userId'] == playerData['userId']);
  }

  void addPlayer(Map<String, dynamic> playerData) =>
      addPlayerFromSearch(playerData);

  void removePlayer(String userId) {
    selectedPlayers.removeWhere((p) => p.userId == userId);
  }

  void updatePlayerRole(String userId, String newRole) {
    final index = selectedPlayers.indexWhere((p) => p.userId == userId);
    if (index != -1) {
      final oldPlayer = selectedPlayers[index];
      selectedPlayers[index] = TournamentPlayerModel(
        userId: oldPlayer.userId,
        name: oldPlayer.name,
        profileImageUrl: oldPlayer.profileImageUrl,
        sportRole: newRole,
      );
    }
  }

  void nextStep() {
    if (currentStep.value == 1) {
      if (selectedPlayers.isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Please add at least one player.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      currentStep.value = 2;
    } else if (currentStep.value == 2) {
      if (teamNameController.text.trim().isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Please enter a team/player name.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      currentStep.value = 3;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  Future<void> submitRegistration() async {
    if (isFree) {
      debugPrint(
        "💳 [TeamRegistration] Tournament is free entry. Submitting directly.",
      );
      await _writeTeamToFirestore('free', null);
    } else {
      _startRazorpayPayment();
    }
  }

  void _startRazorpayPayment() {
    final double feeVal = entryFeeAmount.toDouble();
    if (feeVal <= 0) {
      debugPrint(
        'ℹ️ [TeamRegistration] Entry fee is 0 ($feeVal), writing team as free entry.',
      );
      _writeTeamToFirestore('free', null);
      return;
    }

    final amountInPaise = (feeVal * 100).toInt();

    final user = FirebaseAuth.instance.currentUser;
    final phone = (user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty)
        ? user.phoneNumber!
        : '9876543210';
    final email = (user?.email != null && user!.email!.isNotEmpty)
        ? user.email!
        : 'player@playz.com';

    final razorpayKey =
        dotenv.env['RAZORPAY_KEY_ID'] ?? 'rzp_test_THjDLg1t3KW9ib';

    debugPrint('💳 [TeamRegistration] _startRazorpayPayment invoked:');
    debugPrint('   tournamentId: $tournamentId');
    debugPrint('   teamName: ${teamNameController.text.trim()}');
    debugPrint('   feeVal: ₹$feeVal ($amountInPaise paise)');
    debugPrint('   razorpayKey: $razorpayKey');
    debugPrint('   email: $email, phone: $phone');

    var options = {
      'key': razorpayKey,
      'amount': amountInPaise,
      'name': tournamentData['name'] ?? 'PlayZ Tournament',
      'description': 'Team Registration Fee',
      'prefill': {'contact': phone, 'email': email},
      'theme': {'color': '#1DB954'},
    };

    debugPrint('💳 [TeamRegistration] Opening Razorpay with options: $options');

    try {
      _razorpay.open(options);
      debugPrint(
        '💳 [TeamRegistration] _razorpay.open() invoked successfully.',
      );
    } catch (e, stack) {
      debugPrint('🔴 [TeamRegistration] Exception launching Razorpay: $e');
      debugPrint('🔴 [TeamRegistration] StackTrace: $stack');

      Get.snackbar(
        "Payment Launch Error",
        "Failed to launch Razorpay ($e). Executing dev fallback...",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      _writeTeamToFirestore(
        'paid_dev_fallback',
        'DEV_PASS_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('✅ [TeamRegistration] Razorpay Payment Success!');
    debugPrint('   paymentId: ${response.paymentId}');
    debugPrint('   orderId: ${response.orderId}');

    Get.snackbar(
      "Payment Successful",
      "Payment ID: ${response.paymentId}",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    await _writeTeamToFirestore('paid', response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('🔴 [TeamRegistration] Razorpay Payment Error/Failure!');
    debugPrint('   code: ${response.code}');
    debugPrint('   message: ${response.message}');

    Get.snackbar(
      "Payment Failed",
      response.message ?? "Transaction cancelled or failed.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint(
      '💳 [TeamRegistration] Razorpay External Wallet Selected: ${response.walletName}',
    );
    Get.snackbar(
      "External Wallet Selected",
      "${response.walletName}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _writeTeamToFirestore(
    String paymentStatus,
    String? paymentId,
  ) async {
    isRegistering.value = true;
    debugPrint(
      '🚀 [TeamRegistration] Writing team to Firestore (paymentStatus=$paymentStatus, paymentId=$paymentId)...',
    );
    try {
      final teamId = const Uuid().v4();
      String logoUrl = "";

      // Upload Logo
      if (teamLogoPath.value.isNotEmpty) {
        debugPrint(
          '📷 [TeamRegistration] Uploading team logo from path: ${teamLogoPath.value}',
        );
        final File imageFile = File(teamLogoPath.value);
        final compressedImage = await FlutterImageCompress.compressWithFile(
          imageFile.absolute.path,
          minWidth: 512,
          minHeight: 512,
          quality: 85,
        );

        if (compressedImage != null) {
          final ref = FirebaseStorage.instance.ref().child(
            'tournament_teams/$teamId.jpg',
          );
          final uploadTask = await ref.putData(
            compressedImage,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          logoUrl = await uploadTask.ref.getDownloadURL();
          debugPrint('📷 [TeamRegistration] Logo uploaded: $logoUrl');
        }
      }

      final team = TournamentTeamModel(
        id: teamId,
        name: teamNameController.text.trim(),
        logoUrl: logoUrl.isNotEmpty ? logoUrl : null,
        registeredBy: currentUserId,
        players: selectedPlayers.toList(),
        paymentStatus: paymentStatus,
        paymentId: paymentId,
      );

      final docRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .collection('teams')
          .doc(teamId);

      final tournamentRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId);

      // Run as transaction to update teamCount safely
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          docRef,
          team.toMap()..addAll({'registeredAt': FieldValue.serverTimestamp()}),
        );
        transaction.update(tournamentRef, {
          'teamCount': FieldValue.increment(1),
        });
      });

      // Save/update gameStats & award 100 XP for each participant in that specific sport
      for (final player in selectedPlayers) {
        if (player.userId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(player.userId)
              .set({
                'gameStats': {
                  'totalGamesPlayed': FieldValue.increment(1),
                  'totalTournaments': FieldValue.increment(1),
                  'lastUpdated': FieldValue.serverTimestamp(),
                },
              }, SetOptions(merge: true));
        }
      }

      final playerIds = selectedPlayers
          .map((p) => p.userId)
          .where((id) => id.isNotEmpty)
          .toList();
      await XpRewardService.awardTournamentParticipantXp(
        playerIds: playerIds,
        sport: sport,
        xpAmount: 100,
      );

      debugPrint(
        '✅ [TeamRegistration] Team $teamId successfully registered for tournament $tournamentId!',
      );

      Get.snackbar(
        "Registration Complete!",
        "Your team has been registered successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Navigate back to Tournament Detail screen
      Get.back();
    } catch (e, stack) {
      debugPrint('🔴 [TeamRegistration] Error writing team to Firestore: $e');
      debugPrint('🔴 [TeamRegistration] StackTrace: $stack');
      Get.snackbar(
        "Registration Failed",
        "Error: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRegistering.value = false;
    }
  }
}
