// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared_preferences/userPreferences.dart';
import '../../model/User_Models/registerModel.dart';
import '../../services/global_groups_service.dart';

class RegisterController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Explicit configuration for Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  bool isLoading = false;
  String? errorMessage;

  Future<void> _initGoogleSignIn() async {
    if (!_isGoogleSignInInitialized) {
      try {
        await _googleSignIn.initialize(
          serverClientId:
              '417431238048-hr28olg4hk5qgcv6e1tat9bntoqkfa80.apps.googleusercontent.com',
        );
      } catch (e) {
        debugPrint('⚠️ GoogleSignIn initialize warning: $e');
      }
      _isGoogleSignInInitialized = true;
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// EMAIL REGISTER
  Future<bool> registerWithEmail(RegisterModel user) async {
    try {
      setLoading(true);
      errorMessage = null;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      await credential.user?.updateDisplayName(user.name);

      await UserPreferences.saveUserLogin(true, user.name, user.email);
      await UserPreferences.saveDocId(user.email);

      // Run background group check asynchronously so login UI is not blocked
      unawaited(
        GlobalGroupsService.checkAndJoinAllUserGroups(
          targetDocId: user.email,
        ),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔴 [RegisterController] FirebaseAuthException: ${e.code} - ${e.message}',
      );
      errorMessage = e.message ?? "An error occurred during registration";
      return false;
    } catch (e, stackTrace) {
      debugPrint('🔴 [RegisterController] registerWithEmail error: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// EMAIL LOGIN
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      setLoading(true);
      errorMessage = null;

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        final emailToUse = (user.email != null && user.email!.isNotEmpty)
            ? user.email!
            : email;
        await UserPreferences.saveUserLogin(
          true,
          user.displayName ?? "User",
          emailToUse,
        );
        await UserPreferences.saveDocId(emailToUse);

        // Run background group check asynchronously so login UI is not blocked
        unawaited(
          GlobalGroupsService.checkAndJoinAllUserGroups(
            targetDocId: emailToUse,
          ),
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔴 [RegisterController] FirebaseAuthException: ${e.code} - ${e.message}',
      );
      errorMessage = e.message ?? "An error occurred during login";
      return false;
    } catch (e, stackTrace) {
      debugPrint('🔴 [RegisterController] loginWithEmail error: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// GOOGLE LOGIN (v7.2 API)
  Future<bool> loginWithGoogle() async {
    try {
      setLoading(true);
      errorMessage = null;

      // 1. Force clear any cached Google/Firebase session so Google issues a fresh ID Token
      try {
        await _googleSignIn.disconnect();
      } catch (_) {}
      try {
        await _auth.signOut();
      } catch (_) {}

      await _initGoogleSignIn();

      // 2. Request fresh Google authentication
      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      /// Get fresh Google authentication tokens
      final GoogleSignInAuthentication googleAuth = account.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        debugPrint('🔴 [RegisterController] No Google ID token received.');
        errorMessage = 'Failed to retrieve authentication token from Google.';
        return false;
      }

      /// 3. Pass fresh ID token immediately to Firebase Credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final emailToUse = user.email ?? "";
        await UserPreferences.saveUserLogin(
          true,
          user.displayName ?? "User",
          emailToUse,
        );
        if (emailToUse.isNotEmpty) {
          await UserPreferences.saveDocId(emailToUse);
          unawaited(
            GlobalGroupsService.checkAndJoinAllUserGroups(
              targetDocId: emailToUse,
            ),
          );
        }

        return true;
      }

      return false;
    } catch (e, stackTrace) {
      debugPrint('🔴 [RegisterController] loginWithGoogle error: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// SIGN OUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      debugPrint('⚠️ [RegisterController] SignOut warning: $e');
    }
    await UserPreferences.clearUser();
  }
}


