import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const _kGreen = AppColors.accent;

void showPollVotersSheet(
  BuildContext context,
  Map<String, dynamic> rawVotes,
  List<dynamic> rawOptions,
  Map<String, dynamic> groupMembers,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Voter Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: rawOptions.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white10, height: 1),
              itemBuilder: (context, index) {
                final opt = rawOptions[index];
                String id = opt['id'].toString();
                String text = opt['text'].toString();

                // Collect voters for this option
                List<String> voterEmails = [];
                for (var entry in rawVotes.entries) {
                  final list = entry.value as List<dynamic>;
                  if (list.contains(id)) voterEmails.add(entry.key);
                }

                if (voterEmails.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: _kGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...voterEmails.map((email) {
                      final memData = groupMembers[email];
                      final name = memData?['name'] ?? email.split('@').first;
                      final image = memData?['profilePic'];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF333333),
                          backgroundImage: image != null
                              ? NetworkImage(image)
                              : null,
                          child: image == null
                              ? Text(
                                  name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
