import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class MapPickerBottomCard extends StatelessWidget {
  final Widget addressPreview;
  final Widget confirmButton;

  const MapPickerBottomCard({
    super.key,
    required this.addressPreview,
    required this.confirmButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Location info with AnimatedSwitcher
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSpotifyGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on, color: kSpotifyGreen),
              ),
              const SizedBox(width: 12),
              Expanded(child: addressPreview),
            ],
          ),

          const SizedBox(height: 20),

          // Confirm button with state logic
          confirmButton,
        ],
      ),
    );
  }
}
