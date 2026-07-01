import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ExportPdfButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  ExportPdfButton({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
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
          child: isLoading
              ? SizedBox(
                  width: ResponsiveHelper.w(20),
                  height: ResponsiveHelper.h(20),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'EXPORT PDF',
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
