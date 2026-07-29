import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'cancelled_booking_card.dart';
import 'empty_state.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CancelledBookingsWidget extends StatelessWidget {
  const CancelledBookingsWidget({super.key});

  bool _isCancelled(Map<String, dynamic> data) {
    final status = (data['status'] ?? '').toString().toLowerCase();
    return status == 'cancelled' || status == 'rejected' || status == 'refunded';
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
            final cancelledDocs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};
              return _isCancelled(data);
            }).toList();

            if (cancelledDocs.isEmpty) {
              return const Center(
                child: BookingsEmptyState(
                  icon: Icons.cancel_outlined,
                  text: 'No cancelled bookings found',
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
              itemCount: cancelledDocs.length,
              itemBuilder: (context, index) {
                final data = cancelledDocs[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: EdgeInsets.only(bottom: context.heightPct(1.5)),
                  child: CancelledBookingCard(bookingData: data),
                );
              },
            );
          },
        );
      },
    );
  }
}
