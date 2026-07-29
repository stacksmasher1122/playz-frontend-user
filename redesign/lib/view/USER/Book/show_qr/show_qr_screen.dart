import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/qr_action_buttons.dart';
import 'widgets/qr_booking_card.dart';
import 'widgets/qr_instructions_note.dart';
import 'widgets/qr_support_footer.dart';
import 'widgets/qr_top_bar.dart';
import 'widgets/qr_venue_info_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ShowQrScreen extends StatelessWidget {
  const ShowQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(4),
            context.heightPct(2),
            context.widthPct(4),
            context.heightPct(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QrTopBar(),
              SizedBox(height: context.heightPct(2.5)),
              QrBookingCard(size: size),
              SizedBox(height: context.heightPct(2.5)),
              const QrInstructionsNote(),
              SizedBox(height: context.heightPct(2)),
              const QrVenueInfoCard(),
              SizedBox(height: context.heightPct(2.5)),
              QrActionButtons(
                onDownload: () {},
                onSave: () {},
              ),
              SizedBox(height: context.heightPct(3)),
              const QrSupportFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
