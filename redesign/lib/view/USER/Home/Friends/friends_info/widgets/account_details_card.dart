import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/player_info_model.dart';
import 'info_detail_row.dart';

const Color _kGreen = AppColors.accent;
const Color _kSurface = Color(0xFF222222);

class AccountDetailsCard extends StatelessWidget {
  final PlayerInfoModel info;

  const AccountDetailsCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ACCOUNT DETAILS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              InfoDetailRow(
                icon: Icons.alternate_email,
                title: "Username",
                value: info.username,
                valueColor: _kGreen,
              ),
              const Divider(
                color: Colors.white12,
                height: 1,
                indent: 20,
                endIndent: 20,
              ),
              InfoDetailRow(
                icon: Icons.calendar_today_outlined,
                title: "Joined",
                value: info.joinedAt != null
                    ? DateFormat('MMM yyyy').format(info.joinedAt!)
                    : "-",
                valueColor: Colors.white,
              ),
              const Divider(
                color: Colors.white12,
                height: 1,
                indent: 20,
                endIndent: 20,
              ),
              InfoDetailRow(
                icon: Icons.people_outline,
                title: "Friends since",
                value: info.friendsSince != null
                    ? DateFormat('MMM yyyy').format(info.friendsSince!)
                    : "-",
                valueColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
