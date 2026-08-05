import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/badminton_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/cricket_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Football/create_match/football_create_match_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Tennis/tennis_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Table_Tennis/table_tennis_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Squash/squash_setup/squash_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kabaddi/kabaddi_setup/kabaddi_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/basketball_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/volleyball_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/hockey_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/khokho_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/pickleball_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Boxing/boxing_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Wrestling/wrestling_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Karate/karate_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Judo/judo_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Taekwondo/taekwondo_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/MuayThai/muay_thai_setup_screen.dart';
// Widgets
import 'widgets/select_sport_app_bar.dart';
import 'widgets/select_sport_search_bar.dart';
import 'widgets/select_sport_tile.dart';
import 'widgets/select_sport_category_section.dart';
import 'widgets/sport_match_setup_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = AppColors.background;

class SelectSportScreen extends StatefulWidget {
  const SelectSportScreen({super.key});

  @override
  State<SelectSportScreen> createState() => _SelectSportScreenState();
}

class _SelectSportScreenState extends State<SelectSportScreen> {
  String searchQuery = '';
  String? selectedSport;

  final Map<String, bool> expanded = {
    'Team Sports': true,
    'Racquet & Net': false,
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
          'Kabaddi',
          Icons.sports_kabaddi,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => KabaddiSetupScreen())),
        ),
        SportItem(
          'Basketball',
          Icons.sports_basketball,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const BasketballSetupScreen())),
        ),
        SportItem(
          'Volleyball',
          Icons.sports_volleyball,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const VolleyballSetupScreen())),
        ),
        SportItem(
          'Hockey',
          Icons.sports_hockey,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const HockeySetupScreen())),
        ),
        SportItem(
          'Kho Kho',
          Icons.directions_run,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const KhoKhoSetupScreen())),
        ),
      ],
      'Racquet & Net': [
        SportItem(
          'Tennis',
          Icons.sports_tennis,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TennisSetupScreen()),
          ),
        ),
        SportItem(
          'Badminton',
          Icons.sports,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BadmintonSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Table Tennis',
          Icons.sports_tennis,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TableTennisSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Squash',
          Icons.sports_handball,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SquashSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Pickleball',
          Icons.sports_tennis,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PickleballSetupScreen(),
            ),
          ),
        ),
      ],
      'Fitness & Combat': [
        SportItem(
          'Boxing',
          Icons.sports_mma,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const BoxingSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Wrestling',
          Icons.sports_kabaddi,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const WrestlingSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Karate',
          Icons.sports_martial_arts,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const KarateSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Judo',
          Icons.sports_martial_arts,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const JudoSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Taekwondo',
          Icons.sports_martial_arts,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const TaekwondoSetupScreen(),
            ),
          ),
        ),
        SportItem(
          'Muay Thai',
          Icons.sports_mma,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MuayThaiSetupScreen(),
            ),
          ),
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

    if (sport == 'Table Tennis') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TableTennisSetupScreen()),
      );
      return;
    }

    if (sport == 'Squash') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SquashSetupScreen()),
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
