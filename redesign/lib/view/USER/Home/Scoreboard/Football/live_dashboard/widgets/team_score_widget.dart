import 'package:flutter/material.dart';

class TeamScoreWidget extends StatelessWidget {
  final String teamName;
  final String? logoUrl;

  const TeamScoreWidget({
    super.key,
    required this.teamName,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade800),
            image: logoUrl != null
                ? DecorationImage(
                    image: NetworkImage(logoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: logoUrl == null
              ? const Icon(Icons.shield, color: Colors.blueAccent, size: 24)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          teamName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
