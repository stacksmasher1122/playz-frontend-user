import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MyTrainersSection extends StatefulWidget {
  const MyTrainersSection({super.key});

  @override
  State<MyTrainersSection> createState() => _MyTrainersSectionState();
}

class _MyTrainersSectionState extends State<MyTrainersSection> {
  String selectedFilter = 'Active packages';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final filteredTrainers = _allMyTrainers
        .where((t) => t.categories.contains(selectedFilter))
        .toList();

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: context.heightPct(1)),

          /// HEADER
          Row(
            children: [
              Expanded(
                child: Text(
                  'My Trainers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineLgMobile.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Active & recent coaches',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(1.5)),

          /// FILTER CHIPS (Horizontal Scrollable Row)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _FilterButton(
                  label: 'Active packages',
                  icon: Icons.local_fire_department,
                  active: selectedFilter == 'Active packages',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Active packages';
                    });
                  },
                ),
                SizedBox(width: context.widthPct(2)),
                _FilterButton(
                  label: 'Cricket',
                  active: selectedFilter == 'Cricket',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Cricket';
                    });
                  },
                ),
                SizedBox(width: context.widthPct(2)),
                _FilterButton(
                  label: 'Football',
                  active: selectedFilter == 'Football',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Football';
                    });
                  },
                ),
                SizedBox(width: context.widthPct(2)),
                _FilterButton(
                  label: 'Online',
                  active: selectedFilter == 'Online',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Online';
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: context.heightPct(1.8)),

          /// TRAINER CARDS
          if (filteredTrainers.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(5)),
              child: Center(
                child: Text(
                  'No trainers found',
                  style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                ),
              ),
            )
          else
            ...filteredTrainers.expand(
              (trainer) => [
                _MyTrainerCard(
                  name: trainer.name,
                  specialty: trainer.specialty,
                  rating: trainer.rating,
                  status: trainer.status,
                  completionText: trainer.completionText,
                  progress: trainer.progress,
                  tags: trainer.tags,
                ),
                SizedBox(height: context.heightPct(1.5)),
              ],
            ),

          SizedBox(height: context.heightPct(12)),
        ]),
      ),
    );
  }
}

class _MyTrainerCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String rating;
  final String status;
  final String completionText;
  final double progress;
  final List<String> tags;

  const _MyTrainerCard({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.status,
    required this.completionText,
    required this.progress,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 12,
          ),
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
                  style: AppTypography.bodyXs.copyWith(
                    fontSize: context.responsiveFont(10),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: context.widthPct(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        _statusPill(context, status),
                      ],
                    ),
                    SizedBox(height: context.heightPct(0.4)),
                    Text(
                      specialty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.4)),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: context.widthPct(1)),
                        Text(
                          rating,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(1.2)),

          /// TAGS
          Wrap(
            spacing: context.widthPct(1.5),
            runSpacing: context.heightPct(0.6),
            children: tags.map((t) => _Tag(t)).toList(),
          ),

          SizedBox(height: context.heightPct(1.5)),

          /// PROGRESS BAR
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 4,
              ),
              SizedBox(height: context.heightPct(0.4)),
              Text(
                completionText,
                style: AppTypography.bodyXs.copyWith(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(1.5)),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Chat',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.borderDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(6),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.widthPct(2.5)),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'View Schedule',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(6),
                      ),
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

  Widget _statusPill(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2),
        vertical: context.heightPct(0.3),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
      ),
      child: Text(
        text,
        style: AppTypography.labelCaps10.copyWith(
          color: AppColors.accent,
          fontSize: context.responsiveFont(11),
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
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2.5),
        vertical: context.heightPct(0.6),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      ),
      child: Text(
        label,
        style: AppTypography.bodySm.copyWith(
          fontSize: context.responsiveFont(11),
          color: AppColors.textPrimary,
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
    ResponsiveHelper.init(context);
    return AnimatedScale(
      scale: active ? 1 : 0.98,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
          splashColor: AppColors.accent.withValues(alpha: 0.2),
          highlightColor: AppColors.accent.withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(3.5),
              vertical: context.heightPct(1.1),
            ),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent.withValues(alpha: 0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
              border: Border.all(
                color: active ? AppColors.accent : AppColors.borderDark,
                width: 1,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.25),
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
                    color: active ? AppColors.accent : AppColors.textPrimary,
                  ),
                  SizedBox(width: context.widthPct(1.5)),
                ],
                Text(
                  label,
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.accent : AppColors.textPrimary,
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

class _TrainerData {
  final String name;
  final String specialty;
  final String rating;
  final String status;
  final String completionText;
  final double progress;
  final List<String> tags;
  final List<String> categories;

  _TrainerData({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.status,
    required this.completionText,
    required this.progress,
    required this.tags,
    required this.categories,
  });
}

final List<_TrainerData> _allMyTrainers = [
  _TrainerData(
    name: 'Rahul Sharma',
    specialty: 'Strength & Conditioning  •  8+ yrs',
    rating: '4.8',
    status: 'Active Package',
    completionText: '4 / 8 sessions completed',
    progress: 4 / 8,
    tags: ['Baner • Pune', 'Adults', 'Pro Athletes', 'Certified'],
    categories: ['Active packages', 'Online'],
  ),
  _TrainerData(
    name: 'Vikram Singh',
    specialty: 'Cricket Coaching  •  10+ yrs',
    rating: '4.9',
    status: 'Active Package',
    completionText: '6 / 12 sessions completed',
    progress: 6 / 12,
    tags: ['Kothrud • Pune', 'Kids', 'Intermediate', 'Certified'],
    categories: ['Active packages', 'Cricket'],
  ),
  _TrainerData(
    name: 'Amit Patel',
    specialty: 'Football Coaching  •  6+ yrs',
    rating: '4.7',
    status: 'Recent',
    completionText: '10 / 10 sessions completed',
    progress: 1.0,
    tags: ['Aundh • Pune', 'All Ages', 'Rehab', 'Certified'],
    categories: ['Football'],
  ),
  _TrainerData(
    name: 'Priya Mehta',
    specialty: 'Yoga & Pilates  •  5+ yrs',
    rating: '4.9',
    status: 'Active Package',
    completionText: '2 / 8 sessions completed',
    progress: 2 / 8,
    tags: ['Koregaon Park • Pune', 'Women Only', 'Flexible', 'Certified'],
    categories: ['Active packages', 'Online'],
  ),
];
