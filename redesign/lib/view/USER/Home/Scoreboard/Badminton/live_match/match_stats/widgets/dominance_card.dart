import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DominanceCard extends StatefulWidget {
  DominanceCard({super.key});

  @override
  State<DominanceCard> createState() => _DominanceCardState();
}

class _DominanceCardState extends State<DominanceCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _slide = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _slide,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
              padding: EdgeInsets.all(ResponsiveHelper.w(24)),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                border: Border.all(color: Colors.grey.shade800),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFC6FF00).withValues(alpha: 0.05), // Subtle neon glow
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DOMINANCE\nINDEX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(32),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      height: ResponsiveHelper.h(1.1),
                      letterSpacing: -1.0,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Viktor leads tactical control by 14%',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
