import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

// Internal Widgets
import 'widgets/friends_app_bar.dart';
import 'widgets/search_bar.dart';
import 'widgets/search_results_list.dart';
import 'widgets/online_now_section.dart';
import 'widgets/build_squad_cta.dart';
import 'widgets/suggested_players_section.dart';
import 'widgets/messages_list_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;

class FriendsHubScreen extends StatefulWidget {
  FriendsHubScreen({super.key});

  @override
  State<FriendsHubScreen> createState() => _FriendsHubScreenState();
}

class _FriendsHubScreenState extends State<FriendsHubScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  FriendsController get _ctrl => Get.find<FriendsController>();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ── Main scroll content ──
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                FriendsAppBar(),
                SliverToBoxAdapter(
                  child: SearchBarWidget(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (q) => _ctrl.searchUsers(q),
                    onClear: () {
                      _searchController.clear();
                      _ctrl.searchUsers('');
                      _searchFocusNode.unfocus();
                    },
                  ),
                ),
                SliverToBoxAdapter(child: OnlineNowSection()),
                SliverToBoxAdapter(child: MessagesListSection()),
                SliverToBoxAdapter(child: BuildSquadCTA()),
                SliverToBoxAdapter(child: SuggestedPlayersSection()),
                SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),

            // ── Search results overlay ──
            Obx(() {
              if (!_ctrl.isSearching.value || _ctrl.searchResults.isEmpty) {
                return SizedBox.shrink();
              }
              return Positioned(
                top: ResponsiveHelper.h(120), // below app bar + search bar
                left: ResponsiveHelper.w(16),
                right: ResponsiveHelper.w(16),
                child: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _ctrl.searchUsers('');
                    _searchFocusNode.unfocus();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: SearchResultsList(
                      results: _ctrl.searchResults,
                      onAdd: (user) => _ctrl.sendFriendRequest(user),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
