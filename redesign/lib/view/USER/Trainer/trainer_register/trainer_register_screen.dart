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

const Color kBg = AppColors.background;
const Color kGreen = AppColors.accent;

class TrainerJoinScreen extends StatefulWidget {
  const TrainerJoinScreen({super.key});

  @override
  State<TrainerJoinScreen> createState() => _TrainerJoinScreenState();
}

class _TrainerJoinScreenState extends State<TrainerJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  final bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            /// CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const JoinAppBar(),
                    const SizedBox(height: 20),
                    const CertifiedBanner(),
                    const SizedBox(height: 28),
                    const StepHeader(step: 1, title: 'Personal Information'),
                    const SizedBox(height: 20),
                    const ProfilePhotoUploader(),
                    const SizedBox(height: 24),

                    const TrainerInputField(
                      label: 'Full Name *',
                      initial: 'Rahul Sharma',
                    ),
                    const SizedBox(height: 16),
                    const TrainerVerifiedField(
                      label: 'Mobile Number *',
                      value: '9876543210',
                    ),
                    const SizedBox(height: 16),
                    const TrainerInputField(
                      label: 'Email Address *',
                      initial: 'rahul.sharma@example.com',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: TrainerInputField(
                            label: 'Date of Birth',
                            hint: 'DD/MM/YYYY',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TrainerDropdownField(
                            label: 'Gender',
                            value: _gender,
                            items: const ['Male', 'Female', 'Other'],
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    const StepHeader(step: 2, title: 'Professional Details'),
                    const SizedBox(height: 20),

                    /// PRIMARY SPORT
                    TrainerDropdownField(
                      label: 'Primary Sport',
                      value: 'Cricket',
                      items: const ['Cricket', 'Football', 'Fitness', 'Yoga'],
                      onChanged: (String? value) {},
                    ),

                    const SizedBox(height: 16),

                    /// SPECIALIZATION
                    const TrainerInputField(
                      label: 'Specialization',
                      hint: 'e.g. Batting Coach, Pace Bowling',
                    ),

                    const SizedBox(height: 16),

                    /// CURRENT ACADEMY (OPTIONAL)
                    const TrainerInputField(
                      label: 'Current Academy / Club (Optional)',
                      hint: 'e.g. PowerPlay Academy',
                    ),

                    const SizedBox(height: 16),

                    /// EXPERIENCE
                    const TrainerInputField(
                      label: 'Years of Experience',
                      hint: 'e.g. 5',
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    /// SHORT BIO
                    const TrainerBioField(),

                    const SizedBox(height: 20),
                    const CertificationsSection(),

                    const SizedBox(height: 32),
                    const CoachingPreferencesSection(),
                    const SizedBox(height: 32),
                    const AvailabilitySection(),
                    const SizedBox(height: 32),
                    const PricingPackagesSection(),
                    const SizedBox(height: 32),
                    const LocationInfraSection(),
                    const SizedBox(height: 32),
                    const IdentityVerificationSection(),
                    const SizedBox(height: 32),
                    const PayoutDetailsSection(),
                    const SizedBox(height: 32),
                    const AgreementsSection(),

                    const SizedBox(height: 120),

                    /// CTA
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _isValid
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TrainerProAccessScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
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
