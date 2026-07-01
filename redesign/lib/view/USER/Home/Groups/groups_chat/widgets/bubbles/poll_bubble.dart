import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_chat_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import '../voter_breakdown_sheet.dart';

const _kGreen = AppColors.accent;
const _kMuted = Colors.white38;

class PollBubble extends StatelessWidget {
  final GroupChatMessageModel msg;

  const PollBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> payload = {};
    try {
      payload = jsonDecode(msg.content);
    } catch (_) {}

    final String question = payload['question'] ?? 'Poll Question';
    final List<dynamic> rawOptions = payload['options'] ?? [];
    final Map<String, dynamic> rawVotes = Map<String, dynamic>.from(
      payload['votes'] ?? {},
    );

    final ctrl = Get.find<GroupChatController>();
    final myEmail = ctrl.myEmail;

    int totalVotes = 0;
    Map<String, int> exactVotesPerOption = {};

    // Count exact votes and total
    for (var uVotes in rawVotes.values) {
      final List<dynamic> list = uVotes as List<dynamic>;
      for (var optId in list) {
        exactVotesPerOption[optId] = (exactVotesPerOption[optId] ?? 0) + 1;
        totalVotes++;
      }
    }

    return Container(
      width: 280,
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.poll, color: _kGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...rawOptions.map((opt) {
            String id = opt['id'].toString();
            String text = opt['text'].toString();
            int votesForOpt = exactVotesPerOption[id] ?? 0;
            double percentage = totalVotes == 0
                ? 0
                : (votesForOpt / totalVotes);

            bool iVotedForThis = false;
            if (rawVotes.containsKey(myEmail)) {
              final myVotesList = rawVotes[myEmail] as List<dynamic>;
              iVotedForThis = myVotesList.contains(id);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  ctrl.togglePollVote(msg.id, id);
                },
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Background & Progress bar
                    Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: iVotedForThis ? _kGreen : Colors.transparent,
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _kGreen.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(
                              11,
                            ), // slightly smaller to fit inside border
                          ),
                        ),
                      ),
                    ),
                    // Foreground content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (votesForOpt > 0)
                              Text(
                                "${(percentage * 100).round()}%",
                                style: TextStyle(
                                  color: percentage > 0.5
                                      ? Colors.black87
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (iVotedForThis) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check_circle,
                                color: percentage > 0.5
                                    ? Colors.black87
                                    : _kGreen,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 8),
          const Divider(color: Colors.white10),

          InkWell(
            onTap: () {
              final groupsCtrl = Get.find<GroupsController>();
              Map<String, dynamic> groupMembers = {};
              try {
                groupMembers = groupsCtrl.myGroups
                    .firstWhere((g) => g.groupId == ctrl.currentGroupId.value)
                    .members;
              } catch (_) {}
              showPollVotersSheet(context, rawVotes, rawOptions, groupMembers);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "View votes",
                    style: TextStyle(
                      color: _kGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$totalVotes VOTES",
                    style: const TextStyle(
                      color: _kMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
