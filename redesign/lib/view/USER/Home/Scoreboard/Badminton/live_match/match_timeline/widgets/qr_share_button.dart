import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrShareButton extends StatelessWidget {
  final VoidCallback onTap;

  QrShareButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: Colors.grey.shade700),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.qr_code_2,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'QR SHARE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(14),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
