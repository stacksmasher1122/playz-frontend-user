import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchBreakTimerSheet extends StatefulWidget {
  const MatchBreakTimerSheet({super.key});

  @override
  State<MatchBreakTimerSheet> createState() => _MatchBreakTimerSheetState();
}

class _MatchBreakTimerSheetState extends State<MatchBreakTimerSheet> {
  int _secondsRemaining = 300; // Default 5 minutes
  int _initialSeconds = 300;
  Timer? _timer;
  bool _isRunning = false;
  int _incrementStepMinutes = 1;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_secondsRemaining <= 0) return;
    setState(() => _isRunning = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _secondsRemaining = 0;
            _isRunning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Match break timer finished!'),
              backgroundColor: AppColors.accent,
            ),
          );
          Navigator.pop(context);
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (mounted) {
      setState(() => _isRunning = false);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _secondsRemaining = _initialSeconds;
        _isRunning = false;
      });
    }
  }

  void _adjustTime(int minutes) {
    setState(() {
      _secondsRemaining = (_secondsRemaining + minutes * 60).clamp(0, 3599);
      if (!_isRunning) {
        _initialSeconds = _secondsRemaining;
      }
    });
  }

  String get _formattedTime {
    final mins = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(
        left: ResponsiveHelper.w(20),
        right: ResponsiveHelper.w(20),
        top: ResponsiveHelper.h(16),
        bottom: MediaQuery.of(context).viewInsets.bottom + ResponsiveHelper.h(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MATCH BREAK TIMER',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.muted,
                  size: ResponsiveHelper.sp(22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _adjustTime(-_incrementStepMinutes),
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: AppColors.warning,
                  size: ResponsiveHelper.sp(36),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(24),
                  vertical: ResponsiveHelper.h(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _formattedTime,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(38),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16)),
              IconButton(
                onPressed: () => _adjustTime(_incrementStepMinutes),
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.accent,
                  size: ResponsiveHelper.sp(36),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step: ',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(12),
                ),
              ),
              ChoiceChip(
                label: Text('1 min', style: TextStyle(fontSize: ResponsiveHelper.sp(11))),
                selected: _incrementStepMinutes == 1,
                selectedColor: AppColors.accent.withValues(alpha: 0.2),
                onSelected: (val) => setState(() => _incrementStepMinutes = 1),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              ChoiceChip(
                label: Text('5 min', style: TextStyle(fontSize: ResponsiveHelper.sp(11))),
                selected: _incrementStepMinutes == 5,
                selectedColor: AppColors.accent.withValues(alpha: 0.2),
                onSelected: (val) => setState(() => _incrementStepMinutes = 5),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(20)),
          Row(
            children: [
              if (_secondsRemaining != _initialSeconds || _isRunning) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetTimer,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.muted),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      ),
                    ),
                    child: Text(
                      'RESET',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? AppColors.warning : AppColors.accent,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                    ),
                  ),
                  child: Text(
                    _isRunning ? 'PAUSE TIMER' : 'START TIMER',
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveHelper.sp(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
