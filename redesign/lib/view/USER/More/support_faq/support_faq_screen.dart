import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/More_Controller/support_faq_controller.dart';
import 'widgets/quick_contact_cards.dart';
import 'widgets/faq_search_bar.dart';
import 'widgets/faq_category_chips.dart';
import 'widgets/faq_accordion_item.dart';
import 'widgets/raise_ticket_bottom_sheet.dart';

class SupportFaqScreen extends StatelessWidget {
  const SupportFaqScreen({super.key});

  Future<void> _makePhoneCall() async {
    final uri = Uri.parse('tel:+919876543210');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.support_agent_rounded, color: Color(0xFF00E676), size: 24),
            const SizedBox(width: 10),
            Text(
              'Live Chat Support',
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          'Connecting to PlayZ Live Support Executive...\nAverage wait time: < 1 min',
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Start Chat', style: GoogleFonts.inter(color: const Color(0xFF00E676), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showRaiseTicket(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const RaiseTicketBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<SupportFaqController>()
        ? Get.find<SupportFaqController>()
        : Get.put(SupportFaqController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Support & FAQ',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          QuickContactCards(
            onLiveChatTap: () => _showLiveChatDialog(context),
            onCallTap: _makePhoneCall,
            onRaiseTicketTap: () => _showRaiseTicket(context),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: GoogleFonts.inter(
                color: const Color(0xFF00E676),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),

          FaqSearchBar(
            onChanged: (q) => controller.searchQuery.value = q,
          ),

          Obx(() {
            return FaqCategoryChips(
              categories: controller.categories,
              selectedCategory: controller.selectedCategory.value,
              onSelected: (cat) => controller.selectedCategory.value = cat,
            );
          }),

          const SizedBox(height: 10),

          Obx(() {
            final items = controller.filteredFaqs;
            if (items.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, color: Colors.white38, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No matching FAQs found',
                      style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return FaqAccordionItem(
                  item: item,
                  onToggle: () => controller.toggleExpand(item.id),
                  onVote: (isHelpful) => controller.voteHelpful(item.id, isHelpful),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
