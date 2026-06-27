import 'package:flutter/material.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';

const kMuted = Color(0xFFA7A7A7);

class PayoutDetailsSection extends StatefulWidget {
  const PayoutDetailsSection({super.key});

  @override
  State<PayoutDetailsSection> createState() => _PayoutDetailsSectionState();
}

class _PayoutDetailsSectionState extends State<PayoutDetailsSection> {
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  @override
  void dispose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        const StepHeader(step: 8, title: 'Payout Details'),

        const SizedBox(height: 6),

        const Text(
          'Used to transfer your earnings securely',
          style: TextStyle(color: kMuted, fontSize: 12.5),
        ),

        const SizedBox(height: 16),

        /// ───────── ACCOUNT HOLDER NAME ─────────
        TrainerInputField(
          label: 'Account Holder Name',
          hint: 'As per bank records',
          controller: accountNameController,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 12),

        /// ───────── ACCOUNT NUMBER ─────────
        TrainerInputField(
          label: 'Account Number',
          hint: 'Enter account number',
          controller: accountNumberController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 12),

        /// ───────── IFSC CODE ─────────
        TrainerInputField(
          label: 'IFSC Code',
          hint: 'e.g. HDFC0001234',
          controller: ifscController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),

        const SizedBox(height: 10),

        /// ───────── SECURITY NOTE ─────────
        Row(
          children: const [
            Icon(Icons.lock_outline, size: 14, color: kMuted),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Your bank details are encrypted and only used for payouts.',
                style: TextStyle(color: kMuted, fontSize: 11.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
