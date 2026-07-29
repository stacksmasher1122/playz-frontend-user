import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupMediaSection extends StatelessWidget {
  final GroupInfoController ctrl;

  const GroupMediaSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: () => _showMediaBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        padding: EdgeInsets.all(context.widthPct(4)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MEDIA, LINKS AND DOCS",
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
              ],
            ),
            SizedBox(height: context.heightPct(1.5)),
            Obx(() {
              final mediaList = ctrl.mediaFiles;
              if (mediaList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                  child: Text(
                    "No media yet",
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                );
              }
              final mediaSize = context.minDimensionPct(18).clamp(60.0, 75.0);
              // Show up to 3 latest media icons
              return Row(
                children: mediaList.take(3).map((media) {
                  return Container(
                    margin: EdgeInsets.only(right: context.widthPct(3)),
                    width: mediaSize,
                    height: mediaSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(media.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: media.type == 'video'
                        ? const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: AppColors.textPrimary,
                              size: 28,
                            ),
                          )
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
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: context.heightPct(1.5),
                      bottom: context.heightPct(1),
                    ),
                    width: context.widthPct(10),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(context.widthPct(4)),
                    child: Text(
                      "All Media",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final mediaList = ctrl.mediaFiles;
                      if (mediaList.isEmpty) {
                        return Center(
                          child: Text(
                            "No media items.",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(14),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        controller: controller,
                        padding: EdgeInsets.all(context.widthPct(2)),
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
                              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                              color: AppColors.card,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(media.url),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: media.type == 'video'
                                ? const Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: AppColors.textPrimary,
                                      size: 36,
                                    ),
                                  )
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
