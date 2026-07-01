import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BulkImportButton extends StatelessWidget {
  final VoidCallback onTap;

  BulkImportButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_upload_outlined, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Bulk Import',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
