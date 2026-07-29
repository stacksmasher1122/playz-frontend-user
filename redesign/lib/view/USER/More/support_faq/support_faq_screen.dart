import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        ),
        title: Row(
          children: [
            const Icon(Icons.support_agent_rounded, color: AppColors.accent, size: 24),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: Text(
                'Live Chat Support',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(16),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          'Connecting to PlayZ Live Support Executive...\nAverage wait time: < 1 min',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Start Chat',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            ),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Support & FAQ',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(18),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: context.heightPct(5)),
        children: [
          QuickContactCards(
            onLiveChatTap: () => _showLiveChatDialog(context),
            onCallTap: _makePhoneCall,
            onRaiseTicketTap: () => _showRaiseTicket(context),
          ),
          SizedBox(height: context.heightPct(1.5)),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(0.5),
            ),
            child: Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: AppTypography.labelCaps10.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(12),
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

          SizedBox(height: context.heightPct(1.2)),

          Obx(() {
            final items = controller.filteredFaqs;
            if (items.isEmpty) {
              return Container(
                padding: EdgeInsets.all(context.widthPct(8)),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, color: AppColors.muted, size: 48),
                    SizedBox(height: context.heightPct(1.5)),
                    Text(
                      'No matching FAQs found',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(14),
                      ),
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
