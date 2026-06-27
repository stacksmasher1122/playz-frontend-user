import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class GroupMediaSection extends StatelessWidget {
  final GroupInfoController ctrl;

  const GroupMediaSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMediaBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MEDIA, LINKS AND DOCS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(Icons.chevron_right, color: _kMuted, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              final mediaList = ctrl.mediaFiles;
              if (mediaList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text("No media yet", style: TextStyle(color: _kMuted)),
                );
              }
              // Show up to 3 latest media icons
              return Row(
                children: mediaList.take(3).map((media) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(media.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: media.type == 'video'
                        ? const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 28))
                        : null,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showMediaBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "All Media",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final mediaList = ctrl.mediaFiles;
                      if (mediaList.isEmpty) {
                        return const Center(child: Text("No media items.", style: TextStyle(color: _kMuted)));
                      }
                      return GridView.builder(
                        controller: controller,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: mediaList.length,
                        itemBuilder: (context, index) {
                          final media = mediaList[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: _kSurface,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(media.url),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: media.type == 'video'
                                ? const Center(child: Icon(Icons.play_circle_outline, color: Colors.white, size: 36))
                                : null,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
