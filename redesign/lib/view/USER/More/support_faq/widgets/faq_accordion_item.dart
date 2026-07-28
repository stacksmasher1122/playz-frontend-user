import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/model/User_Models/More_Models/support_faq_model.dart';

class FaqAccordionItem extends StatelessWidget {
  final FaqItemModel item;
  final VoidCallback onToggle;
  final Function(bool) onVote;

  const FaqAccordionItem({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isExpanded ? const Color(0xFF00E676).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onToggle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              item.question,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              item.isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: item.isExpanded ? const Color(0xFF00E676) : Colors.white54,
            ),
          ),
          if (item.isExpanded) ...[
            const Divider(color: Colors.white10, height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.answer,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Was this helpful?',
                        style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => onVote(true),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_up_alt_outlined, color: Color(0xFF00E676), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${item.helpfulCount}',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onVote(false),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_down_alt_outlined, color: Colors.white38, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${item.unhelpfulCount}',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
