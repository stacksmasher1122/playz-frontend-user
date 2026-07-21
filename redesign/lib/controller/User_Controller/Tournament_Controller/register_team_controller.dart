import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../model/User_Models/Tournament_Model/tournament_team_model.dart';
import '../../../shared_preferences/userPreferences.dart';

class RegisterTeamController extends GetxController {
  final String tournamentId;
  final Map<String, dynamic> tournamentData;
  final String currentUserId;

  // Razorpay test credentials
  final String _razorpayKeyId = "rzp_test_TG2fA8szjWz48p";
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
  final RxList<TournamentPlayerModel> selectedPlayers = <TournamentPlayerModel>[].obs;
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;

  // State
  final RxBool isRegistering = false.obs;
  final RxInt currentStep = 1.obs; // 1: Basics, 2: Players & Roles, 3: Payment/Confirm

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

    if (teamSize == 1) {
      // For singles, we add the current user and go straight to payment step.
      _addCurrentUser().then((_) {
        // Set a default team name since UI for it is skipped
        final player = selectedPlayers.first;
        teamNameController.text = player.name;
        currentStep.value = 3;
      });
    }
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

  void _initTournamentData() {
    sport = tournamentData['sport'] ?? 'Football';
    teamSize = tournamentData['format']?['teamSize'] ?? 11;

    final entryFee = tournamentData['entryFee'] ?? {};
    isFree = entryFee['isFree'] ?? true;
    entryFeeAmount = entryFee['amount'] ?? 0;

    _setAvailableRoles();
  }

  void _setAvailableRoles() {
    if (sport == 'Cricket') {
      availableRoles = {'Batter': 'Batter', 'Bowler': 'Bowler', 'All-rounder': 'All-rounder', 'Wicketkeeper': 'Wicketkeeper', 'Captain': 'Captain'};
    } else if (sport == 'Football') {
      availableRoles = {'Goalkeeper': 'Goalkeeper', 'Defender': 'Defender', 'Midfielder': 'Midfielder', 'Forward': 'Forward', 'Captain': 'Captain'};
    } else if (sport == 'Volleyball') {
      availableRoles = {'Setter': 'Setter', 'Libero': 'Libero', 'Attacker': 'Attacker', 'Blocker': 'Blocker', 'Captain': 'Captain'};
    } else if (sport == 'Basketball') {
      availableRoles = {'Point Guard': 'Point Guard', 'Shooting Guard': 'Shooting Guard', 'Small Forward': 'Small Forward', 'Power Forward': 'Power Forward', 'Center': 'Center', 'Captain': 'Captain'};
    } else if (sport == 'Badminton' || sport == 'Tennis' || sport == 'Table Tennis') {
      availableRoles = {'Player': 'Player', 'Captain': 'Captain'};
    } else {
      // Fallback
      availableRoles = {'Player': 'Player', 'Captain': 'Captain'};
    }
  }

  Future<void> _addCurrentUser() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('User').doc(currentUserId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final name = data['name'] ?? data['username'] ?? 'Me';
        final photo = data['profile_picture'] ?? '';

        selectedPlayers.add(
          TournamentPlayerModel(
            userId: currentUserId,
            name: name,
            profileImageUrl: photo,
            sportRole: 'Captain',
          )
        );
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> pickTeamLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      teamLogoPath.value = image.path;
    }
  }

  Future<void> searchPlayers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      // Simplified search logic. In reality, you'd probably use a better search index.
      final queryLower = query.toLowerCase();

      final QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .limit(20)
          .get();

      final List<Map<String, dynamic>> results = [];

      for (var doc in usersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id;

        // Skip already added players
        if (selectedPlayers.any((p) => p.userId == id)) continue;

        final name = (data['name'] ?? '').toString().toLowerCase();
        final username = (data['username'] ?? '').toString().toLowerCase();

        if (name.contains(queryLower) || username.contains(queryLower)) {
          // Check if friend (assuming a friends subcollection or array exists)
          // For now, mock the friend check if not available.
          bool isFriend = false;
          if (data['friends'] != null && data['friends'] is List) {
             isFriend = (data['friends'] as List).contains(currentUserId);
          }

          results.add({
            'userId': id,
            'name': data['name'] ?? data['username'],
            'profileImageUrl': data['profile_picture'] ?? '',
            'isFriend': isFriend,
            'favoriteSports': data['favorite_sports'] ?? [],
          });
        }
      }

      // Sort friends first
      results.sort((a, b) => (b['isFriend'] ? 1 : 0).compareTo(a['isFriend'] ? 1 : 0));

      searchResults.assignAll(results);
    } catch (e) {
      print("Search error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  void addPlayer(Map<String, dynamic> playerData) {
    if (selectedPlayers.length >= teamSize) {
      Get.snackbar("Team Full", "You have reached the maximum team size of $teamSize.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    selectedPlayers.add(
      TournamentPlayerModel(
        userId: playerData['userId'],
        name: playerData['name'],
        profileImageUrl: playerData['profileImageUrl'],
        sportRole: availableRoles.keys.first, // default role
      )
    );

    // Remove from search results
    searchResults.removeWhere((p) => p['userId'] == playerData['userId']);
  }

  void removePlayer(String userId) {
    // Don't allow removing oneself if possible, or warn
    if (userId == currentUserId) {
      Get.snackbar("Action Denied", "You cannot remove yourself from the team.", snackPosition: SnackPosition.BOTTOM);
      return;
    }
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
      // Step 1 is now Players & Roles
      if (selectedPlayers.isEmpty) {
        Get.snackbar("Validation Error", "Please add at least one player.", snackPosition: SnackPosition.BOTTOM);
        return;
      }
      currentStep.value = 2;
    } else if (currentStep.value == 2) {
      // Step 2 is now Team Basics
      if (teamNameController.text.trim().isEmpty) {
        Get.snackbar("Validation Error", "Please enter a team name.", snackPosition: SnackPosition.BOTTOM);
        return;
      }
      currentStep.value = 3;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      if (teamSize == 1 && currentStep.value == 3) {
        // For singles, going back from payment means exiting completely
        Get.back();
      } else {
        currentStep.value--;
      }
    }
  }

  Future<void> submitRegistration() async {
    if (isFree) {
      await _writeTeamToFirestore('free', null);
    } else {
      _startRazorpayPayment();
    }
  }

  void _startRazorpayPayment() {
    // Convert to paise
    final amountInPaise = (entryFeeAmount * 100).toInt();

    var options = {
      'key': _razorpayKeyId,
      'amount': amountInPaise,
      'name': tournamentData['name'] ?? 'PlayZ Tournament',
      'description': 'Team Registration Fee',
      'prefill': {
        'contact': '', // Could prefill from user data
        'email': ''
      },
      'theme': {
        'color': '#1DB954' // PlayZ Accent
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar("Payment Error", "Failed to start payment.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Ideally, verify signature on backend. Since no backend, proceed.
    Get.snackbar("Payment Successful", "Payment ID: ${response.paymentId}", snackPosition: SnackPosition.BOTTOM);
    await _writeTeamToFirestore('paid', response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      "Payment Failed",
      response.message ?? "Transaction cancelled or failed.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet Selected", "${response.walletName}", snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _writeTeamToFirestore(String paymentStatus, String? paymentId) async {
    isRegistering.value = true;
    try {
      final teamId = const Uuid().v4();
      String logoUrl = "";

      // Upload Logo
      if (teamLogoPath.value.isNotEmpty) {
        final File imageFile = File(teamLogoPath.value);
        final compressedImage = await FlutterImageCompress.compressWithFile(
          imageFile.absolute.path,
          minWidth: 512,
          minHeight: 512,
          quality: 85,
        );

        if (compressedImage != null) {
          final ref = FirebaseStorage.instance.ref().child('tournament_teams/$teamId.jpg');
          final uploadTask = await ref.putData(compressedImage, SettableMetadata(contentType: 'image/jpeg'));
          logoUrl = await uploadTask.ref.getDownloadURL();
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

      final tournamentRef = FirebaseFirestore.instance.collection('tournaments').doc(tournamentId);

      // Run as transaction to update teamCount safely
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docRef, team.toMap()..addAll({'registeredAt': FieldValue.serverTimestamp()}));
        transaction.update(tournamentRef, {'teamCount': FieldValue.increment(1)});
      });

      Get.snackbar(
        "Registration Complete!",
        "Your team has been registered successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.back(); // Pop back to detail screen
      Get.back(); // Might need to pop twice if we have a success screen, but for now just back

    } catch (e) {
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
