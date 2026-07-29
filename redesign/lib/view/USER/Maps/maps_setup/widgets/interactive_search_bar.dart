import 'package:flutter/material.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class InteractiveSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final MapsController mapsCtrl;

  const InteractiveSearchBar({
    super.key,
    required this.controller,
    required this.mapsCtrl,
  });

  @override
  State<InteractiveSearchBar> createState() => _InteractiveSearchBarState();
}

class _InteractiveSearchBarState extends State<InteractiveSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
        border: Border.all(
          color: _isFocused ? AppColors.accent : AppColors.borderDark,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        cursorColor: AppColors.accent,
        style: AppTypography.bodySm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(14),
        ),
        decoration: InputDecoration(
          hintText: "Search turfs, areas, or streets...",
          hintStyle: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13),
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.muted, size: 20),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppColors.muted, size: 18),
                  onPressed: () {
                    widget.controller.clear();
                    widget.mapsCtrl.searchResults.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: context.heightPct(1.2)),
        ),
        onChanged: (query) {
          setState(() {});
          widget.mapsCtrl.searchPlaces(query);
        },
      ),
    );
  }
}
