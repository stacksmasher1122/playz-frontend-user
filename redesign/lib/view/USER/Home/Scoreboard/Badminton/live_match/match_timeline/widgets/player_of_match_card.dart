import 'package:flutter/material.dart';

class PlayerOfMatchCard extends StatefulWidget {
  final String playerName;
  final String description;
  final String winStreak;
  final String tournamentRank;
  final int formRating; // 1-5

  const PlayerOfMatchCard({
    super.key,
    required this.playerName,
    required this.description,
    required this.winStreak,
    required this.tournamentRank,
    required this.formRating,
  });

  @override
  State<PlayerOfMatchCard> createState() => _PlayerOfMatchCardState();
}

class _PlayerOfMatchCardState extends State<PlayerOfMatchCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.3, 1.0, curve: Curves.easeIn)),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
          image: const DecorationImage(
            // Since we don't have the exact asset, use a solid dark gradient over a placeholder
            image: AssetImage('assets/images/placeholder_player.png'), // Will fail gracefully if missing
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.8),
                Colors.black,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade300, // AMBER/GOLD badge
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PLAYER OF THE MATCH',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.playerName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn('WIN STREAK', widget.winStreak, const Color(0xFFC6FF00)),
                  _buildStatColumn('TOURNAMENT RANK', widget.tournamentRank, Colors.white),
                  _buildFormColumn('FORM', widget.formRating),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildFormColumn(String label, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final isFilled = index < rating;
            return Container(
              margin: const EdgeInsets.only(right: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? const Color(0xFFC6FF00) : Colors.transparent, // Neon Yellow-Green
                border: Border.all(
                  color: isFilled ? const Color(0xFFC6FF00) : Colors.grey.shade700,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
