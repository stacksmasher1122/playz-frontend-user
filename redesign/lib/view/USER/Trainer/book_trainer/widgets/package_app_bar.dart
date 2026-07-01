import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);

class PackageAppBar extends StatelessWidget {
  PackageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final topInset = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 16),
          decoration: BoxDecoration(color: Colors.black54),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose a Package',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Select a plan that fits your goals',
                      style: TextStyle(color: kMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
