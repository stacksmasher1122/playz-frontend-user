import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Trainer/trainer_pro_access/trainer_pro_access_screen.dart';

// Widgets
import 'widgets/join_app_bar.dart';
import 'widgets/certified_banner.dart';
import 'widgets/step_header.dart';
import 'widgets/profile_photo_uploader.dart';
import 'widgets/trainer_form_fields.dart';
import 'widgets/certifications_section.dart';
import 'widgets/coaching_preferences_section.dart';
import 'widgets/availability_section.dart';
import 'widgets/pricing_packages_section.dart';
import 'widgets/location_infra_section.dart';
import 'widgets/identity_verification_section.dart';
import 'widgets/payout_details_section.dart';
import 'widgets/agreements_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = AppColors.background;
Color kGreen = AppColors.accent;

class TrainerJoinScreen extends StatefulWidget {
  TrainerJoinScreen({super.key});

  @override
  State<TrainerJoinScreen> createState() => _TrainerJoinScreenState();
}

class _TrainerJoinScreenState extends State<TrainerJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  final bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            /// CONTENT
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 140),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JoinAppBar(),
                    SizedBox(height: 20),
                    CertifiedBanner(),
                    SizedBox(height: 28),
                    StepHeader(step: 1, title: 'Personal Information'),
                    SizedBox(height: 20),
                    ProfilePhotoUploader(),
                    SizedBox(height: 24),

                    TrainerInputField(
                      label: 'Full Name *',
                      initial: 'Rahul Sharma',
                    ),
                    SizedBox(height: 16),
                    TrainerVerifiedField(
                      label: 'Mobile Number *',
                      value: '9876543210',
                    ),
                    SizedBox(height: 16),
                    TrainerInputField(
                      label: 'Email Address *',
                      initial: 'rahul.sharma@example.com',
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TrainerInputField(
                            label: 'Date of Birth',
                            hint: 'DD/MM/YYYY',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TrainerDropdownField(
                            label: 'Gender',
                            value: _gender,
                            items: ['Male', 'Female', 'Other'],
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),
                    StepHeader(step: 2, title: 'Professional Details'),
                    SizedBox(height: 20),

                    /// PRIMARY SPORT
                    TrainerDropdownField(
                      label: 'Primary Sport',
                      value: 'Cricket',
                      items: ['Cricket', 'Football', 'Fitness', 'Yoga'],
                      onChanged: (String? value) {},
                    ),

                    SizedBox(height: 16),

                    /// SPECIALIZATION
                    TrainerInputField(
                      label: 'Specialization',
                      hint: 'e.g. Batting Coach, Pace Bowling',
                    ),

                    SizedBox(height: 16),

                    /// CURRENT ACADEMY (OPTIONAL)
                    TrainerInputField(
                      label: 'Current Academy / Club (Optional)',
                      hint: 'e.g. PowerPlay Academy',
                    ),

                    SizedBox(height: 16),

                    /// EXPERIENCE
                    TrainerInputField(
                      label: 'Years of Experience',
                      hint: 'e.g. 5',
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 16),

                    /// SHORT BIO
                    TrainerBioField(),

                    SizedBox(height: 20),
                    CertificationsSection(),

                    SizedBox(height: 32),
                    CoachingPreferencesSection(),
                    SizedBox(height: 32),
                    AvailabilitySection(),
                    SizedBox(height: 32),
                    PricingPackagesSection(),
                    SizedBox(height: 32),
                    LocationInfraSection(),
                    SizedBox(height: 32),
                    IdentityVerificationSection(),
                    SizedBox(height: 32),
                    PayoutDetailsSection(),
                    SizedBox(height: 32),
                    AgreementsSection(),

                    SizedBox(height: 120),

                    /// CTA
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _isValid
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TrainerProAccessScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        foregroundColor: Colors.black,
                        minimumSize: Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
