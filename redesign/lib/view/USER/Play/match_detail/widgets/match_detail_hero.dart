import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchDetailHero extends StatelessWidget {
  MatchDetailHero({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final height = MediaQuery.of(context).size.height * 0.42;

    return SliverAppBar(
      expandedHeight: height,
      backgroundColor: Colors.black,
      pinned: false,
      leading: BackButton(),
      actions: [
        Icon(Icons.share_outlined),
        SizedBox(width: 12),
        Icon(Icons.more_vert),
        SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1200",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: ResponsiveHelper.h(28),
              left: ResponsiveHelper.w(20),
              right: ResponsiveHelper.w(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TagRow(),
                  SizedBox(height: 16),
                  _StartIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  _TagRow();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Wrap(
      spacing: 10,
      children: [
        _Tag("COMPETITIVE"),
        _Tag("DOUBLES"),
        _Tag("ELITE", color: Colors.purple),
      ],
    );
  }
}

class _StartIndicator extends StatelessWidget {
  _StartIndicator();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: MatchDetailColors.primary),
        SizedBox(width: 8),
        Text(
          "Starts in 45m",
          style: TextStyle(fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  _Tag(this.label, {this.color = Colors.white24});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(8)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.sp(11),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
