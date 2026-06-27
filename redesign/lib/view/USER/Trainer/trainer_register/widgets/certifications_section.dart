import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        const StepHeader(step: 3, title: 'Certifications'),

        const SizedBox(height: 12),

        /// TRUST INFO CARD
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(14),
            border: const Border(left: BorderSide(color: kGreen, width: 3)),
          ),
          child: const Text(
            'Adding valid certifications increases your profile trust score by 40%.',
            style: TextStyle(color: kMuted, fontSize: 13, height: 1.4),
          ),
        ),

        const SizedBox(height: 20),

        /// ISSUING AUTHORITY
        const TrainerInputField(
          label: 'Issuing Authority',
          hint: 'e.g. BCCI, ICC, NSNIS',
        ),

        const SizedBox(height: 20),

        /// UPLOAD CERTIFICATE
        const UploadCertificateCard(),

        const SizedBox(height: 14),

        /// UPLOADED FILE PREVIEW
        const UploadedCertificateTile(
          fileName: 'BCCI Level 1.pdf',
          fileSize: '1.2 MB',
        ),
      ],
    );
  }
}

class UploadCertificateCard extends StatelessWidget {
  const UploadCertificateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // TODO: open file picker
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined, color: kGreen, size: 32),
            SizedBox(height: 10),
            const Text(
              'Upload Certificate',
              style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            const Text(
              'PDF or JPG (Max 5MB)',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadedCertificateTile extends StatelessWidget {
  final String fileName;
  final String fileSize;

  const UploadedCertificateTile({
    super.key,
    required this.fileName,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// FILE ICON
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.insert_drive_file_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          /// FILE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fileSize,
                  style: const TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),

          /// DELETE
          InkWell(
            onTap: () {
              // TODO: remove file
            },
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
