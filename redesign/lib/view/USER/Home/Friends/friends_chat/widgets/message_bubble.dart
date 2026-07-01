import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';
import 'full_screen_image.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kSurface = Color(0xFF222222);
const kMuted = Colors.white38;

class MessageBubble extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isMe;
  final String timeStr;
  final ChatController ctrl;
  final String friendName;

  MessageBubble({
    super.key,
    required this.msg,
    required this.isMe,
    required this.timeStr,
    required this.ctrl,
    required this.friendName,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // ── Reply quote ──
            if (msg.replyToId != null && msg.replyToContent != null)
              Container(
                margin: EdgeInsets.only(bottom: 4),
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? kGreen.withValues(alpha: 0.15)
                      : kSurface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border(left: BorderSide(color: kGreen, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.replyToSender == ctrl.myEmail
                          ? "You"
                          : (friendName.isNotEmpty
                                ? friendName
                                : (msg.replyToSender ?? "")),
                      style: TextStyle(
                        color: kGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.sp(11),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      msg.replyToContent!,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            // ── Main content ──
            _buildContent(context),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(color: kMuted, fontSize: 11),
                ),
                if (msg.isEdited) ...[
                  SizedBox(width: 4),
                  Text(
                    "edited",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: ResponsiveHelper.sp(10),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (isMe) ...[
                  SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.done,
                    size: 16,
                    color: msg.isRead ? kGreen : kMuted,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (msg.type) {
      case 'text':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: isMe ? kGreen : kSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)).copyWith(
              bottomRight: isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(20)),
              bottomLeft: !isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(20)),
            ),
          ),
          child: Text(
            msg.content,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.white,
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: isMe ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        );
      case 'image':
        String url = msg.content;
        String caption = '';
        if (msg.content.startsWith('{')) {
          try {
            final data = jsonDecode(msg.content);
            url = data['url'] ?? '';
            caption = data['caption'] ?? '';
          } catch (_) {}
        }

        final imageWidget = DynamicImageBubble(
          imageUrl: url,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: 300,
        );

        if (caption.isEmpty) return imageWidget;

        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(4)),
          decoration: BoxDecoration(
            color: isMe ? kGreen : kSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)).copyWith(
              bottomRight: isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
              bottomLeft: !isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(6)),
                child: Text(
                  caption,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'audio':
        return AudioBubble(url: msg.content, isMe: isMe);
      case 'video':
        String url = msg.content;
        String caption = '';
        if (msg.content.startsWith('{')) {
          try {
            final data = jsonDecode(msg.content);
            url = data['url'] ?? '';
            caption = data['caption'] ?? '';
          } catch (_) {}
        }

        final videoWidget = VideoBubble(url: url, ctrl: ctrl);

        if (caption.isEmpty) return videoWidget;

        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(4)),
          decoration: BoxDecoration(
            color: isMe ? kGreen : kSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)).copyWith(
              bottomRight: isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
              bottomLeft: !isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              videoWidget,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(6)),
                child: Text(
                  caption,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'location':
      case 'live_location':
        return LocationBubble(
          content: msg.content,
          isMe: isMe,
          isLive: msg.type == 'live_location',
        );
      default:
        return Container();
    }
  }
}

class LocationBubble extends StatefulWidget {
  final String content;
  final bool isMe;
  final bool isLive;

  LocationBubble({
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
    _timer = Timer.periodic(Duration(seconds: 30), (_) {
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
    ResponsiveHelper.init(context);
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
    const darkStyle = "feature:all|element:geometry|color:0x242f3e&style=feature:all|element:labels.text.stroke|color:0x242f3e&style=feature:all|element:labels.text.fill|color:0x746855&style=feature:administrative.locality|element:labels.text.fill|color:0xd59563&style=feature:poi|element:labels.text.fill|color:0xd59563&style=feature:poi.park|element:geometry|color:0x263c3f&style=feature:poi.park|element:labels.text.fill|color:0x6b9a76&style=feature:road|element:geometry|color:0x38414e&style=feature:road|element:geometry.stroke|color:0x212a37&style=feature:road|element:labels.text.fill|color:0x9ca5b3&style=feature:road.highway|element:geometry|color:0x746855&style=feature:road.highway|element:geometry.stroke|color:0x1f2835&style=feature:road.highway|element:labels.text.fill|color:0xf3d19c&style=feature:transit|element:geometry|color:0x2f3948&style=feature:transit.station|element:labels.text.fill|color:0xd59563&style=feature:water|element:geometry|color:0x17263c&style=feature:water|element:labels.text.fill|color:0x515c6d&style=feature:water|element:labels.text.stroke|color:0x17263c";

    final mapUrl = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=400x200&style=$darkStyle&key=$apiKey';
    final pinColor = isCurrentlyLive ? kGreen : Colors.white54;

    return Container(
      width: ResponsiveHelper.w(260),
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)).copyWith(
          bottomRight: widget.isMe ? Radius.circular(ResponsiveHelper.w(4)) : Radius.circular(ResponsiveHelper.w(16)),
          bottomLeft: !widget.isMe ? Radius.circular(ResponsiveHelper.w(4)) : Radius.circular(ResponsiveHelper.w(16)),
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
            child: SizedBox(
              height: ResponsiveHelper.h(120),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: isCurrentlyLive ? ColorFilter.mode(Colors.transparent, BlendMode.multiply) : ColorFilter.mode(Colors.black38, BlendMode.darken),
                    child: CachedNetworkImage(
                      imageUrl: mapUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => Container(color: Color(0xFF1E1E1E)),
                      errorWidget: (_, __, ___) => Container(color: Color(0xFF1E1E1E), child: Center(child: Icon(Icons.map, color: Colors.white24))),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                    decoration: BoxDecoration(color: pinColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                      decoration: BoxDecoration(color: pinColor.withValues(alpha: isCurrentlyLive ? 0.5 : 0.2), shape: BoxShape.circle),
                      child: Icon(widget.isLive ? Icons.person_pin_circle : Icons.location_on, color: pinColor, size: 28),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                      decoration: BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle),
                      child: Icon(widget.isLive ? Icons.share_location : Icons.location_on, color: pinColor, size: 20),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isLive) Text(liveText, style: TextStyle(color: pinColor, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.bold)),
                          Text(name, style: TextStyle(color: widget.isLive && !isCurrentlyLive ? Colors.white54 : Colors.white, fontSize: ResponsiveHelper.sp(14), fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (address.isNotEmpty) ...[
                            SizedBox(height: 2),
                            Text(address, style: TextStyle(color: kMuted, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: ResponsiveHelper.h(40), width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isLive && !isCurrentlyLive ? Colors.white12 : kGreen,
                      foregroundColor: widget.isLive && !isCurrentlyLive ? Colors.white : Colors.black,
                      elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(20))), padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                      if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    icon: Text("OPEN IN GOOGLE MAPS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    label: Icon(Icons.open_in_new, size: 16),
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

class AudioBubble extends StatefulWidget {
  final String url;
  final bool isMe;
  AudioBubble({super.key, required this.url, required this.isMe});
  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isPrepared = false;
  bool _isLoading = false;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_isPlaying) _player.pause();
    }
  }
  Future<void> _playPause() async {
    if (_isLoading) return;
    if (!_isPrepared) {
      if (mounted) setState(() => _isLoading = true);
      try {
        await _player.setUrl(widget.url);
        if (mounted) setState(() { _isPrepared = true; _isLoading = false; });
        _player.playerStateStream.listen((state) {
          if (mounted) {
            final isCompleted = state.processingState == ProcessingState.completed;
            setState(() { _isPlaying = state.playing && !isCompleted; });
            if (isCompleted) { _player.pause(); _player.seek(Duration.zero); }
          }
        });
        _player.play();
      } catch (e) {
        debugPrint("Audio error: $e");
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }
  @override
  void dispose() { WidgetsBinding.instance.removeObserver(this); _player.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
      decoration: BoxDecoration(color: widget.isMe ? kGreen.withValues(alpha: 0.9) : kSurface, borderRadius: BorderRadius.circular(ResponsiveHelper.w(20))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _playPause,
            child: CircleAvatar(
              radius: 20, backgroundColor: widget.isMe ? Colors.white : kGreen,
              child: _isLoading ? SizedBox(width: ResponsiveHelper.w(20), height: ResponsiveHelper.h(20), child: CircularProgressIndicator(strokeWidth: 2, color: widget.isMe ? Colors.black : Colors.white))
              : Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(width: ResponsiveHelper.w(80), child: AnimatedEqualizer(isPlaying: _isPlaying, isMe: widget.isMe)),
          SizedBox(width: 8),
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              if (!_isPrepared) return Text("Audio", style: TextStyle(color: widget.isMe ? Colors.black87 : Colors.white70, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.w600));
              final pos = snapshot.data ?? Duration.zero;
              return Text("${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}", style: TextStyle(color: widget.isMe ? Colors.black87 : Colors.white70, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.w600));
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedEqualizer extends StatefulWidget {
  final bool isPlaying;
  final bool isMe;
  AnimatedEqualizer({super.key, required this.isPlaying, required this.isMe});
  @override
  State<AnimatedEqualizer> createState() => _AnimatedEqualizerState();
}

class _AnimatedEqualizerState extends State<AnimatedEqualizer> {
  Timer? _animTimer;
  List<double> _heights = [8, 12, 16, 20, 16, 12, 8];
  @override
  void initState() { super.initState(); if (widget.isPlaying) _startAnimation(); }
  @override
  void didUpdateWidget(covariant AnimatedEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) { if (widget.isPlaying) {
      _startAnimation();
    } else {
      _stopAnimation();
    } }
  }
  void _startAnimation() {
    _animTimer?.cancel();
    _animTimer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      if (mounted) {
        setState(() {
        _heights = List.generate(7, (index) {
          double baseHeight = index == 3 ? 24.0 : (index == 2 || index == 4) ? 16.0 : 10.0;
          return (baseHeight + math.Random().nextDouble() * 12 - 6).clamp(6.0, 32.0);
        });
      });
      }
    });
  }
  void _stopAnimation() { _animTimer?.cancel(); if (mounted) setState(() { _heights = [8, 12, 16, 20, 16, 12, 8]; }); }
  @override
  void dispose() { _animTimer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(7, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 250), margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(2.5)),
          width: ResponsiveHelper.w(5), height: _heights[index],
          decoration: BoxDecoration(color: widget.isMe ? Colors.black87 : kGreen, borderRadius: BorderRadius.circular(ResponsiveHelper.w(4))),
        );
      }),
    );
  }
}

class VideoBubble extends StatefulWidget {
  final String url;
  final ChatController ctrl;
  VideoBubble({super.key, required this.url, required this.ctrl});
  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInit = false;
  bool _isLoading = false;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ((state == AppLifecycleState.paused || state == AppLifecycleState.inactive) && _videoController?.value.isPlaying == true) _videoController?.pause();
  }
  Future<void> _initVideo() async {
    if (_isInit || _isLoading) return;
    setState(() => _isLoading = true);
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoController!.initialize();
    _chewieController = ChewieController(videoPlayerController: _videoController!, autoPlay: true, looping: false, allowFullScreen: true, allowMuting: true, allowPlaybackSpeedChanging: false, showControls: true);
    if (mounted) setState(() { _isInit = true; _isLoading = false; });
  }
  @override
  void deactivate() { if (_videoController?.value.isPlaying == true) _videoController?.pause(); super.deactivate(); }
  @override
  void dispose() { WidgetsBinding.instance.removeObserver(this); _chewieController?.dispose(); _videoController?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    super.build(context);
    if (!_isInit) {
      return GestureDetector(
        onTap: _initVideo,
        child: Container(
          height: ResponsiveHelper.h(220), width: ResponsiveHelper.w(260), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(ResponsiveHelper.w(16))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isLoading) CircularProgressIndicator(color: kGreen) else Icon(Icons.play_circle_fill, color: Colors.white70, size: 64),
              Positioned(top: ResponsiveHelper.h(8), right: ResponsiveHelper.w(8), child: Container(decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: IconButton(icon: Icon(Icons.download, color: Colors.white, size: 20), onPressed: () => widget.ctrl.downloadVideo(widget.url)))),
            ],
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      child: Stack(
        children: [
          ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), child: AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: Chewie(controller: _chewieController!))),
          Positioned(top: ResponsiveHelper.h(8), right: ResponsiveHelper.w(8), child: Container(decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: IconButton(icon: Icon(Icons.download, color: Colors.white, size: 20), onPressed: () => widget.ctrl.downloadVideo(widget.url)))),
        ],
      ),
    );
  }
}

class DynamicImageBubble extends StatefulWidget {
  final String imageUrl;
  final double maxWidth;
  final double maxHeight;
  DynamicImageBubble({super.key, required this.imageUrl, required this.maxWidth, required this.maxHeight});
  @override
  State<DynamicImageBubble> createState() => _DynamicImageBubbleState();
}

class _DynamicImageBubbleState extends State<DynamicImageBubble> {
  Size? _resolvedSize;
  bool _hasError = false;
  @override
  void initState() { super.initState(); _resolveImageSize(); }
  void _resolveImageSize() {
    final imageProvider = CachedNetworkImageProvider(widget.imageUrl);
    final stream = imageProvider.resolve(ImageConfiguration());
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      if (!mounted) return;
      final imgW = info.image.width.toDouble();
      final imgH = info.image.height.toDouble();
      info.dispose();
      final aspect = imgW / imgH;
      double displayW = widget.maxWidth;
      double displayH = displayW / aspect;
      if (displayH > widget.maxHeight) { displayH = widget.maxHeight; displayW = displayH * aspect; }
      setState(() => _resolvedSize = Size(displayW, displayH));
    }, onError: (_, __) { if (mounted) setState(() => _hasError = true); }));
  }
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    if (_hasError) {
      return Container(
        height: ResponsiveHelper.h(200),
        width: ResponsiveHelper.w(250),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Icon(Icons.error, color: Colors.white),
      );
    }
    final size = _resolvedSize;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FullScreenImage(url: widget.imageUrl)),
      ),
      child: Hero(
        tag: widget.imageUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          child: SizedBox(
            width: size?.width,
            height: size?.height,
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade900.withValues(alpha: 0.5),
                highlightColor: Colors.grey.shade800.withValues(alpha: 0.4),
                child: Container(
                  width: size?.width ?? widget.maxWidth,
                  height: size?.height ?? 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                height: ResponsiveHelper.h(200),
                width: ResponsiveHelper.w(250),
                color: kSurface,
                child: Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
