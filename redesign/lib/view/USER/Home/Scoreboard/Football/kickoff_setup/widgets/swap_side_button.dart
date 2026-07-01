import 'package:flutter/material.dart';

class SwapSideButton extends StatelessWidget {
  final VoidCallback onTap;

  const SwapSideButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.swap_horiz,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
