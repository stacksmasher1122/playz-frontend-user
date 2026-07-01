import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;

class VideoBubble extends StatefulWidget {
  final String url;
  final GroupChatController ctrl;

  VideoBubble({super.key, required this.url, required this.ctrl});

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInit = false;
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
      if (_videoController?.value.isPlaying == true) {
        _videoController?.pause();
      }
    }
  }

  Future<void> _initVideo() async {
    if (_isInit || _isLoading) return;
    setState(() => _isLoading = true);

    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: false,
      showControls: true,
    );

    if (mounted) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
    }
  }

  @override
  void deactivate() {
    if (_videoController?.value.isPlaying == true) {
      _videoController?.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    super.build(context);

    if (!_isInit) {
      return GestureDetector(
        onTap: _initVideo,
        child: Container(
          height: ResponsiveHelper.h(220),
          width: ResponsiveHelper.w(260),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isLoading)
                CircularProgressIndicator(color: _kGreen)
              else
                Icon(
                  Icons.play_circle_fill,
                  color: Colors.white70,
                  size: 64,
                ),

              Positioned(
                top: ResponsiveHelper.h(8),
                right: ResponsiveHelper.w(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => widget.ctrl.downloadVideo(widget.url),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: Chewie(controller: _chewieController!),
            ),
          ),
          // Download button
          Positioned(
            top: ResponsiveHelper.h(8),
            right: ResponsiveHelper.w(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.download, color: Colors.white, size: 20),
                onPressed: () => widget.ctrl.downloadVideo(widget.url),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
