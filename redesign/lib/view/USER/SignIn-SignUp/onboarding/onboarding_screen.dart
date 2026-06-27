import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/SignIn-SignUp/login/login_screen.dart';

import 'onboarding_models.dart';
import 'widgets/onboard_top_bar.dart';
import 'widgets/onboard_page_content.dart';
import 'widgets/onboard_bottom_controls.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color bg = AppColors.surface;

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardData> _pages = const [
    OnboardData(
      tag: '#1 SPORTS APP',
      title: 'India’s Sports Community,\nin Your Pocket',
      subtitle:
          'Book top-rated turfs, find local players instantly, and track your match stats — all in one place.',
      image: 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
    ),
    OnboardData(
      tag: 'FAST & EASY',
      title: 'Instant Booking\nMade Simple',
      subtitle:
          'Find nearby turfs, check real-time availability, and book your slot in seconds.',
      image: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
    ),
    OnboardData(
      tag: 'COMMUNITY',
      title: 'Never Play\nAlone Again',
      subtitle:
          'Join solo queue, connect with players nearby, and build your dream squad.',
      image: 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
    ),
    OnboardData(
      tag: 'LEADERBOARDS',
      title: 'Gamify Your\nGame',
      subtitle:
          'Track your performance, climb ranks, and stay motivated to play more.',
      image: 'https://images.unsplash.com/photo-1518611012118-696072aa579a',
    ),
  ];

  void _next() {
    if (_currentIndex == _pages.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            OnboardTopBar(onSkip: _finishOnboarding),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (_, index) {
                  return OnboardPageContent(data: _pages[index]);
                },
              ),
            ),
            OnboardBottomControls(
              currentIndex: _currentIndex,
              total: _pages.length,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}
