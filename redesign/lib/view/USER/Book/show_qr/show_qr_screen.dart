import 'package:flutter/material.dart';

import 'widgets/qr_action_buttons.dart';
import 'widgets/qr_booking_card.dart';
import 'widgets/qr_instructions_note.dart';
import 'widgets/qr_support_footer.dart';
import 'widgets/qr_top_bar.dart';
import 'widgets/qr_venue_info_card.dart';

const kBg = Colors.black;

class ShowQrScreen extends StatelessWidget {
  const ShowQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QrTopBar(),
              const SizedBox(height: 20),
              QrBookingCard(size: size),
              const SizedBox(height: 20),
              const QrInstructionsNote(),
              const SizedBox(height: 16),
              const QrVenueInfoCard(),
              const SizedBox(height: 20),
              QrActionButtons(
                onDownload: () {},
                onSave: () {},
              ),
              const SizedBox(height: 24),
              const QrSupportFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
