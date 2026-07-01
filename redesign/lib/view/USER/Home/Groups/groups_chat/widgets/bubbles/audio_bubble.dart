import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kSurface = Color(0xFF222222);

class AudioBubble extends StatefulWidget {
  final String url;
  final bool isMe;

  AudioBubble({super.key, required this.url, required this.isMe});

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_isPlaying) {
        _player.pause();
      }
    }
  }

  Future<void> _playPause() async {
    if (_isLoading) return;

    if (!_isPrepared) {
      if (mounted) setState(() => _isLoading = true);
      try {
        await _player.setUrl(widget.url);

        if (mounted) {
          setState(() {
            _isPrepared = true;
            _isLoading = false;
          });
        }

        _player.playerStateStream.listen((state) {
          if (mounted) {
            final isCompleted =
                state.processingState == ProcessingState.completed;
            setState(() {
              _isPlaying = state.playing && !isCompleted;
            });

            if (isCompleted) {
              _player.pause();
              _player.seek(Duration.zero);
            }
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    super.build(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
      decoration: BoxDecoration(
        color: widget.isMe ? _kGreen.withValues(alpha: 0.9) : _kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// PLAY BUTTON
          GestureDetector(
            onTap: _playPause,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: widget.isMe ? Colors.white : _kGreen,
              child: _isLoading
                  ? SizedBox(
                      width: ResponsiveHelper.w(20),
                      height: ResponsiveHelper.h(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: widget.isMe ? Colors.black : Colors.white,
                      ),
                    )
                  : Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
            ),
          ),

          SizedBox(width: 10),

          /// RANDOM ANIMATED Equalizer
          SizedBox(
            width: ResponsiveHelper.w(80),
            child: AnimatedEqualizer(isPlaying: _isPlaying, isMe: widget.isMe),
          ),

          SizedBox(width: 8),

          /// DURATION
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              if (!_isPrepared) {
                return Text(
                  "Audio",
                  style: TextStyle(
                    color: widget.isMe ? Colors.black87 : Colors.white70,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                );
              }

              final pos = snapshot.data ?? Duration.zero;
              final durStr =
                  "${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}";

              return Text(
                durStr,
                style: TextStyle(
                  color: widget.isMe ? Colors.black87 : Colors.white70,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                  ),
                );
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
  void initState() {
    super.initState();
    if (widget.isPlaying) _startAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  void _startAnimation() {
    _animTimer?.cancel();
    _animTimer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      if (mounted) {
        setState(() {
          _heights = List.generate(7, (index) {
            double baseHeight = index == 3
                ? 24.0
                : (index == 2 || index == 4)
                ? 16.0
                : 10.0;
            double randOffset = math.Random().nextDouble() * 12 - 6;
            return (baseHeight + randOffset).clamp(6.0, 32.0);
          });
        });
      }
    });
  }

  void _stopAnimation() {
    _animTimer?.cancel();
    if (mounted) {
      setState(() {
        _heights = [8, 12, 16, 20, 16, 12, 8];
      });
    }
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(7, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(2.5)),
          width: ResponsiveHelper.w(5),
          height: _heights[index],
          decoration: BoxDecoration(
            color: widget.isMe ? Colors.black87 : _kGreen,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
          ),
        );
      }),
    );
  }
}
