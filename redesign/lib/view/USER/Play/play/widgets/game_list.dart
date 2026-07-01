import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Play/match_detail/match_detail_screen.dart';
import '../play_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GameList extends StatelessWidget {
  GameList({super.key});

  static final _games = [
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
    ResponsiveHelper.init(context);
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _games.length,
      itemBuilder: (_, i) => GameCard(data: _games[i]),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameData data;
  GameCard({super.key, required this.data});

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'casual':
        return Color(0xFF1E3A8A); // blue
      case 'competitive':
        return Color(0xFF4C1D95); // purple
      case 'tournament':
        return Color(0xFF7C2D12); // amber/brown
      default:
        return Color(0xFF2A2A2A);
    }
  }

  String _shortName(String name) {
    final parts = name.split(' ');
    if (parts.length < 2) return name;
    return '${parts.first} ${parts.last[0]}.';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = data.currentPlayers / data.maxPlayers;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchDetailScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          gradient: LinearGradient(
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
                SizedBox(width: 8),
                _Tag(data.sport.toUpperCase(), color: Color(0xFF2A2A2A)),
                Spacer(),
                Text(
                  data.price,
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            /// SECTION 2: HOST INFO & PLAYER COUNT
            Row(
              children: [
                // Avatar with Online Status
                Stack(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: data.avatarUrl,
                        width: ResponsiveHelper.w(52),
                        height: ResponsiveHelper.h(52),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: ResponsiveHelper.w(0),
                      bottom: ResponsiveHelper.h(0),
                      child: Container(
                        width: ResponsiveHelper.w(14),
                        height: ResponsiveHelper.h(14),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: ResponsiveHelper.w(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                // Name and Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shortName(data.hostName),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white54,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            data.time,
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: ResponsiveHelper.sp(13),
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
                        fontSize: ResponsiveHelper.sp(15),
                      ),
                    ),
                    Text(
                      'PLAYERS',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: ResponsiveHelper.sp(10),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            /// SECTION 3: PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white10,
                color: progress >= 0.7
                    ? Color(0xFFF59E0B)
                    : AppColors.accent,
                minHeight: 4,
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
            SizedBox(height: 16),

            /// SECTION 4: LOCATION & JOIN BUTTON
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white24, size: 14),
                SizedBox(width: 6),
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
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                      ),
                      Text(
                        data.distance,
                        style: GoogleFonts.inter(
                          color: Colors.white38,
                          fontSize: ResponsiveHelper.sp(11),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                // Join Button
                ElevatedButton(
                  onPressed: data.isFull ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    data.isFull ? 'Full' : 'Join',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
  _Tag(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: ResponsiveHelper.sp(10),
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
