import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'setup_models.dart';

class StickyCtaButton extends StatelessWidget {
  final MatchMode mode;
  final bool isActive;
  final VoidCallback onTap;

  const StickyCtaButton({
    super.key,
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kBg,
        boxShadow: [
          BoxShadow(
            color: kAccent.withOpacity(0.05),
            blurRadius: 32,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isActive ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          mode == MatchMode.friendly ? "START MATCH" : "CREATE TOURNAMENT",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
