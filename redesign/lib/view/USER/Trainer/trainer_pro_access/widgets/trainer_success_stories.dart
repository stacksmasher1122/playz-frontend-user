import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class Story {
  final String name;
  final String role;
  final String quote;
  final String imageUrl;
  final bool verified;

  Story({
    required this.name,
    required this.role,
    required this.quote,
    required this.imageUrl,
    this.verified = true,
  });
}

final _stories = [
  Story(
    name: 'Rahul Sharma',
    role: 'Cricket Coach • Pune',
    quote:
        'Since joining, my student base doubled in just 3 months. The dashboard makes management so easy.',
    imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  ),
  Story(
    name: 'Anita Verma',
    role: 'Fitness Trainer • Delhi',
    quote:
        'I get genuine leads every week now. The verification badge builds instant trust.',
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
  ),
];

class TrainerSuccessStories extends StatelessWidget {
  TrainerSuccessStories({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRAINER SUCCESS STORIES',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(12.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 14),
        SizedBox(
          height: ResponsiveHelper.h(160),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: _stories.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (_, i) => StoryCard(story: _stories[i]),
          ),
        ),
      ],
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(280),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(story.imageUrl),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            story.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (story.verified)
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: kGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                            ),
                            child: Text(
                              'VERIFIED',
                              style: TextStyle(
                                color: kGreen,
                                fontSize: ResponsiveHelper.sp(9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      story.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: kMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: Text(
              '"${story.quote}"',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                height: ResponsiveHelper.h(1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
