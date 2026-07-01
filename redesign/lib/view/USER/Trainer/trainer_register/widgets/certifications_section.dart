import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class CertificationsSection extends StatelessWidget {
  CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        StepHeader(step: 3, title: 'Certifications'),

        SizedBox(height: 12),

        /// TRUST INFO CARD
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            border: Border(left: BorderSide(color: kGreen, width: 3)),
          ),
          child: Text(
            'Adding valid certifications increases your profile trust score by 40%.',
            style: TextStyle(color: kMuted, fontSize: ResponsiveHelper.sp(13), height: 1.4),
          ),
        ),

        SizedBox(height: 20),

        /// ISSUING AUTHORITY
        TrainerInputField(
          label: 'Issuing Authority',
          hint: 'e.g. BCCI, ICC, NSNIS',
        ),

        SizedBox(height: 20),

        /// UPLOAD CERTIFICATE
        UploadCertificateCard(),

        SizedBox(height: 14),

        /// UPLOADED FILE PREVIEW
        UploadedCertificateTile(
          fileName: 'BCCI Level 1.pdf',
          fileSize: '1.2 MB',
        ),
      ],
    );
  }
}

class UploadCertificateCard extends StatelessWidget {
  UploadCertificateCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      onTap: () {
        // TODO: open file picker
      },
      child: Container(
        height: ResponsiveHelper.h(120),
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: kGreen, size: 32),
            SizedBox(height: 10),
            Text(
              'Upload Certificate',
              style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
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

  UploadedCertificateTile({
    super.key,
    required this.fileName,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(12)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Row(
        children: [
          /// FILE ICON
          Container(
            width: ResponsiveHelper.w(38),
            height: ResponsiveHelper.h(38),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            ),
            child: Icon(
              Icons.insert_drive_file_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          SizedBox(width: 12),

          /// FILE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  fileSize,
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),

          /// DELETE
          InkWell(
            onTap: () {
              // TODO: remove file
            },
            child: Icon(
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
