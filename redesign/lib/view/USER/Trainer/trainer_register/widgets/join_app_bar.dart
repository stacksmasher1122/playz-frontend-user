import 'package:flutter/material.dart';

const kMuted = Color(0xFFA7A7A7);

class JoinAppBar extends StatelessWidget {
  const JoinAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Join as a Trainer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Complete your profile to start earning',
              style: TextStyle(color: kMuted, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
