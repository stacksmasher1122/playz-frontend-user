import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';

class MyTrainersSection extends StatelessWidget {
  const MyTrainersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 8),

          /// HEADER
          Row(
            children: [
              Text(
                'My Trainers',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'Active & recent coaches',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// FILTER CHIPS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterButton(
                label: 'Active packages',
                icon: Icons.local_fire_department,
                active: true,
                onTap: () {},
              ),
              _FilterButton(label: 'Cricket', active: false, onTap: () {}),
              _FilterButton(label: 'Football', active: false, onTap: () {}),
              _FilterButton(label: 'Online', active: false, onTap: () {}),
            ],
          ),

          const SizedBox(height: 14),

          /// TRAINER CARD
          const _MyTrainerCard(),
        ]),
      ),
    );
  }
}

class _MyTrainerCard extends StatelessWidget {
  const _MyTrainerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.surface,
                child: Text(
                  'Trainer',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rahul Sharma',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _statusPill('Active Package'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Strength & Conditioning  •  8+ yrs',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star, size: 14, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text('4.8', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TAGS
          Wrap(
            spacing: 6,
            children: const [
              _Tag('Baner • Pune'),
              _Tag('Adults'),
              _Tag('Pro Athletes'),
              _Tag('Certified'),
            ],
          ),

          const SizedBox(height: 12),

          /// PROGRESS BAR
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 4 / 8,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 4,
              ),
              const SizedBox(height: 4),
              Text(
                '4 / 8 sessions completed',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('View Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColors.accent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: active ? 1 : 0.98,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.accent.withOpacity(0.2),
          highlightColor: AppColors.accent.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: active
                    ? AppColors.accent
                    : Colors.white.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: active ? AppColors.accent : Colors.white,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.accent : Colors.white,
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
