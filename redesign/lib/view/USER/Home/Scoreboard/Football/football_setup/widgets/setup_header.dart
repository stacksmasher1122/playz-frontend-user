import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';

class SetupHeader extends StatelessWidget {
  final MatchMode mode;

  const SetupHeader({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: kBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BackButton(color: kTextPrimary),
          Text(
            mode == MatchMode.friendly ? 'FRIENDLY MATCH' : 'TOURNAMENT SETUP',
            style: const TextStyle(
              color: kTextPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 14,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
