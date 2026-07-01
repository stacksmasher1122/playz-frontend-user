import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class CoachingPreferencesSection extends StatefulWidget {
  CoachingPreferencesSection({super.key});

  @override
  State<CoachingPreferencesSection> createState() =>
      _CoachingPreferencesSectionState();
}

class _CoachingPreferencesSectionState
    extends State<CoachingPreferencesSection> {
  final Set<String> _selectedLevels = {'Kids', 'Adults'};
  bool _willingToTravel = true;
  bool _onlineCoaching = false;
  bool _isComfortable = false;

  final levels = ['Kids', 'Adults', 'Women Only', 'Pro Athletes', 'Beginners'];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        StepHeader(step: 4, title: 'Coaching Preferences'),

        SizedBox(height: 12),

        Text(
          'Coaching Level (Select all that apply)',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(13),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 12),

        /// LEVEL CHIPS
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: levels.map((level) {
            final selected = _selectedLevels.contains(level);
            return SelectableChip(
              label: level,
              selected: selected,
              onTap: () {
                setState(() {
                  selected
                      ? _selectedLevels.remove(level)
                      : _selectedLevels.add(level);
                });
              },
            );
          }).toList(),
        ),

        SizedBox(height: 20),

        /// TOGGLES
        PreferenceToggle(
          label: 'Willing to Travel?',
          value: _willingToTravel,
          onChanged: (v) => setState(() => _willingToTravel = v),
        ),

        SizedBox(height: 12),

        PreferenceToggle(
          label: 'Online Coaching Available?',
          value: _onlineCoaching,
          onChanged: (v) => setState(() => _onlineCoaching = v),
        ),

        SizedBox(height: 12),

        PreferenceToggle(
          label: 'Comfortable training women/girls?',
          value: _isComfortable,
          onChanged: (v) => setState(() => _isComfortable = v),
        ),
      ],
    );
  }
}

class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          color: selected ? kGreen.withValues(alpha: 0.15) : kCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: ResponsiveHelper.w(1.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGreen : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.sp(13),
          ),
        ),
      ),
    );
  }
}

class PreferenceToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  PreferenceToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(12)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: kGreen,
            activeTrackColor: kGreen.withValues(alpha: 0.4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
