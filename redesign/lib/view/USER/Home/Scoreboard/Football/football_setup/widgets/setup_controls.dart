import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StepperControl extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;
  final int step;
  final int min;
  final int max;

  StepperControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 1,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: kTextSecondary, fontSize: 15),
        ),
        Container(
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: kTextMuted, size: 18),
                onPressed: value > min ? () => onChanged(value - step) : null,
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Container(
                  constraints: BoxConstraints(minWidth: 24),
                  alignment: Alignment.center,
                  child: Text(
                    "$value",
                    key: ValueKey(value),
                    style: TextStyle(
                      color: kTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(16),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: kTextMuted, size: 18),
                onPressed: value < max ? () => onChanged(value + step) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SetupSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  SetupSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SwitchListTile(
      title: Text(
        label,
        style: TextStyle(color: kTextSecondary, fontSize: 14),
      ),
      value: value,
      activeThumbColor: kAccent,
      contentPadding: EdgeInsets.zero,
      dense: true,
      onChanged: onChanged,
    );
  }
}

class SetupTextField extends StatelessWidget {
  final String label;
  final String initialValue;

  SetupTextField({
    super.key,
    required this.label,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return TextFormField(
      initialValue: initialValue,
      style: TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kTextMuted),
        filled: true,
        fillColor: kSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class SegmentedControl extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onSelect;

  SegmentedControl({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(40),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          bool isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.all(ResponsiveHelper.w(4)),
                decoration: BoxDecoration(
                  color: isSelected ? kSurfaceHighlight : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  border: isSelected
                      ? Border.all(color: kAccent.withValues(alpha: 0.5))
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  options[index],
                  style: TextStyle(
                    color: isSelected ? kAccent : kTextMuted,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
