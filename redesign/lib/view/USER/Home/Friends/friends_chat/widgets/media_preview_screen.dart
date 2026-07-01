import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Colors.white38;

class MediaPreviewScreen extends StatefulWidget {
  final String filePath;
  final bool isVideo;

  MediaPreviewScreen({
    super.key,
    required this.filePath,
    required this.isVideo,
  });

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.file(File(widget.filePath));
      _videoController!.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: false,
          showControls: true,
        );
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.isVideo ? "Send Video" : "Send Photo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: widget.isVideo
                  ? _buildVideoPreview()
                  : _buildImagePreview(),
            ),
          ),
          // Bottom bar with send button
          Container(
            color: Colors.black.withValues(alpha: 0.8),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                      ),
                      child: TextField(
                        controller: _captionController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(16),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Add a caption...",
                          hintStyle: TextStyle(color: kMuted, fontSize: 16),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context, _captionController.text),
                    child: Container(
                      width: ResponsiveHelper.w(52),
                      height: ResponsiveHelper.h(52),
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(Icons.send, color: Colors.black, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Image.file(
        File(widget.filePath),
        fit: BoxFit.contain,
        cacheWidth: 1000,
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_chewieController == null ||
        _videoController == null ||
        !_videoController!.value.isInitialized) {
      return CircularProgressIndicator(color: kGreen);
    }
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
