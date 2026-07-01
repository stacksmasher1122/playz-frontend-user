import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);

class AcademyGalleryPreview extends StatelessWidget {
  AcademyGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const items = ['Training Ground', 'Client Success', 'Equipment'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transformations & Gallery',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: ResponsiveHelper.h(120),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (_, i) {
              return Container(
                width: ResponsiveHelper.w(180),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(ResponsiveHelper.w(10)),
                child: Text(
                  items[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
