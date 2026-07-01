import 'package:flutter/material.dart';
import '../../../../../../../theme/responsive_helper.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Center(
      child: CircularProgressIndicator(color: Color(0xFFC6FF00)),
    );
  }
}
