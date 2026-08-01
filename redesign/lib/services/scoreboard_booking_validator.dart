import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingValidationResult {
  final bool isAllowed;
  final String sportName;
  final String message;
  final String? timeRemainingText;

  const BookingValidationResult({
    required this.isAllowed,
    required this.sportName,
    required this.message,
    this.timeRemainingText,
  });
}

class ScoreboardBookingValidator {
  static const List<String> supportedSports = ['Cricket', 'Badminton'];
  static const int earlyAccessMinutes = 20;
  static const int bufferMinutes = 20;

  static BookingValidationResult validateBooking(
    Map<String, dynamic>? bookingData,
  ) {
    if (bookingData == null) {
      return const BookingValidationResult(
        isAllowed: false,
        sportName: 'Unknown',
        message: 'Invalid booking information provided.',
      );
    }

    final rawSport = (bookingData['sport'] ?? bookingData['sportName'] ?? '')
        .toString()
        .trim();
    String normalizedSport = 'Other';

    for (final s in supportedSports) {
      if (rawSport.toLowerCase().contains(s.toLowerCase())) {
        normalizedSport = s;
        break;
      }
    }

    // 1. Check if sport is ready/supported
    if (!supportedSports.contains(normalizedSport)) {
      return BookingValidationResult(
        isAllowed: false,
        sportName: rawSport.isEmpty ? 'This Sport' : rawSport,
        message:
            'Scoreboard is currently ready only for Cricket and Badminton. Scoreboards for $rawSport will be available soon!',
      );
    }

    // 2. Check booking status (Allow CONFIRMED, UPCOMING, ACTIVE, PAID, SCHEDULED, PENDING, BOOKED)
    final status = (bookingData['status'] ?? 'CONFIRMED')
        .toString()
        .toUpperCase();
    final invalidStatuses = [
      'CANCELLED',
      'REJECTED',
      'REFUNDED',
      'COMPLETED',
      'EXPIRED',
    ];
    if (invalidStatuses.contains(status)) {
      return BookingValidationResult(
        isAllowed: false,
        sportName: normalizedSport,
        message: 'Scoreboard access is not available for $status bookings.',
      );
    }

    // 3. Time Validation
    final now = DateTime.now();

    final dateStr =
        (bookingData['dateFormatted'] ??
                bookingData['date'] ??
                bookingData['bookingDate'] ??
                bookingData['slotDate'] ??
                '')
            .toString();
    final timeSlotStr =
        (bookingData['timeSlot'] ??
                bookingData['slotTime'] ??
                bookingData['slot'] ??
                bookingData['time'] ??
                bookingData['bookingTime'] ??
                '')
            .toString();

    final timeParsed = parseSlotWindow(dateStr, timeSlotStr);

    if (timeParsed != null) {
      final slotStart = timeParsed.$1;
      final slotEnd = timeParsed.$2;
      final slotStartWithEarlyAccess = slotStart.subtract(
        const Duration(minutes: earlyAccessMinutes),
      );
      final slotEndWithBuffer = slotEnd.add(
        const Duration(minutes: bufferMinutes),
      );

      if (now.isBefore(slotStartWithEarlyAccess)) {
        final diff = slotStartWithEarlyAccess.difference(now);
        final hrs = diff.inHours;
        final mins = diff.inMinutes % 60;
        final waitText = hrs > 0 ? '${hrs}h ${mins}m' : '${mins}m';

        return BookingValidationResult(
          isAllowed: false,
          sportName: normalizedSport,
          message:
              'Your slot is at ${DateFormat('jm').format(slotStart)}. Early scoreboard access will open 20 mins prior at ${DateFormat('jm').format(slotStartWithEarlyAccess)}.',
          timeRemainingText: 'Access opens in $waitText',
        );
      }

      if (now.isAfter(slotEndWithBuffer)) {
        return BookingValidationResult(
          isAllowed: false,
          sportName: normalizedSport,
          message:
              'Your booking time + 20 mins buffer expired at ${DateFormat('jm').format(slotEndWithBuffer)}. Scoreboard access is now closed.',
        );
      }

      final remaining = slotEndWithBuffer.difference(now);
      final remainingMins = remaining.inMinutes;

      return BookingValidationResult(
        isAllowed: true,
        sportName: normalizedSport,
        message: 'Access Granted! Your scoreboard session is active.',
        timeRemainingText: '$remainingMins mins left',
      );
    }

    // Default fallback if time slot format is non-standard
    return BookingValidationResult(
      isAllowed: true,
      sportName: normalizedSport,
      message: 'Access Granted for $normalizedSport!',
    );
  }

  static (DateTime, DateTime)? parseSlotWindow(
    String dateStr,
    String timeSlotStr,
  ) {
    try {
      DateTime baseDate = DateTime.now();

      final cleanDate = dateStr.trim();
      if (cleanDate.isNotEmpty && cleanDate.toLowerCase() != 'today') {
        final parsedDate = parseAnyDate(cleanDate);
        if (parsedDate != null) {
          baseDate = parsedDate;
        }
      }

      var rawTime = timeSlotStr.trim();
      if (rawTime.isEmpty && dateStr.contains(' ')) {
        final partsDate = dateStr.split(' ');
        if (partsDate.length > 1) {
          rawTime = partsDate.sublist(1).join(' ');
        }
      }

      final parts = rawTime.split(RegExp(r'[–\-]'));
      if (parts.length >= 2) {
        String startStr = _normalizeTimeString(parts[0]);
        String endStr = _normalizeTimeString(parts[1]);

        final hasPmInEnd = RegExp(r'PM', caseSensitive: false).hasMatch(endStr);
        final hasAmInEnd = RegExp(r'AM', caseSensitive: false).hasMatch(endStr);

        final hasPmInStart = RegExp(
          r'PM',
          caseSensitive: false,
        ).hasMatch(startStr);
        final hasAmInStart = RegExp(
          r'AM',
          caseSensitive: false,
        ).hasMatch(startStr);

        // Inherit AM/PM if end string specifies it and start does not
        if (hasPmInEnd && !hasPmInStart && !hasAmInStart) {
          startStr = '$startStr PM';
        } else if (hasAmInEnd && !hasPmInStart && !hasAmInStart) {
          startStr = '$startStr AM';
        }

        var startTime = _parseTimeOfDay(startStr);
        var endTime = _parseTimeOfDay(endStr);

        if (startTime != null && endTime != null) {
          var slotStart = DateTime(
            baseDate.year,
            baseDate.month,
            baseDate.day,
            startTime.hour,
            startTime.minute,
          );
          var slotEnd = DateTime(
            baseDate.year,
            baseDate.month,
            baseDate.day,
            endTime.hour,
            endTime.minute,
          );

          final now = DateTime.now();
          final isToday = baseDate.year == now.year && baseDate.month == now.month && baseDate.day == now.day;

          // Smart PM Adjustment for 12-hour turf slots (e.g. 7-8, 8-9, 9-10, 10-11)
          if (!hasAmInStart && !hasPmInStart && !hasAmInEnd && !hasPmInEnd) {
            if (slotStart.hour >= 1 && slotStart.hour <= 11) {
              final pmStart = slotStart.add(const Duration(hours: 12));
              final pmEnd = slotEnd.add(const Duration(hours: 12));
              if (isToday && slotEnd.isBefore(now) && pmEnd.isAfter(now)) {
                slotStart = pmStart;
                slotEnd = pmEnd;
              } else if (slotStart.hour >= 1 && slotStart.hour <= 6) {
                slotStart = pmStart;
                slotEnd = pmEnd;
              }
            }
          } else {
            if (slotStart.hour >= 1 && slotStart.hour <= 6 && !hasAmInStart && !hasAmInEnd) {
              slotStart = slotStart.add(const Duration(hours: 12));
            }
            if (slotEnd.hour >= 1 && slotEnd.hour <= 6 && !hasAmInEnd) {
              slotEnd = slotEnd.add(const Duration(hours: 12));
            }
          }

          if (slotEnd.isBefore(slotStart)) {
            slotEnd = slotEnd.add(const Duration(days: 1));
          }

          return (slotStart, slotEnd);
        }
      } else if (parts.length == 1 && parts[0].trim().isNotEmpty) {
        final norm = _normalizeTimeString(parts[0]);
        final startTime = _parseTimeOfDay(norm);
        if (startTime != null) {
          var slotStart = DateTime(
            baseDate.year,
            baseDate.month,
            baseDate.day,
            startTime.hour,
            startTime.minute,
          );
          if (slotStart.hour >= 1 &&
              slotStart.hour <= 6 &&
              !norm.toLowerCase().contains('am')) {
            slotStart = slotStart.add(const Duration(hours: 12));
          }
          final slotEnd = slotStart.add(const Duration(hours: 1));
          return (slotStart, slotEnd);
        }
      }
    } catch (_) {}
    return null;
  }

  static String _normalizeTimeString(String rawStr) {
    var s = rawStr.trim();
    s = s.replaceAllMapped(
      RegExp(r'(\d+)\s*([ap]\.?m\.?)', caseSensitive: false),
      (m) {
        return '${m[1]} ${m[2]!.toUpperCase().replaceAll('.', '')}';
      },
    );
    return s;
  }

  static TimeOfDay? _parseTimeOfDay(String timeStr) {
    try {
      var clean = timeStr.trim();
      if (clean.contains(' ') && RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(clean)) {
        clean = clean.replaceFirst(RegExp(r'^\d{4}-\d{2}-\d{2}\s*'), '');
      }

      final formats = [
        DateFormat('h:mm a'),
        DateFormat('hh:mm a'),
        DateFormat('h a'),
        DateFormat('HH:mm'),
        DateFormat('H:mm'),
        DateFormat('H'),
        DateFormat('h'),
      ];

      for (final fmt in formats) {
        try {
          final dt = fmt.parse(clean);
          return TimeOfDay(hour: dt.hour, minute: dt.minute);
        } catch (_) {}
      }
    } catch (_) {}
    return null;
  }

  static DateTime? parseAnyDate(String rawDateStr) {
    if (rawDateStr.trim().isEmpty) return null;

    var clean = rawDateStr.trim();
    if (clean.contains(' ')) {
      final firstPart = clean.split(' ')[0];
      if (DateTime.tryParse(firstPart) != null) {
        clean = firstPart;
      }
    }
    clean = clean.split(',')[0].trim();

    final tryDirect = DateTime.tryParse(clean);
    if (tryDirect != null) {
      return DateTime(tryDirect.year, tryDirect.month, tryDirect.day);
    }

    final origClean = rawDateStr.trim();
    final formats = [
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd MMM, yyyy'),
      DateFormat('dd MMM yyyy'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MMM dd, yyyy'),
      DateFormat('E, dd MMM yyyy'),
      DateFormat('E, dd MMM'),
      DateFormat('dd MMM'),
    ];

    for (final strToTry in [clean, origClean]) {
      for (final fmt in formats) {
        try {
          final dt = fmt.parse(strToTry);
          final now = DateTime.now();
          return DateTime(dt.year == 1970 ? now.year : dt.year, dt.month, dt.day);
        } catch (_) {}
      }
    }
    return null;
  }
}
