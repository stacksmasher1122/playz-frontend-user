import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a time interval as minutes from midnight.
/// startMinutes: 0 (midnight) to 1440
/// endMinutes: must be > startMinutes
class TimeInterval {
  final int startMinutes;
  final int endMinutes;

  TimeInterval(this.startMinutes, this.endMinutes);

  /// Two intervals overlap if max(startA, startB) < min(endA, endB)
  bool overlapsWith(TimeInterval other) {
    return max(startMinutes, other.startMinutes) < min(endMinutes, other.endMinutes);
  }

  @override
  String toString() => 'TimeInterval($startMinutes–$endMinutes min)';
}

class SlotOverlapHelper {
  /// Parse a single time string like "4:00 PM", "11:00 AM", "18:00" into minutes from midnight.
  static int parseSingleTimeToMinutes(String s) {
    try {
      final clean = s.toUpperCase().replaceAll(RegExp(r'\s+'), '');
      final isPm = clean.contains('PM');
      final isAm = clean.contains('AM');
      final digits = clean.replaceAll('AM', '').replaceAll('PM', '');

      int hour = 0;
      int minute = 0;

      if (digits.contains(':')) {
        final parts = digits.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      } else {
        hour = int.parse(digits);
      }

      if (isPm && hour < 12) hour += 12;
      if (isAm && hour == 12) hour = 0;

      return hour * 60 + minute;
    } catch (e) {
      debugPrint('⚠️ SlotOverlapHelper.parseSingleTimeToMinutes failed for "$s": $e');
      return -1;
    }
  }

  /// Parse a time range string into a TimeInterval.
  /// Handles formats like:
  ///   "4:00 PM - 7:00 PM"     (hyphen)
  ///   "4:00 PM – 7:00 PM"     (en-dash)
  ///   "4:00 PM — 7:00 PM"     (em-dash)
  ///   "2026-07-26, 4:00 PM - 7:00 PM"  (date prefix)
  static TimeInterval? parseTimeRange(String timeStr) {
    if (timeStr.isEmpty) return null;

    try {
      // 1. Normalize all dash variants to a standard pipe delimiter "|"
      String normalized = timeStr
          .replaceAll('–', '|')  // en-dash
          .replaceAll('—', '|'); // em-dash

      // 2. Remove date prefix (e.g., "2026-07-26, " or "Mon, 26 Jul, ")
      if (normalized.contains(',')) {
        normalized = normalized.split(',').last.trim();
      }

      // 3. If we have a pipe delimiter from en/em-dash replacement, split on that
      if (normalized.contains('|')) {
        final parts = normalized.split('|');
        if (parts.length >= 2) {
          final startM = parseSingleTimeToMinutes(parts[0].trim());
          final endM = parseSingleTimeToMinutes(parts[1].trim());
          if (startM < 0 || endM < 0) return null;
          final finalEnd = endM > startM ? endM : (endM == 0 ? 1440 : endM + 1440);
          return TimeInterval(startM, finalEnd);
        }
      }

      // 4. Try splitting on " - " (space-hyphen-space)
      if (normalized.contains(' - ')) {
        final parts = normalized.split(' - ');
        if (parts.length >= 2) {
          final startM = parseSingleTimeToMinutes(parts[0].trim());
          final endM = parseSingleTimeToMinutes(parts[1].trim());
          if (startM < 0 || endM < 0) return null;
          final finalEnd = endM > startM ? endM : (endM == 0 ? 1440 : endM + 1440);
          return TimeInterval(startM, finalEnd);
        }
      }

      // 5. Fallback: try regex for AM/PM time range matching
      if (normalized.contains('-')) {
        final upper = normalized.toUpperCase();
        if (upper.contains('AM') || upper.contains('PM')) {
          final amPmPattern = RegExp(r'(\d{1,2}:\d{2}\s*(?:AM|PM))\s*-\s*(\d{1,2}:\d{2}\s*(?:AM|PM))', caseSensitive: false);
          final match = amPmPattern.firstMatch(normalized);
          if (match != null) {
            final startM = parseSingleTimeToMinutes(match.group(1)!);
            final endM = parseSingleTimeToMinutes(match.group(2)!);
            if (startM < 0 || endM < 0) return null;
            final finalEnd = endM > startM ? endM : (endM == 0 ? 1440 : endM + 1440);
            return TimeInterval(startM, finalEnd);
          }
        }
      }

      // 6. Single time value — assume 1-hour slot
      final singleM = parseSingleTimeToMinutes(normalized.trim());
      if (singleM >= 0) {
        return TimeInterval(singleM, singleM + 60);
      }

      return null;
    } catch (e) {
      debugPrint('⚠️ SlotOverlapHelper.parseTimeRange failed for "$timeStr": $e');
      return null;
    }
  }

  /// Extract the time range string from a Firestore booking document.
  static String? _extractTimeStr(Map<String, dynamic> data) {
    // Priority 1: Combined time field
    final time = (data['time'] ?? '').toString().trim();
    if (time.isNotEmpty && (time.contains('-') || time.contains('–') || time.contains('—'))) {
      return time;
    }

    // Priority 2: timeSlot field (from normal bookings — uses en-dash)
    final timeSlot = (data['timeSlot'] ?? '').toString().trim();
    if (timeSlot.isNotEmpty) {
      return timeSlot;
    }

    // Priority 3: Separate startTime + endTime fields
    final startTime = (data['startTime'] ?? '').toString().trim();
    final endTime = (data['endTime'] ?? '').toString().trim();
    if (startTime.isNotEmpty && endTime.isNotEmpty) {
      return '$startTime - $endTime';
    }

    return null;
  }

  /// Check if [newTimeRangeStr] overlaps with ANY existing confirmed booking
  /// or officially booked match poll for the same turf, ground, and date in Firestore.
  ///
  /// [currentMatchId] — if provided, this match document is excluded from
  /// the overlap check (so a poll doesn't self-block when the host confirms).
  static Future<bool> isSlotOverlappingInFirestore({
    required String ownerId,
    required String turfId,
    required String groundId,
    required String dateStr,
    required String newTimeRangeStr,
    String? currentMatchId,
  }) async {
    try {
      if (turfId.isEmpty || groundId.isEmpty || dateStr.isEmpty) {
        debugPrint('⚠️ isSlotOverlappingInFirestore: empty turfId/groundId/dateStr — skipping');
        return false;
      }

      final newInterval = parseTimeRange(newTimeRangeStr);
      if (newInterval == null) {
        debugPrint('⚠️ isSlotOverlappingInFirestore: could not parse new time range "$newTimeRangeStr"');
        return false;
      }

      debugPrint('🔍 Checking overlap for NEW interval: $newInterval (from "$newTimeRangeStr")');
      debugPrint('   turfId=$turfId, groundId=$groundId, date=$dateStr, ownerId=$ownerId');

      // ── Step 1: Check collectionGroup('bookings') AND owners/{ownerId}/turfs/{turfId}/bookings ──
      try {
        final groupSnap = await FirebaseFirestore.instance
            .collectionGroup('bookings')
            .where('date', isEqualTo: dateStr)
            .get();

        for (var doc in groupSnap.docs) {
          final data = doc.data();
          final status = (data['status'] ?? '').toString().toLowerCase();
          if (status == 'cancelled') continue;

          final bTurfId = (data['turfId'] ?? '').toString();
          if (bTurfId.isNotEmpty && bTurfId != turfId) continue;

          final bGroundId = (data['groundId'] ?? '').toString();
          if (bGroundId.isNotEmpty && bGroundId != groundId) continue;

          final existingTimeStr = _extractTimeStr(data);
          if (existingTimeStr == null) continue;

          final existingInterval = parseTimeRange(existingTimeStr);
          if (existingInterval == null) continue;

          if (newInterval.overlapsWith(existingInterval)) {
            debugPrint('🛑 BOOKING OVERLAP: New $newInterval overlaps confirmed booking $existingInterval '
                '(timeStr="$existingTimeStr", docId=${doc.id})');
            return true;
          }
        }
      } catch (e) {
        debugPrint('⚠️ collectionGroup query error/fallback: $e');
        if (ownerId.isNotEmpty) {
          final bookingSnap = await FirebaseFirestore.instance
              .collection('owners')
              .doc(ownerId)
              .collection('turfs')
              .doc(turfId)
              .collection('bookings')
              .where('date', isEqualTo: dateStr)
              .get();

          for (var doc in bookingSnap.docs) {
            final data = doc.data();
            final status = (data['status'] ?? '').toString().toLowerCase();
            if (status == 'cancelled') continue;

            final bGroundId = (data['groundId'] ?? '').toString();
            if (bGroundId.isNotEmpty && bGroundId != groundId) continue;

            final existingTimeStr = _extractTimeStr(data);
            if (existingTimeStr == null) continue;

            final existingInterval = parseTimeRange(existingTimeStr);
            if (existingInterval == null) continue;

            if (newInterval.overlapsWith(existingInterval)) {
              debugPrint('🛑 BOOKING OVERLAP: New $newInterval overlaps booking $existingInterval (docId=${doc.id})');
              return true;
            }
          }
        }
      }

      // ── Step 2: Check matches collection ONLY for match polls where isSlotBooked == true ──
      try {
        final matchSnap = await FirebaseFirestore.instance
            .collection('matches')
            .where('turfId', isEqualTo: turfId)
            .where('groundId', isEqualTo: groundId)
            .where('date', isEqualTo: dateStr)
            .where('isSlotBooked', isEqualTo: true)
            .get();

        for (var doc in matchSnap.docs) {
          if (currentMatchId != null && doc.id == currentMatchId) continue;

          final data = doc.data();
          final status = (data['status'] ?? '').toString().toLowerCase();
          if (status == 'cancelled' || status == 'expired') continue;

          final existingTimeStr = _extractTimeStr(data);
          if (existingTimeStr == null) continue;

          final existingInterval = parseTimeRange(existingTimeStr);
          if (existingInterval == null) continue;

          if (newInterval.overlapsWith(existingInterval)) {
            debugPrint('🛑 BOOKED MATCH POLL OVERLAP: New $newInterval overlaps booked match poll $existingInterval '
                '(timeStr="$existingTimeStr", docId=${doc.id})');
            return true;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error querying matches for overlap: $e');
      }

      debugPrint('✅ No overlap detected for "$newTimeRangeStr" on $dateStr');
      return false;
    } catch (e) {
      debugPrint('🔴 isSlotOverlappingInFirestore top-level error: $e');
      return false;
    }
  }
}
