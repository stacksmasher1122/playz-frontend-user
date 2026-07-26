import 'package:cloud_firestore/cloud_firestore.dart';

class SlotModel {
  final String id;
  final String timeRange;
  final String slotType;
  final double price;
  final String assignedSport;
  final String status;
  final bool isAvailable;
  final bool isBooked;
  final bool isPeak;
  final String? bookerName;
  final String? bookerPhone;
  final String? bookingType;
  final String? blockReason;
  final DateTime? bookingTimestamp;

  SlotModel({
    required this.id,
    required this.timeRange,
    required this.slotType,
    required this.price,
    required this.assignedSport,
    required this.status,
    required this.isAvailable,
    required this.isBooked,
    required this.isPeak,
    this.bookerName,
    this.bookerPhone,
    this.bookingType,
    this.blockReason,
    this.bookingTimestamp,
  });

  factory SlotModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return SlotModel(
      id: data['id'] ?? doc.id,
      timeRange: data['timeRange'] ?? '',
      slotType: data['slotType'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      assignedSport: data['assignedSport'] ?? '',
      status: data['status'] ?? 'available',
      isAvailable: data['isAvailable'] ?? true,
      isBooked: data['isBooked'] ?? false,
      isPeak: data['isPeak'] ?? false,
      bookerName: data['bookerName'],
      bookerPhone: data['bookerPhone'],
      bookingType: data['bookingType'],
      blockReason: data['blockReason'],
      bookingTimestamp: (data['bookingTimestamp'] as Timestamp?)?.toDate(),
    );
  }

  SlotModel copyWith({
    bool? isAvailable,
    bool? isBooked,
    String? status,
  }) {
    return SlotModel(
      id: id,
      timeRange: timeRange,
      slotType: slotType,
      price: price,
      assignedSport: assignedSport,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      isBooked: isBooked ?? this.isBooked,
      isPeak: isPeak,
      bookerName: bookerName,
      bookerPhone: bookerPhone,
      bookingType: bookingType,
      blockReason: blockReason,
      bookingTimestamp: bookingTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timeRange': timeRange,
      'slotType': slotType,
      'price': price,
      'assignedSport': assignedSport,
      'status': status,
      'isAvailable': isAvailable,
      'isBooked': isBooked,
      'isPeak': isPeak,
      'bookerName': bookerName,
      'bookerPhone': bookerPhone,
      'bookingType': bookingType,
      'blockReason': blockReason,
      'bookingTimestamp': bookingTimestamp != null
          ? Timestamp.fromDate(bookingTimestamp!)
          : null,
    };
  }

  /// Parse start hour from timeRange (supports 12-hr AM/PM and 24-hr formats)
  int? get startHour {
    try {
      final parts = timeRange.split(RegExp(r'\s*[-–]\s*'));
      if (parts.isEmpty) return null;
      final fullRangeIsPm = timeRange.toUpperCase().contains('PM');
      return parseHourFromString(parts[0], defaultIsPm: fullRangeIsPm && !parts[0].toUpperCase().contains('AM'));
    } catch (_) {
      return null;
    }
  }

  /// Parse end hour from timeRange (supports 12-hr AM/PM and 24-hr formats)
  int? get endHour {
    try {
      final parts = timeRange.split(RegExp(r'\s*[-–]\s*'));
      if (parts.length < 2) return null;
      final fullRangeIsPm = timeRange.toUpperCase().contains('PM');
      final hour = parseHourFromString(parts[1], defaultIsPm: fullRangeIsPm && !parts[1].toUpperCase().contains('AM'));
      if (hour == 0 && (parts[1].toUpperCase().contains('12') || parts[1].toUpperCase().contains('00'))) {
        return 24;
      }
      return hour;
    } catch (_) {
      return null;
    }
  }

  /// Helper to parse hour int (0..23) from 12-hr or 24-hr time strings
  static int? parseHourFromString(String text, {bool? defaultIsPm}) {
    if (text.trim().isEmpty) return null;
    final clean = text.trim().toUpperCase();

    final isPM = clean.contains('PM') || (defaultIsPm == true && !clean.contains('AM'));
    final isAM = clean.contains('AM') && !clean.contains('PM');

    // Remove AM / PM and spaces
    final numOnly = clean.replaceAll('AM', '').replaceAll('PM', '').trim();
    final parts = numOnly.split(':');
    if (parts.isEmpty) return null;

    int? hour = int.tryParse(parts[0].trim());
    if (hour == null) return null;

    if (isPM && hour != 12) {
      hour += 12;
    } else if (isAM && hour == 12) {
      hour = 0;
    }

    return hour % 24;
  }
}
