import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class AgreementsSection extends StatefulWidget {
  const AgreementsSection({super.key});

  @override
  State<AgreementsSection> createState() => _AgreementsSectionState();
}

class _AgreementsSectionState extends State<AgreementsSection> {
  bool agreeTerms = true;
  bool agreeMarketing = true;
  bool agreeResponse = false;

  bool get canProceed => agreeTerms && agreeMarketing && agreeResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        const StepHeader(step: 9, title: 'Agreements'),

        const SizedBox(height: 14),

        /// ───────── AGREEMENT LIST ─────────
        AgreementTile(
          value: agreeTerms,
          onChanged: (v) => setState(() => agreeTerms = v),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        AgreementTile(
          value: agreeMarketing,
          onChanged: (v) => setState(() => agreeMarketing = v),
          child: const Text(
            'I consent to the use of my profile photos for marketing purposes.',
            style: TextStyle(color: Colors.white, fontSize: 13.5, height: 1.5),
          ),
        ),

        const SizedBox(height: 10),

        AgreementTile(
          value: agreeResponse,
          onChanged: (v) => setState(() => agreeResponse = v),
          child: const Text(
            'I agree to respond to user inquiries within 24 hours.',
            style: TextStyle(color: Colors.white, fontSize: 13.5, height: 1.5),
          ),
        ),

        const SizedBox(height: 14),

        /// ───────── NOTE ─────────
        Row(
          children: const [
            Icon(Icons.info_outline, size: 14, color: kMuted),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'These agreements are mandatory to activate your trainer profile.',
                style: TextStyle(color: kMuted, fontSize: 11.5),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// OPTIONAL: expose validation state
        if (!canProceed)
          const Text(
            'Please accept all agreements to continue.',
            style: TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
      ],
    );
  }
}

class AgreementTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;

  const AgreementTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, -2),
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: kGreen,
              checkColor: Colors.black,
              side: const BorderSide(color: kMuted),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(child: child),
        ],
      ),
    );
  }
}
