import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kGreen = AppColors.accent;

class StudentTypeSelector extends StatefulWidget {
  const StudentTypeSelector({super.key});

  @override
  State<StudentTypeSelector> createState() => _StudentTypeSelectorState();
}

class _StudentTypeSelectorState extends State<StudentTypeSelector> {
  String selected = 'Kids';

  final List<String> types = ['Kids', 'Adults', 'Women Only'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: types.map((type) {
            final bool active = type == selected;
            return GestureDetector(
              onTap: () => setState(() => selected = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: active ? kGreen : Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kGreen, width: 1),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: active ? Colors.black : kGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
