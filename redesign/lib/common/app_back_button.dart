import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A standardized, modern rounded-corner back button widget designed for PlayZ dark theme.
/// 
/// Usage:
/// ```dart
/// const AppBackButton()
/// ```
/// Or custom callback/style:
/// ```dart
/// AppBackButton(
///   onPressed: () => print('Custom back'),
///   backgroundColor: AppColors.surfaceElevated,
/// )
/// ```
class AppBackButton extends StatelessWidget {
  /// Custom action on press. Defaults to `Navigator.of(context).maybePop()` / `Get.back()`.
  final VoidCallback? onPressed;

  /// Overall size (width & height) of the back button tile.
  final double? size;

  /// Size of the back arrow icon.
  final double? iconSize;

  /// Color of the back arrow icon. Defaults to [AppColors.textPrimary].
  final Color? iconColor;

  /// Background color of the rounded button container. Defaults to [AppColors.card].
  final Color? backgroundColor;

  /// Border color around the button container. Defaults to [AppColors.borderDark].
  final Color? borderColor;

  /// Border width. Defaults to `1.0`.
  final double borderWidth;

  /// Border radius of the container. Defaults to `BorderRadius.circular(12)`.
  final BorderRadius? borderRadius;

  /// Icon to display. Defaults to [Icons.arrow_back_ios_new_rounded].
  final IconData icon;

  /// Padding around the icon inside the button container.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the button.
  final EdgeInsetsGeometry? margin;

  /// Optional tooltip label for accessibility.
  final String tooltip;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.size,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.padding,
    this.margin,
    this.tooltip = 'Back',
  });

  void _handleBack(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final double effectiveSize = size ?? context.minDimensionPct(10).clamp(36.0, 44.0);
    final double effectiveIconSize = iconSize ?? (effectiveSize * 0.45).clamp(16.0, 22.0);
    final Color effectiveBgColor = backgroundColor ?? AppColors.card;
    final Color effectiveBorderColor = borderColor ?? AppColors.borderDark;
    final Color effectiveIconColor = iconColor ?? AppColors.textPrimary;
    final BorderRadius effectiveRadius = borderRadius ?? BorderRadius.circular(10.0);

    Widget buttonTile = Container(
      width: effectiveSize,
      height: effectiveSize,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: effectiveIconSize,
          color: effectiveIconColor,
        ),
      ),
    );

    return Container(
      margin: margin,
      child: Center(
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            borderRadius: effectiveRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: effectiveRadius,
              splashColor: AppColors.accent.withValues(alpha: 0.15),
              highlightColor: AppColors.accent.withValues(alpha: 0.08),
              onTap: () => _handleBack(context),
              child: buttonTile,
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience alias for [AppBackButton] to maintain backwards compatibility
/// across common widget imports.
typedef CommonBackButton = AppBackButton;
