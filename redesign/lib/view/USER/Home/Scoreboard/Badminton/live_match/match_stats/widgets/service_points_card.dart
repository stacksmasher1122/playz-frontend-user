import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ServicePointsCard extends StatefulWidget {
  final double percentage; // 0.0 to 1.0

  ServicePointsCard({
    super.key,
    required this.percentage,
  });

  @override
  State<ServicePointsCard> createState() => _ServicePointsCardState();
}

class _ServicePointsCardState extends State<ServicePointsCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ServicePointsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _controller.duration = Duration(milliseconds: 500);
      _animation = Tween<double>(
        begin: oldWidget.percentage, 
        end: widget.percentage,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SERVICE POINTS WON',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(10),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${(widget.percentage * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(24),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(100),
            height: ResponsiveHelper.h(6),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  children: [
                    Container(
                      width: ResponsiveHelper.w(100),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                      ),
                    ),
                    Container(
                      width: 100 * _animation.value,
                      decoration: BoxDecoration(
                        color: Color(0xFFC6FF00), // Neon Yellow-Green
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
