import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';

const _kGreen = AppColors.accent;
const _kMuted = Colors.white38;

class LocationBubble extends StatefulWidget {
  final String content;
  final bool isMe;
  final bool isLive;

  const LocationBubble({
    super.key,
    required this.content,
    required this.isMe,
    required this.isLive,
  });

  @override
  State<LocationBubble> createState() => _LocationBubbleState();
}

class _LocationBubbleState extends State<LocationBubble> {
  Timer? _timer;
  DateTime? _expiresAt;

  @override
  void initState() {
    super.initState();
    _parseExpiresAt();
    if (widget.isLive) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant LocationBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content) {
      _parseExpiresAt();
      if (mounted) setState(() {});
    }
  }

  void _parseExpiresAt() {
    try {
      final data = jsonDecode(widget.content);
      if (data['expiresAt'] != null) {
        _expiresAt = DateTime.tryParse(data['expiresAt']);
      }
    } catch (_) {}
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double lat = 0.0;
    double lng = 0.0;
    String name = 'Location Pin';
    String address = '';

    try {
      final data = jsonDecode(widget.content);
      lat = (data['lat'] as num?)?.toDouble() ?? 0.0;
      lng = (data['lng'] as num?)?.toDouble() ?? 0.0;
      name = data['name'] ?? 'Location Pin';
      address = data['address'] ?? '';
    } catch (_) {
      final parts = widget.content.split(',');
      if (parts.length == 2) {
        lat = double.tryParse(parts[0]) ?? 0.0;
        lng = double.tryParse(parts[1]) ?? 0.0;
      }
    }

    bool isCurrentlyLive = false;
    String liveText = "Live Location Started";

    if (widget.isLive && _expiresAt != null) {
      final diff = _expiresAt!.difference(DateTime.now());
      if (diff.isNegative) {
        isCurrentlyLive = false;
        liveText = "Live stream ended";
      } else {
        isCurrentlyLive = true;
        final minutes = diff.inMinutes;
        final hours = diff.inHours;
        if (hours > 0) {
          liveText = "Live · Ends in ${hours}h ${minutes % 60}m";
        } else {
          liveText = "Live · Ends in ${minutes}m";
        }
      }
    } else if (widget.isLive) {
      isCurrentlyLive = true;
    }

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    final darkStyle =
        "feature:all|element:geometry|color:0x242f3e&style=feature:all|element:labels.text.stroke|color:0x242f3e&style=feature:all|element:labels.text.fill|color:0x746855&style=feature:administrative.locality|element:labels.text.fill|color:0xd59563&style=feature:poi|element:labels.text.fill|color:0xd59563&style=feature:poi.park|element:geometry|color:0x263c3f&style=feature:poi.park|element:labels.text.fill|color:0x6b9a76&style=feature:road|element:geometry|color:0x38414e&style=feature:road|element:geometry.stroke|color:0x212a37&style=feature:road|element:labels.text.fill|color:0x9ca5b3&style=feature:road.highway|element:geometry|color:0x746855&style=feature:road.highway|element:geometry.stroke|color:0x1f2835&style=feature:road.highway|element:labels.text.fill|color:0xf3d19c&style=feature:transit|element:geometry|color:0x2f3948&style=feature:transit.station|element:labels.text.fill|color:0xd59563&style=feature:water|element:geometry|color:0x17263c&style=feature:water|element:labels.text.fill|color:0x515c6d&style=feature:water|element:labels.text.stroke|color:0x17263c";

    final mapUrl =
        'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$lat,$lng'
        '&zoom=15'
        '&size=400x200'
        '&style=$darkStyle'
        '&key=$apiKey';

    final pinColor = isCurrentlyLive ? _kGreen : Colors.white54;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(16).copyWith(
          bottomRight: widget.isMe
              ? const Radius.circular(4)
              : const Radius.circular(16),
          bottomLeft: !widget.isMe
              ? const Radius.circular(4)
              : const Radius.circular(16),
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // MAP PREVIEW
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: isCurrentlyLive
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : const ColorFilter.mode(
                            Colors.black38,
                            BlendMode.darken,
                          ),
                    child: CachedNetworkImage(
                      imageUrl: mapUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFF1E1E1E)),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFF1E1E1E),
                        child: const Center(
                          child: Icon(Icons.map, color: Colors.white24),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: pinColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: pinColor.withOpacity(
                          isCurrentlyLive ? 0.5 : 0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.isLive
                            ? Icons.person_pin_circle
                            : Icons.location_on,
                        color: pinColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM CARD
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.isLive
                            ? Icons.share_location
                            : Icons.location_on,
                        color: pinColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isLive)
                            Text(
                              liveText,
                              style: TextStyle(
                                color: pinColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(
                            name,
                            style: TextStyle(
                              color: widget.isLive && !isCurrentlyLive
                                  ? Colors.white54
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (address.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              address,
                              style: const TextStyle(
                                color: _kMuted,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isLive && !isCurrentlyLive
                          ? Colors.white12
                          : _kGreen,
                      foregroundColor: widget.isLive && !isCurrentlyLive
                          ? Colors.white
                          : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      final uri = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    icon: const Text(
                      "OPEN IN GOOGLE MAPS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    label: const Icon(Icons.open_in_new, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
