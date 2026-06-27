import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/SignIn-SignUp/favorite_sports/favorite_sports_screen.dart';

class PhoneLoginSheet extends StatefulWidget {
  const PhoneLoginSheet({super.key});

  @override
  State<PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<PhoneLoginSheet> with CodeAutoFill {
  static const kSurface = Color(0xFF0E0E0E);
  static const kCard = Color(0xFF1A1A1A);
  static const kMuted = Color(0xFFA7A7A7);
  static const kSpotifyGreen = Color(0xFF1DB954);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController(
    text: '+91',
  );
  String verificationId = "";

  bool otpSent = false;
  List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  int secondsLeft = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    listenForCode();
    SmsAutoFill().getAppSignature.then((signature) {
      print("APP SIGNATURE: $signature");
    });

    for (int i = 0; i < 6; i++) {
      otpFocusNodes[i].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          if (otpControllers[i].text.isEmpty && i > 0) {
            otpFocusNodes[i - 1].requestFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      for (int i = 0; i < 6; i++) {
        otpControllers[i].text = code![i];
      }
      setState(() {});
      Future.delayed(const Duration(milliseconds: 200), () {
        verifyOTP();
      });
    }
  }

  void _startTimer() {
    secondsLeft = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        timer.cancel();
      } else {
        if (mounted) setState(() => secondsLeft--);
      }
    });
  }

  Future<void> sendOTP(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);

        await UserPreferences.saveUserLogin(
          true,
          "User",
          phoneController.text.trim(),
        );

        if (mounted) {
          final docId = phoneController.text.trim();
          final exists = await _checkAndFetchPhoneUserDoc(docId);
          Navigator.pop(context); // Close sheet
          if (exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UserAppNavShell()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
            );
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Verification failed")),
          );
        }
      },
      codeSent: (String verId, int? resendToken) async {
        if (mounted) {
          setState(() {
            verificationId = verId;
            otpSent = true;
          });
          _startTimer();
          listenForCode();
        }
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOTP() async {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) return;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      await UserPreferences.saveUserLogin(
        true,
        "User",
        phoneController.text.trim(),
      );

      if (!mounted) return;
      final docId = phoneController.text.trim();
      final exists = await _checkAndFetchPhoneUserDoc(docId);
      Navigator.pop(context); // Close sheet

      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    }
  }

  Future<bool> _checkAndFetchPhoneUserDoc(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        await UserPreferences.saveDocId(docId);
        await UserPreferences.saveUserProfile(
          data['fullName'] ?? '',
          data['primaryPhone'] ?? '',
          data['primaryEmail'] ?? '',
          data['dob'] ?? '',
          data['bio'] ?? '',
          data['profileImageUrl'] ?? '',
        );
        final sports = data['favoriteSports'];
        if (sports != null && sports is List) {
          await UserPreferences.saveFavoriteSports(
            sports.map((e) => e.toString()).toList(),
          );
        }
        await UserPreferences.setPublicProfile(data['isPublicProfile'] ?? true);
        await UserPreferences.setTrainer(data['isTrainer'] ?? false);
        await UserPreferences.setProfileComplete(true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error fetching user doc: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            otpSent ? _buildOTPUI() : _buildPhoneUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Enter your phone number",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          "We'll send you a verification code",
          style: TextStyle(color: kMuted),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: phoneController,
                autofocus: true,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Phone number",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: kCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              String phone = phoneController.text.trim();
              if (!phone.startsWith('+')) {
                phone = "+$phone";
              }
              sendOTP(phone);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Send OTP",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Enter the 6-digit code",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextField(
                controller: otpControllers[index],
                focusNode: otpFocusNodes[index],
                autofocus: index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value.length > 1) {
                    int pasteLength = value.length;
                    for (int i = 0; i < pasteLength && (index + i) < 6; i++) {
                      otpControllers[index + i].text = value[i];
                    }
                    if (index + pasteLength < 6) {
                      otpFocusNodes[index + pasteLength].requestFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                    setState(() {});
                    if (otpControllers.every((c) => c.text.isNotEmpty)) {
                      Future.delayed(const Duration(milliseconds: 200), () {
                        verifyOTP();
                      });
                    }
                    return;
                  }
                  if (value.isNotEmpty && index < 5) {
                    otpFocusNodes[index + 1].requestFocus();
                  }
                  if (value.isEmpty && index > 0) {
                    otpFocusNodes[index - 1].requestFocus();
                  }
                  if (otpControllers.every((c) => c.text.isNotEmpty)) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      verifyOTP();
                    });
                  }
                },
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: kCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Text(
          "Resend code in ${secondsLeft ~/ 60}:${(secondsLeft % 60).toString().padLeft(2, '0')}",
          style: const TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: secondsLeft == 0
              ? () {
                  setState(() {
                    secondsLeft = 120;
                  });
                  for (var c in otpControllers) {
                    c.clear();
                  }
                  String phone = phoneController.text.trim();
                  if (!phone.startsWith('+')) phone = "+$phone";
                  sendOTP(phone);
                }
              : null,
          child: Text(
            "RESEND CODE",
            style: TextStyle(color: secondsLeft == 0 ? kSpotifyGreen : kMuted),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Verify & Continue",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
