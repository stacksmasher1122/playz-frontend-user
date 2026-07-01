import 'package:flutter/material.dart';

class RosterHeaderWidget extends StatelessWidget {
  const RosterHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Active Roster',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _buildIconButton(Icons.filter_list, () {
                // filter sheet
              }),
              const SizedBox(width: 8),
              _buildIconButton(Icons.search, () {
                // search logic or show search bar
                // for simplicity, showing a snackbar here, ideally expands a search field
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Icon(icon, color: Colors.grey, size: 20),
      ),
    );
  }
}
