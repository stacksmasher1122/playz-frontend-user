import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:redesign/model/user_profile_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';

class UserProfileController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final rxUser = Rxn<UserProfileModel>();
  final isLoading = false.obs;

  // Getters for easy access in UI
  String get userName => rxUser.value?.fullName ?? '';
  String get userEmail => rxUser.value?.primaryEmail ?? '';
  String get profileImageUrl => rxUser.value?.profileImageUrl ?? '';
  bool get isPublicProfile => rxUser.value?.isPublicProfile ?? true;
  String get tier => rxUser.value?.tier ?? TierHelper.getTierFromXp(rxUser.value?.xpPoints ?? 100);
  int get xpPoints => rxUser.value?.xpPoints ?? 100;
  int get zCoins => rxUser.value?.zCoins ?? 200;
  String get subscriptionStatus => rxUser.value?.subscriptionStatus ?? 'FREE';
  String get referralCode => rxUser.value?.referralCode.isNotEmpty == true
      ? rxUser.value!.referralCode
      : generateUniqueReferralCode();

  static String generateUniqueReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    final code = List.generate(6, (index) => chars[rnd.nextInt(chars.length)]).join();
    return 'PZ-$code';
  }

  Future<void> fetchUserProfile(String docId) async {
    if (docId.isEmpty) return;

    isLoading.value = true;
    try {
      final doc = await _firestore.collection('User').doc(docId).get();
      if (doc.exists && doc.data() != null) {
        var user = UserProfileModel.fromMap(doc.id, doc.data()!);
        
        // Auto assign referral code if missing
        if (user.referralCode.isEmpty) {
          final newCode = generateUniqueReferralCode();
          user = user.copyWith(referralCode: newCode);
          await _firestore.collection('User').doc(docId).set({'referralCode': newCode}, SetOptions(merge: true));
        }
        
        rxUser.value = user;

        // Sync local preferences
        await UserPreferences.saveUserProfile(
          rxUser.value!.fullName,
          rxUser.value!.secondaryPhone,
          rxUser.value!.primaryEmail,
          rxUser.value!.dob,
          rxUser.value!.bio,
          rxUser.value!.profileImageUrl,
        );
        await UserPreferences.setPublicProfile(rxUser.value!.isPublicProfile);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserProfile({
    required UserProfileModel updatedUser,
    File? imageFile,
  }) async {
    isLoading.value = true;
    try {
      String finalImageUrl = updatedUser.profileImageUrl;

      // Determine doc ID using email (if available)
      final String emailToUse = updatedUser.primaryEmail.trim().isNotEmpty
          ? updatedUser.primaryEmail.trim()
          : (FirebaseAuth.instance.currentUser?.email ?? updatedUser.docId);
      final docIdToUse = emailToUse.isNotEmpty ? emailToUse : updatedUser.docId;

      // Handle Image Upload if new file provided
      if (imageFile != null) {
        String fileName = imageFile.path.split(Platform.isWindows ? '\\' : '/').last;
        final storageRef = _storage.ref().child(
          'User/$docIdToUse/Profile/$fileName',
        );
        await storageRef.putFile(imageFile);
        finalImageUrl = await storageRef.getDownloadURL();
      }

      final refCode = updatedUser.referralCode.isNotEmpty ? updatedUser.referralCode : generateUniqueReferralCode();

      // Prepare final model with updated image URL and docId
      final userToSave = updatedUser.copyWith(
        docId: docIdToUse,
        profileImageUrl: finalImageUrl,
        referralCode: refCode,
        tier: TierHelper.getTierFromXp(updatedUser.xpPoints),
      );

      // Save to Firestore
      await _firestore
          .collection('User')
          .doc(userToSave.docId)
          .set(userToSave.toMap(), SetOptions(merge: true));

      // Update local state
      rxUser.value = userToSave;

      // Update local preferences
      await UserPreferences.saveUserProfile(
        userToSave.fullName,
        userToSave.secondaryPhone,
        userToSave.primaryEmail,
        userToSave.dob,
        userToSave.bio,
        userToSave.profileImageUrl,
      );
      await UserPreferences.setPublicProfile(userToSave.isPublicProfile);
      await UserPreferences.saveDocId(userToSave.docId);

      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addZCoins(int coinsToAdd) async {
    final current = rxUser.value;
    if (current == null) return;
    final newCoins = current.zCoins + coinsToAdd;
    final updated = current.copyWith(zCoins: newCoins);
    rxUser.value = updated;

    try {
      await _firestore.collection('User').doc(current.docId).set({'zCoins': newCoins}, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> addXp(int xpToAdd) async {
    final current = rxUser.value;
    if (current == null) return;
    final newXp = current.xpPoints + xpToAdd;
    final newTier = TierHelper.getTierFromXp(newXp);
    final updated = current.copyWith(xpPoints: newXp, tier: newTier);
    rxUser.value = updated;

    try {
      await _firestore.collection('User').doc(current.docId).set({'xpPoints': newXp, 'tier': newTier}, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> updateSubscriptionStatus(String status) async {
    final current = rxUser.value;
    if (current == null) return;
    final updated = current.copyWith(subscriptionStatus: status);
    rxUser.value = updated;

    try {
      await _firestore.collection('User').doc(current.docId).set({'subscriptionStatus': status}, SetOptions(merge: true));
    } catch (_) {}
  }

  void setUser(UserProfileModel user) {
    rxUser.value = user;
  }
}
