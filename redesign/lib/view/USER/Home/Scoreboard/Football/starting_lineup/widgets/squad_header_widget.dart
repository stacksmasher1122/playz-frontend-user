import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SquadHeaderWidget extends StatelessWidget {
  final VoidCallback onFilter;
  final VoidCallback onSearch;

  SquadHeaderWidget({
    super.key,
    required this.onFilter,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Squad Hub',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(20),
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            children: [
              _buildIconButton(Icons.filter_list, onFilter),
              SizedBox(width: 12),
              _buildIconButton(Icons.search, onSearch),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(8)),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
