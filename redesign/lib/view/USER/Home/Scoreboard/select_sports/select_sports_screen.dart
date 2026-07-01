import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_create_match.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/cricket_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Football/create_match/football_create_match_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Tennis/setup_match/setup_match_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/scored/pickleball_initialize_match_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/volleyball_initialize_match_screen.dart';
// Widgets
import 'widgets/select_sport_app_bar.dart';
import 'widgets/select_sport_search_bar.dart';
import 'widgets/select_sport_tile.dart';
import 'widgets/select_sport_category_section.dart';
import 'widgets/sport_match_setup_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = AppColors.background;

class SelectSportScreen extends StatefulWidget {
  SelectSportScreen({super.key});

  @override
  State<SelectSportScreen> createState() => _SelectSportScreenState();
}

class _SelectSportScreenState extends State<SelectSportScreen> {
  String searchQuery = '';
  String? selectedSport;

  final Map<String, bool> expanded = {
    'Team Sports': true,
    'Racquet & Net': false,
    'Indoor & Board': false,
    'Fitness & Combat': false,
  };

  late final Map<String, List<SportItem>> categories;

  @override
  void initState() {
    super.initState();

    /// 👇 DEFINE NAVIGATION PER SPORT HERE
    categories = {
      'Team Sports': [
        SportItem(
          'Cricket',
          Icons.sports_cricket,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => FriendlySetupScreen())),
        ),
        SportItem(
          'Football',
          Icons.sports_soccer,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => FootballCreateMatchScreen())),
        ),
        SportItem(
          'Box Cricket',
          Icons.sports_baseball,
          onTap: () => _openSetup('Box Cricket'),
        ),
        SportItem(
          'Kabaddi',
          Icons.sports_martial_arts,
          onTap: () => _openSetup('Kabaddi'),
        ),
        SportItem(
          'Basketball',
          Icons.sports_basketball,
          onTap: () => _openSetup('Basketball'),
        ),
        SportItem(
          'Volleyball',
          Icons.sports_volleyball,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => VolleyballInitializeMatchScreen())),
        ),
        SportItem(
          'Hockey',
          Icons.sports_hockey,
          onTap: () => _openSetup('Hockey'),
        ),
        SportItem(
          'Kho Kho',
          Icons.directions_run,
          onTap: () => _openSetup('Kho Kho'),
        ),
      ],
      'Racquet & Net': [
        SportItem(
          'Tennis',
          Icons.sports_tennis,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SetupMatchScreen()),
          ),
        ),
        SportItem(
          'Badminton',
          Icons.sports,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BadmintonCreateMatchScreen(),
            ),
          ),
        ),
        SportItem(
          'Table Tennis',
          Icons.sports_tennis,
          onTap: () => _openSetup('Table Tennis'),
        ),
        SportItem(
          'Squash',
          Icons.sports_handball,
          onTap: () => _openSetup('Squash'),
        ),
        SportItem(
          'Pickleball',
          Icons.sports_tennis,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PickleballInitializeMatchScreen(),
            ),
          ),
        ),
      ],
      'Indoor & Board': [
        SportItem(
          'Carrom',
          Icons.circle_outlined,
          onTap: () => _openSetup('Carrom'),
        ),
        SportItem('Chess', Icons.grid_on, onTap: () => _openSetup('Chess')),
        SportItem(
          'Snooker',
          Icons.sports_esports,
          onTap: () => _openSetup('Snooker'),
        ),
      ],
      'Fitness & Combat': [
        SportItem(
          'Workout',
          Icons.fitness_center,
          onTap: () => _openSetup('Workout'),
        ),
        SportItem(
          'Running',
          Icons.directions_run,
          onTap: () => _openSetup('Running'),
        ),
        SportItem(
          'Yoga',
          Icons.self_improvement,
          onTap: () => _openSetup('Yoga'),
        ),
        SportItem('Swimming', Icons.pool, onTap: () => _openSetup('Swimming')),
        SportItem(
          'Cycling',
          Icons.directions_bike,
          onTap: () => _openSetup('Cycling'),
        ),
        SportItem(
          'Wrestling',
          Icons.sports_martial_arts,
          onTap: () => _openSetup('Wrestling'),
        ),
        SportItem(
          'Boxing',
          Icons.sports_mma,
          onTap: () => _openSetup('Boxing'),
        ),
      ],
    };
  }

  void _openSetup(String sport) {
    setState(() => selectedSport = sport);

    if (sport == 'Football') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => FootballCreateMatchScreen()),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SportMatchSetupScreen(sport: sport)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SelectSportAppBar(),
            SelectSportSearchBar(
              onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
            ),
            ...categories.entries.map(
              (entry) => SelectSportCategorySection(
                title: entry.key,
                sports: entry.value,
                expanded: expanded[entry.key]!,
                selectedSport: selectedSport,
                searchQuery: searchQuery,
                onToggle: () {
                  setState(() {
                    expanded[entry.key] = !expanded[entry.key]!;
                  });
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
