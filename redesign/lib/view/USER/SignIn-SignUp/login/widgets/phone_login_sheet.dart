import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/SignIn-SignUp/favorite_sports/favorite_sports_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PhoneLoginSheet extends StatefulWidget {
  const PhoneLoginSheet({super.key});

  @override
  State<PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<PhoneLoginSheet> with CodeAutoFill {
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
      debugPrint("APP SIGNATURE: $signature");
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

  void sendOTP(String phoneNumber) async {
    _startTimer();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        final user = _auth.currentUser;
        if (user != null && user.phoneNumber != null) {
          final exists = await _checkAndFetchUserDoc(user.phoneNumber!);
          if (!mounted) return;
          if (exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => UserAppNavShell()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => FavoriteSportsScreen()),
            );
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "OTP Verification failed")));
      },
      codeSent: (String verId, int? resendToken) {
        if (!mounted) return;
        setState(() {
          verificationId = verId;
          otpSent = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP Sent Successfully!")));
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  void verifyOTP() async {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter complete 6-digit OTP")));
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;
      if (!mounted) return;
      if (user != null && user.phoneNumber != null) {
        final exists = await _checkAndFetchUserDoc(user.phoneNumber!);
        if (!mounted) return;
        if (exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => UserAppNavShell()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => FavoriteSportsScreen()),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid OTP: $e")));
    }
  }

  Future<bool> _checkAndFetchUserDoc(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final bool isComplete = (data['isProfileComplete'] ?? false) == true;
        final sports = data['favoriteSports'];
        final bool hasSports = sports != null && sports is List && sports.length >= 4;

        await UserPreferences.saveDocId(docId);
        await UserPreferences.saveUserProfile(
          data['fullName'] ?? '',
          data['primaryPhone'] ?? '',
          data['primaryEmail'] ?? '',
          data['dob'] ?? '',
          data['bio'] ?? '',
          data['profileImageUrl'] ?? '',
        );
        if (sports != null && sports is List) {
          await UserPreferences.saveFavoriteSports(
            sports.map((e) => e.toString()).toList(),
          );
        }
        await UserPreferences.setPublicProfile(data['isPublicProfile'] ?? true);
        await UserPreferences.setTrainer(data['isTrainer'] ?? false);

        if (isComplete && hasSports) {
          await UserPreferences.setProfileComplete(true);
          return true;
        }
      }
      await UserPreferences.setProfileComplete(false);
      return false;
    } catch (e) {
      debugPrint('Error fetching user doc: $e');
      await UserPreferences.setProfileComplete(false);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.minDimensionPct(7)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.widthPct(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: context.widthPct(10),
              height: 4,
              margin: EdgeInsets.only(bottom: context.heightPct(2)),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
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
        Text(
          "Enter your phone number",
          style: AppTypography.headlineLg.copyWith(
            fontSize: context.responsiveFont(20),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.heightPct(0.8)),
        Text(
          "We'll send you a verification code",
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFont(13.5),
          ),
        ),
        SizedBox(height: context.heightPct(2)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: phoneController,
                autofocus: true,
                keyboardType: TextInputType.phone,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(15),
                ),
                decoration: InputDecoration(
                  hintText: "Phone number",
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(3.5),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.heightPct(2)),
        SizedBox(
          width: double.infinity,
          height: context.responsiveFont(48),
          child: ElevatedButton(
            onPressed: () {
              String phone = phoneController.text.trim();
              if (!phone.startsWith('+')) {
                phone = "+$phone";
              }
              sendOTP(phone);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spotifyGreen,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
            child: Text(
              "Send OTP",
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w800,
                fontSize: context.responsiveFont(15),
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
        Text(
          "Enter the 6-digit code",
          style: AppTypography.headlineLg.copyWith(
            fontSize: context.responsiveFont(20),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.heightPct(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: context.widthPct(11.5),
              child: TextField(
                controller: otpControllers[index],
                focusNode: otpFocusNodes[index],
                autofocus: index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                style: AppTypography.monoMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                ),
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
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      context.minDimensionPct(2.5),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: context.heightPct(2)),
        Text(
          "Resend code in ${secondsLeft ~/ 60}:${(secondsLeft % 60).toString().padLeft(2, '0')}",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFont(13),
          ),
        ),
        SizedBox(height: context.heightPct(1)),
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
            style: AppTypography.labelCaps.copyWith(
              color: secondsLeft == 0 ? AppColors.spotifyGreen : AppColors.textSecondary,
              fontSize: context.responsiveFont(12),
            ),
          ),
        ),
        SizedBox(height: context.heightPct(1)),
        SizedBox(
          width: double.infinity,
          height: context.responsiveFont(48),
          child: ElevatedButton(
            onPressed: verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spotifyGreen,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
            child: Text(
              "Verify & Continue",
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w800,
                fontSize: context.responsiveFont(15),
              ),
            ),
          ),
        ),
        SizedBox(height: context.heightPct(2)),
      ],
    );
  }
}
