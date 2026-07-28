import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _bookingController = Get.find<BookingController>();
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _bookingController.searchQuery.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final barHeight = context.heightPct(6).clamp(44.0, 52.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: Container(
        height: barHeight,
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.muted),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: TextField(
                controller: _textController,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(13),
                ),
                decoration: InputDecoration(
                  hintText: 'Search turfs, sports, or venues...',
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  _bookingController.searchQuery.value = val;
                  setState(() {});
                },
              ),
            ),
            Obx(() {
              final query = _bookingController.searchQuery.value;
              if (query.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  _textController.clear();
                  _bookingController.searchQuery.value = '';
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.only(left: context.widthPct(2)),
                  child: const Icon(Icons.close, color: AppColors.muted, size: 18),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
