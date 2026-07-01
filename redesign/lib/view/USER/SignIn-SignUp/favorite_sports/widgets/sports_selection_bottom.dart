import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';


class SportsSelectionBottom extends StatelessWidget {
  final int selectedCount;
  final bool canProceed;
  final VoidCallback onNext;

  SportsSelectionBottom({
    super.key,
    required this.selectedCount,
    required this.canProceed,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const kMuted = Color(0xFFA7A7A7);
    const kCard = Color(0xFF282828);

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.black.withValues(alpha: 0.0)],
        ),
      ),
      child: Column(
        children: [
          Text(
            '$selectedCount of 4 sports selected',
            style: TextStyle(
              color: canProceed ? Colors.white : kMuted,
              fontSize: ResponsiveHelper.sp(13),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(56),
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed
                    ? Color(0xFF384358)
                    : kCard,
                disabledBackgroundColor: Color(0xFF20242F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(28)),
                ),
                elevation: 0,
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.w700,
                  color: canProceed ? Colors.white : Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
