import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickContactCards extends StatelessWidget {
  final VoidCallback onLiveChatTap;
  final VoidCallback onCallTap;
  final VoidCallback onRaiseTicketTap;

  const QuickContactCards({
    super.key,
    required this.onLiveChatTap,
    required this.onCallTap,
    required this.onRaiseTicketTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildContactItem(
              icon: Icons.support_agent_rounded,
              title: 'Live Chat',
              subtitle: '24/7 Support',
              color: const Color(0xFF00E676),
              onTap: onLiveChatTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildContactItem(
              icon: Icons.phone_in_talk_rounded,
              title: 'Call Us',
              subtitle: 'Mon-Sat 9-7',
              color: Colors.lightBlueAccent,
              onTap: onCallTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildContactItem(
              icon: Icons.confirmation_number_outlined,
              title: 'Raise Ticket',
              subtitle: 'Track Issue',
              color: Colors.amberAccent,
              onTap: onRaiseTicketTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
