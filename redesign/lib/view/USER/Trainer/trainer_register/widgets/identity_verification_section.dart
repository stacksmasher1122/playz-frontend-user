import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);
const kSurface = Color(0xFF0E0E0E);

class IdentityVerificationSection extends StatefulWidget {
  IdentityVerificationSection({super.key});

  @override
  State<IdentityVerificationSection> createState() =>
      _IdentityVerificationSectionState();
}

class _IdentityVerificationSectionState
    extends State<IdentityVerificationSection> {
  String selectedIdType = 'Aadhaar Card';
  final TextEditingController idNumberController = TextEditingController();

  String? frontImage;
  String? backImage;
  String? selfieImage;

  @override
  void dispose() {
    idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        StepHeader(step: 7, title: 'Identity Verification'),

        SizedBox(height: 16),

        /// ───────── GOVERNMENT ID TYPE ─────────
        Text(
          'Government ID Type',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        SizedBox(height: 8),

        TrainerDropdownField(
          label: 'ID Type',
          value: selectedIdType,
          items: [
            'Aadhaar Card',
            'PAN Card',
            'Passport',
            'Driving License',
          ],
          onChanged: (v) {
            if (v != null) {
              setState(() => selectedIdType = v);
            }
          },
        ),

        SizedBox(height: 14),

        /// ───────── ID NUMBER ─────────
        TrainerInputField(
          label: 'ID Number',
          hint: 'XXXX-XXXX-XXXX',
          keyboardType: TextInputType.text,
          controller: idNumberController,
        ),

        SizedBox(height: 18),

        /// ───────── FRONT / BACK UPLOAD ─────────
        Row(
          children: [
            Expanded(
              child: IDUploadCard(
                label: 'Front Side',
                icon: Icons.badge_outlined,
                image: frontImage,
                onTap: () {
                  // TODO: pick front image
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: IDUploadCard(
                label: 'Back Side',
                icon: Icons.badge_outlined,
                image: backImage,
                onTap: () {
                  // TODO: pick back image
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 18),

        /// ───────── SELFIE WITH ID ─────────
        Text(
          'Selfie with ID',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        SizedBox(height: 10),

        SelfieCard(
          image: selfieImage,
          onTap: () {
            // TODO: open camera
          },
        ),

        SizedBox(height: 10),

        /// ───────── SECURITY NOTE ─────────
        Row(
          children: [
            Icon(Icons.lock_outline, size: 14, color: kMuted),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Your ID is securely stored and only used for verification.',
                style: TextStyle(color: kMuted, fontSize: 11.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class IDUploadCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? image;
  final VoidCallback onTap;

  IDUploadCard({
    super.key,
    required this.label,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
        child: Container(
          height: ResponsiveHelper.h(96),
          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            border: Border.all(color: kMuted.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 22),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(12.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelfieCard extends StatelessWidget {
  final String? image;
  final VoidCallback onTap;

  SelfieCard({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          child: Row(
            children: [
              Container(
                width: ResponsiveHelper.w(42),
                height: ResponsiveHelper.h(42),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGreen.withValues(alpha: 0.15),
                ),
                child: Icon(Icons.camera_alt_outlined, color: kGreen),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Take a Selfie',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Hold your ID card near your face',
                      style: TextStyle(color: kMuted, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
