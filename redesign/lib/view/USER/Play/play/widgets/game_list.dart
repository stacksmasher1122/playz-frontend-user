import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Play/match_detail/match_detail_screen.dart';
import '../play_models.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  static const _games = [
    GameData(
      hostName: 'Deepankar Shrikant Rokade Patil',
      time: 'Thu 4 Dec, 06:30',
      price: '₹100',
      currentPlayers: 2,
      maxPlayers: 22,
      address: 'Dnyankamal Society, Sr No 20/1, Abhinav Nagar, Pune',
      distance: '0.8 km',
      avatarUrl: 'https://i.pravatar.cc/100?img=1',
      sport: 'Cricket',
      type: 'Casual',
      isFull: false,
    ),
    GameData(
      hostName: 'Rahul Mahadev Kulkarni',
      time: 'Fri 5 Dec, 07:00',
      price: '₹150',
      currentPlayers: 18,
      maxPlayers: 18,
      address: 'Baner Sports Complex, Near High Street, Pune',
      distance: '1.4 km',
      avatarUrl: 'https://i.pravatar.cc/100?img=2',
      sport: 'Football',
      type: 'Competitive',
      isFull: true,
    ),
    GameData(
      hostName: 'Amit Prakash Deshmukh',
      time: 'Sat 6 Dec, 08:30',
      price: '₹80',
      currentPlayers: 8,
      maxPlayers: 16,
      address: 'Wakad Indoor Arena, Hinjewadi Road, Pune',
      distance: '2.1 km',
      avatarUrl: 'https://i.pravatar.cc/100?img=3',
      sport: 'Badminton',
      type: 'Casual',
      isFull: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _games.length,
      itemBuilder: (_, i) => GameCard(data: _games[i]),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameData data;
  const GameCard({super.key, required this.data});

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'casual':
        return const Color(0xFF1E3A8A); // blue
      case 'competitive':
        return const Color(0xFF4C1D95); // purple
      case 'tournament':
        return const Color(0xFF7C2D12); // amber/brown
      default:
        return const Color(0xFF2A2A2A);
    }
  }

  String _shortName(String name) {
    final parts = name.split(' ');
    if (parts.length < 2) return name;
    return '${parts.first} ${parts.last[0]}.';
  }

  @override
  Widget build(BuildContext context) {
    final progress = data.currentPlayers / data.maxPlayers;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatchDetailScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141414), Color(0xFF0E0E0E)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SECTION 1: TAGS & PRICE
            Row(
              children: [
                _Tag(data.type.toUpperCase(), color: _typeColor(data.type)),
                const SizedBox(width: 8),
                _Tag(data.sport.toUpperCase(), color: const Color(0xFF2A2A2A)),
                const Spacer(),
                Text(
                  data.price,
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// SECTION 2: HOST INFO & PLAYER COUNT
            Row(
              children: [
                // Avatar with Online Status
                Stack(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: data.avatarUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Name and Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shortName(data.hostName),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white54,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.time,
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Player Ratio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${data.currentPlayers}/${data.maxPlayers}',
                      style: GoogleFonts.inter(
                        color: data.isFull ? Colors.white54 : AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      'PLAYERS',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// SECTION 3: PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white10,
                color: progress >= 0.7
                    ? const Color(0xFFF59E0B)
                    : AppColors.accent,
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.06), height: 1),
            const SizedBox(height: 16),

            /// SECTION 4: LOCATION & JOIN BUTTON
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white24, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        data.distance,
                        style: GoogleFonts.inter(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Join Button
                ElevatedButton(
                  onPressed: data.isFull ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    data.isFull ? 'Full' : 'Join',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
