import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MyTrainersSection extends StatelessWidget {
  MyTrainersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: 8),

          /// HEADER
          Row(
            children: [
              Text(
                'My Trainers',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                'Active & recent coaches',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),

          SizedBox(height: 12),

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

          SizedBox(height: 14),

          /// TRAINER CARD
          _MyTrainerCard(),
        ]),
      ),
    );
  }
}

class _MyTrainerCard extends StatelessWidget {
  _MyTrainerCard();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(color: AppColors.accent.withValues(alpha: 0.15), blurRadius: 12),
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
                  style: GoogleFonts.inter(fontSize: ResponsiveHelper.sp(10), color: Colors.white),
                ),
              ),
              SizedBox(width: 12),
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
                        SizedBox(width: 6),
                        _statusPill('Active Package'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Strength & Conditioning  •  8+ yrs',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
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

          SizedBox(height: 10),

          /// TAGS
          Wrap(
            spacing: 6,
            children: [
              _Tag('Baner • Pune'),
              _Tag('Adults'),
              _Tag('Pro Athletes'),
              _Tag('Certified'),
            ],
          ),

          SizedBox(height: 12),

          /// PROGRESS BAR
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 4 / 8,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 4,
              ),
              SizedBox(height: 4),
              Text(
                '4 / 8 sessions completed',
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),

          SizedBox(height: 12),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline),
                  label: Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_today, size: 16),
                  label: Text('View Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
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
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColors.accent,
          fontSize: ResponsiveHelper.sp(11),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: ResponsiveHelper.sp(11),
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

  _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedScale(
      scale: active ? 1 : 0.98,
      duration: Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          splashColor: AppColors.accent.withValues(alpha: 0.2),
          highlightColor: AppColors.accent.withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(9)),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent.withValues(alpha: 0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              border: Border.all(
                color: active
                    ? AppColors.accent
                    : Colors.white.withValues(alpha: 0.08),
                width: ResponsiveHelper.w(1),
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: Offset(0, 4),
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
                  SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(12),
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
