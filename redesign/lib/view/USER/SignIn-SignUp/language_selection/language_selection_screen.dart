import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../profile_setup/profile_setup_screen.dart';

class LanguageOption {
  final String name;
  final String nativeName;
  final String code;
  final String subtext;

  const LanguageOption({
    required this.name,
    required this.nativeName,
    required this.code,
    required this.subtext,
  });
}

class LanguageSelectionScreen extends StatefulWidget {
  final List<String> selectedSports;

  const LanguageSelectionScreen({
    super.key,
    required this.selectedSports,
  });

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  static const List<LanguageOption> _languages = [
    LanguageOption(name: 'English', nativeName: 'English', code: 'en', subtext: 'Default'),
    LanguageOption(name: 'Hindi', nativeName: 'हिंदी', code: 'hi', subtext: 'Hindi'),
    LanguageOption(name: 'Marathi', nativeName: 'मराठी', code: 'mr', subtext: 'Marathi'),
    LanguageOption(name: 'Tamil', nativeName: 'தமிழ்', code: 'ta', subtext: 'Tamil'),
    LanguageOption(name: 'Telugu', nativeName: 'తెలుగు', code: 'te', subtext: 'Telugu'),
    LanguageOption(name: 'Kannada', nativeName: 'ಕನ್ನಡ', code: 'kn', subtext: 'Kannada'),
    LanguageOption(name: 'Gujarati', nativeName: 'ગુજરાતી', code: 'gu', subtext: 'Gujarati'),
    LanguageOption(name: 'Bengali', nativeName: 'বাংলা', code: 'bn', subtext: 'Bengali'),
  ];

  String _selectedLanguageCode = 'en';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final saved = await UserPreferences.getPreferredLanguage();
    final match = _languages.firstWhere(
      (l) => l.name.toLowerCase() == saved.toLowerCase() || l.code.toLowerCase() == saved.toLowerCase(),
      orElse: () => _languages.first,
    );
    if (mounted) {
      setState(() {
        _selectedLanguageCode = match.code;
      });
    }
  }

  Future<void> _onContinue() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final selectedObj = _languages.firstWhere(
        (l) => l.code == _selectedLanguageCode,
        orElse: () => _languages.first,
      );

      // 1. Save to SharedPreferences
      await UserPreferences.setPreferredLanguage(selectedObj.name);

      // 2. Save to Firebase Firestore if logged in docId exists
      final docId = await UserPreferences.getDocId();
      if (docId != null && docId.trim().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(docId)
            .set({
              'preferredLanguage': selectedObj.name,
              'languageCode': selectedObj.code,
              'lastLanguageUpdated': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('🔴 [LanguageSelection] Firebase update error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        // 3. Proceed to Profile Setup
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileSetupScreen(selectedSports: widget.selectedSports),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
        title: Column(
          children: [
            Text(
              'STEP 2 OF 3',
              style: AppTypography.labelCaps10.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(11),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(0.8)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step 1 Completed
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(7),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: context.widthPct(1)),
                // Step 2 Active
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(7),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: context.widthPct(1)),
                // Step 3 Next
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(7),
                  decoration: BoxDecoration(
                    color: AppColors.borderDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Description
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(5),
                vertical: context.heightPct(1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select App Language',
                    style: AppTypography.displayLg.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(22),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  Text(
                    'Choose your preferred language for localized navigation and content.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Language Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(5),
                  vertical: context.heightPct(1),
                ),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: context.widthPct(3.5),
                  mainAxisSpacing: context.heightPct(1.8),
                ),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = lang.code == _selectedLanguageCode;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguageCode = lang.code;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(context.widthPct(3.5)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.surfaceEmerald
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.borderDark,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.subtext,
                                style: AppTypography.bodySm.copyWith(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.muted,
                                  fontSize: context.responsiveFont(12),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.borderDark,
                                size: context.responsiveFont(18),
                              ),
                            ],
                          ),
                          Text(
                            lang.nativeName,
                            style: AppTypography.headlineSm.copyWith(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: context.responsiveFont(18),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Continue Button
            Container(
              padding: EdgeInsets.fromLTRB(
                context.widthPct(5),
                context.heightPct(1.5),
                context.widthPct(5),
                context.heightPct(2),
              ),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.borderDark)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: context.heightPct(6.5).clamp(48.0, 56.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    elevation: 4,
                    shadowColor: AppColors.accent.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isSaving ? null : _onContinue,
                  child: _isSaving
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.background,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: AppTypography.bodyLg.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(16),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
