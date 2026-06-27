import 'package:flutter/material.dart';

const kSurface = Color(0xFF161616);
const kGreen = Color(0xFF6EDC6A);
const kMuted = Colors.white54;

class PrivacySelector extends StatelessWidget {
  final bool isPublic;
  final Function(bool) onPrivacyChanged;

  const PrivacySelector({
    super.key,
    required this.isPublic,
    required this.onPrivacyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PrivacyCard(
            title: 'Public',
            icon: Icons.public,
            isPublicCard: true,
            isSelected: isPublic,
            onTap: () => onPrivacyChanged(true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _PrivacyCard(
            title: 'Private',
            icon: Icons.lock,
            isPublicCard: false,
            isSelected: !isPublic,
            onTap: () => onPrivacyChanged(false),
          ),
        ),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPublicCard;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrivacyCard({
    required this.title,
    required this.icon,
    required this.isPublicCard,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? kGreen : kMuted,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : kMuted,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
