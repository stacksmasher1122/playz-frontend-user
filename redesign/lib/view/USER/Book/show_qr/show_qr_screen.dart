import 'package:flutter/material.dart';

import 'widgets/qr_action_buttons.dart';
import 'widgets/qr_booking_card.dart';
import 'widgets/qr_instructions_note.dart';
import 'widgets/qr_support_footer.dart';
import 'widgets/qr_top_bar.dart';
import 'widgets/qr_venue_info_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = Colors.black;

class ShowQrScreen extends StatelessWidget {
  ShowQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 50, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QrTopBar(),
              SizedBox(height: 20),
              QrBookingCard(size: size),
              SizedBox(height: 20),
              QrInstructionsNote(),
              SizedBox(height: 16),
              QrVenueInfoCard(),
              SizedBox(height: 20),
              QrActionButtons(
                onDownload: () {},
                onSave: () {},
              ),
              SizedBox(height: 24),
              QrSupportFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
