import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kSurface = Color(0xFF222222);

class DynamicImageBubble extends StatefulWidget {
  final String imageUrl;
  final double maxWidth;
  final double maxHeight;

  DynamicImageBubble({
    super.key,
    required this.imageUrl,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  State<DynamicImageBubble> createState() => _DynamicImageBubbleState();
}

class _DynamicImageBubbleState extends State<DynamicImageBubble> {
  Size? _resolvedSize;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _resolveImageSize();
  }

  void _resolveImageSize() {
    final imageProvider = CachedNetworkImageProvider(widget.imageUrl);
    final stream = imageProvider.resolve(ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          if (!mounted) return;
          final imgW = info.image.width.toDouble();
          final imgH = info.image.height.toDouble();
          info.dispose();

          final aspect = imgW / imgH;
          double displayW = widget.maxWidth;
          double displayH = displayW / aspect;

          if (displayH > widget.maxHeight) {
            displayH = widget.maxHeight;
            displayW = displayH * aspect;
          }

          setState(() => _resolvedSize = Size(displayW, displayH));
        },
        onError: (_, __) {
          if (mounted) setState(() => _hasError = true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    if (_hasError) {
      return Container(
        height: ResponsiveHelper.h(200),
        width: ResponsiveHelper.w(250),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Icon(Icons.error, color: Colors.white),
      );
    }

    final size = _resolvedSize;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImage(url: widget.imageUrl),
          ),
        );
      },
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
                color: _kSurface,
                child: Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String url;

  FullScreenImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: url,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade900.withValues(alpha: 0.5),
                highlightColor: Colors.grey.shade800.withValues(alpha: 0.4),
                child: Container(
                  width: double.infinity,
                  height: ResponsiveHelper.h(300),
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
