import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MediaPreviewScreen extends StatefulWidget {
  final String filePath;
  final bool isVideo;

  const MediaPreviewScreen({
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          widget.isVideo ? "Send Video" : "Send Photo",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(18),
          ),
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
            color: AppColors.background.withValues(alpha: 0.8),
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(1.5),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(4),
                        vertical: context.heightPct(1.2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: TextField(
                        controller: _captionController,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Add a caption...",
                          hintStyle: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(15),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.widthPct(3)),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context, _captionController.text),
                    child: Container(
                      width: context.minDimensionPct(13).clamp(44.0, 52.0),
                      height: context.minDimensionPct(13).clamp(44.0, 52.0),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.send, color: AppColors.background, size: 22),
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
      return const CircularProgressIndicator(color: AppColors.accent);
    }
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
