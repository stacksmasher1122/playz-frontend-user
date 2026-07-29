import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/services/scoreboard_booking_validator.dart';
import 'booking_card_upcoming.dart';
import 'empty_state.dart';
import 'package:redesign/theme/responsive_helper.dart';

class UpcomingBookingsWidget extends StatelessWidget {
  const UpcomingBookingsWidget({super.key});

  bool _isUpcoming(Map<String, dynamic> data) {
    final status = (data['status'] ?? '').toString().toLowerCase();
    if (status == 'cancelled' || status == 'rejected' || status == 'refunded' || status == 'completed' || status == 'expired') {
      return false;
    }

    final dateStr = (data['dateFormatted'] ?? data['date'] ?? data['bookingDate'] ?? '').toString();
    final timeSlotStr = (data['timeSlot'] ?? data['slotTime'] ?? data['slot'] ?? data['time'] ?? '').toString();

    final timeParsed = ScoreboardBookingValidator.parseSlotWindow(dateStr, timeSlotStr);
    if (timeParsed != null) {
      final slotEnd = timeParsed.$2;
      final slotEndWithBuffer = slotEnd.add(const Duration(minutes: ScoreboardBookingValidator.bufferMinutes));
      if (DateTime.now().isAfter(slotEndWithBuffer)) {
        return false;
      }
    } else if (dateStr.isNotEmpty) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) {
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);
        final bookingMidnight = DateTime(parsed.year, parsed.month, parsed.day);
        if (bookingMidnight.isBefore(todayMidnight)) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<String?>(
      future: UserPreferences.getDocId(),
      builder: (context, docSnap) {
        final userId = docSnap.data ?? user?.email ?? user?.uid ?? '';

        if (userId.isEmpty) {
          return const Center(
            child: BookingsEmptyState(
              icon: Icons.lock_outline,
              text: 'Please sign in to view your bookings',
            ),
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc(userId)
              .collection('bookings')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(context.widthPct(8)),
                  child: const CircularProgressIndicator(color: AppColors.accent),
                ),
              );
            }

            final docs = snapshot.data?.docs ?? [];
            final upcomingDocs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};
              return _isUpcoming(data);
            }).toList();

            if (upcomingDocs.isEmpty) {
              return const Center(
                child: BookingsEmptyState(
                  icon: Icons.calendar_today_outlined,
                  text: 'No upcoming bookings found',
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: context.heightPct(4)),
              itemCount: upcomingDocs.length,
              itemBuilder: (context, index) {
                final data = upcomingDocs[index].data() as Map<String, dynamic>;
                return BookingCardUpcoming(bookingData: data);
              },
            );
          },
        );
      },
    );
  }
}
