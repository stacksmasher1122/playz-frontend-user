import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/services/scoreboard_booking_validator.dart';
import 'completed_booking_card.dart';
import 'empty_state.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PastBookingsWidget extends StatelessWidget {
  const PastBookingsWidget({super.key});

  bool _isPast(Map<String, dynamic> data) {
    final status = (data['status'] ?? '').toString().toLowerCase();
    if (status == 'completed' || status == 'expired') return true;
    if (status == 'cancelled' || status == 'rejected' || status == 'refunded') return false;

    final dateStr = (data['dateFormatted'] ?? data['date'] ?? data['bookingDate'] ?? '').toString();
    final timeSlotStr = (data['timeSlot'] ?? data['slotTime'] ?? data['slot'] ?? data['time'] ?? '').toString();

    final timeParsed = ScoreboardBookingValidator.parseSlotWindow(dateStr, timeSlotStr);
    if (timeParsed != null) {
      final slotEnd = timeParsed.$2;
      final slotEndWithBuffer = slotEnd.add(const Duration(minutes: ScoreboardBookingValidator.bufferMinutes));
      if (DateTime.now().isAfter(slotEndWithBuffer)) {
        return true;
      }
    } else if (dateStr.isNotEmpty) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) {
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);
        final bookingMidnight = DateTime(parsed.year, parsed.month, parsed.day);
        if (bookingMidnight.isBefore(todayMidnight)) {
          return true;
        }
      }
    }
    return false;
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
            final pastDocs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};
              return _isPast(data);
            }).toList();

            if (pastDocs.isEmpty) {
              return const Center(
                child: BookingsEmptyState(
                  icon: Icons.history,
                  text: 'No past bookings found',
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(
                context.widthPct(4),
                context.heightPct(1.5),
                context.widthPct(4),
                context.heightPct(4),
              ),
              itemCount: pastDocs.length,
              itemBuilder: (context, index) {
                final doc = pastDocs[index];
                final data = Map<String, dynamic>.from(
                    doc.data() as Map<String, dynamic>);
                data['bookingId'] = doc.id;
                return Padding(
                  padding: EdgeInsets.only(bottom: context.heightPct(1.5)),
                  child: CompletedBookingCard(bookingData: data),
                );
              },
            );
          },
        );
      },
    );
  }
}
