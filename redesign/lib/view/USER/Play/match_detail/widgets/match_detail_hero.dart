import 'package:flutter/material.dart';
import '../match_detail_constants.dart';

class MatchDetailHero extends StatelessWidget {
  const MatchDetailHero({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.42;

    return SliverAppBar(
      expandedHeight: height,
      backgroundColor: Colors.black,
      pinned: false,
      leading: const BackButton(),
      actions: const [
        Icon(Icons.share_outlined),
        SizedBox(width: 12),
        Icon(Icons.more_vert),
        SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1200",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _TagRow(),
                  SizedBox(height: 16),
                  _StartIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: const [
        _Tag("COMPETITIVE"),
        _Tag("DOUBLES"),
        _Tag("ELITE", color: Colors.purple),
      ],
    );
  }
}

class _StartIndicator extends StatelessWidget {
  const _StartIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.circle, size: 10, color: MatchDetailColors.primary),
        SizedBox(width: 8),
        Text(
          "Starts in 45m",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag(this.label, {this.color = Colors.white24});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
