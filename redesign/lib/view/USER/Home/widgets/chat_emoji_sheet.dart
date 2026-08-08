// ignore_for_file: valid_regexps
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Returns true if [text] consists of exactly one single emoji character/grapheme.
bool isSingleEmoji(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return false;
  if (trimmed.characters.length != 1) return false;

  final hasEmoji = RegExp(
    r'\p{Extended_Pictographic}',
    unicode: true,
  ).hasMatch(trimmed);

  final isAlphaNumeric = RegExp(r'[a-zA-Z0-9]').hasMatch(trimmed);

  return hasEmoji && !isAlphaNumeric;
}

/// Inserts [emoji] into [controller] at current selection/cursor position.
void insertEmojiToController(
  TextEditingController controller,
  String emoji,
  VoidCallback onChanged,
) {
  final text = controller.text;
  final selection = controller.selection;
  int start = selection.start;
  int end = selection.end;

  if (start < 0) start = text.length;
  if (end < 0) end = text.length;

  final newText = text.replaceRange(start, end, emoji);
  controller.text = newText;
  controller.selection = TextSelection.collapsed(
    offset: start + emoji.length,
  );
  onChanged();
}

/// Deletes previous character or selected range in [controller].
void deleteEmojiFromController(
  TextEditingController controller,
  VoidCallback onChanged,
) {
  final text = controller.text;
  final selection = controller.selection;
  if (text.isEmpty) return;

  int start = selection.start;
  int end = selection.end;

  if (start < 0) start = text.length;
  if (end < 0) end = text.length;

  if (start != end) {
    final newText = text.replaceRange(start, end, '');
    controller.text = newText;
    controller.selection = TextSelection.collapsed(offset: start);
  } else if (start > 0) {
    final textBeforeCursor = text.substring(0, start);
    final lastChar = textBeforeCursor.characters.last;
    final newStart = start - lastChar.length;

    final newText = text.replaceRange(newStart, start, '');
    controller.text = newText;
    controller.selection = TextSelection.collapsed(offset: newStart);
  }

  onChanged();
}

/// A common emoji picker panel widget placed underneath the chat input bar,
/// raising the input bar so the user can see what they are typing.
class ChatEmojiPickerPanel extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback? onClose;

  const ChatEmojiPickerPanel({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClose,
  });

  static final List<Map<String, dynamic>> categories = [
    {
      'title': 'Sports',
      'icon': Icons.sports_soccer,
      'emojis': [
        '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🥏', '🎱',
        '🪀', '🏓', '🏸', '🏒', '🏑', '🥍', '🏏', '🪃', '🥅', '⛳',
        '🪁', '🏹', '🎣', '🤿', '🥊', '🥋', '🎽', '🛹', '🛼', '🛷',
        '⛸️', '🥌', '🎿', '⛷️', '🏂', '🪂', '🏋️', '🤼', '🤸', '⛹️',
        '🤺', '🤾', '🏌️', '🏇', '🧘', '🏄', '🏊', '🤽', '🚣', '🧗',
        '🏆', '🥇', '🥈', '🥉', '🏅', '🎖️', '🏵️', '🎗️', '🎯', '🎮'
      ]
    },
    {
      'title': 'Smileys',
      'icon': Icons.sentiment_satisfied_alt,
      'emojis': [
        '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇',
        '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚',
        '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩',
        '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣',
        '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬',
        '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥', '😓', '🤗'
      ]
    },
    {
      'title': 'Gestures',
      'icon': Icons.back_hand,
      'emojis': [
        '👍', '👎', '👊', '✊', '🤛', '🤜', '👏', '🙌', '👐', '🤲',
        '🤝', '🙏', '✍️', '💅', '🤳', '💪', '👈', '👉', '👆', '🖕',
        '👇', '☝️', '🖐️', '✋', '🖖', '👌', '🤏', '✌️', '🤞', '🤟',
        '🤘', '🤙', '👋', '🦶', '🦵', '👂', '👃'
      ]
    },
    {
      'title': 'Hearts',
      'icon': Icons.favorite,
      'emojis': [
        '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
        '❣️', '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💟', '💋',
        '💯', '🔥', '💥', '✨', '🌟', '⭐', '💫', '🎉', '🎊', '🎈'
      ]
    },
    {
      'title': 'Objects',
      'icon': Icons.sports_esports,
      'emojis': [
        '🍕', '🍔', '🍟', '🌭', '🍿', '🥤', '🍺', '🍻', '🥂', '🍾',
        '👑', '💎', '⚡', '💡', '📢', '🎵', '🎶', '📱', '💻', '📷',
        '🎥', '🚗', '🚀', '✈️', '⛵', '🏠', '⛺', '🔔', '🎁', '🎈'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return DefaultTabController(
      length: categories.length,
      child: Container(
        height: ResponsiveHelper.h(260),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          border: Border(
            top: BorderSide(color: Colors.white10, width: 1),
          ),
        ),
        child: Column(
          children: [
            // Header bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12),
                vertical: ResponsiveHelper.h(2),
              ),
              color: const Color(0xFF181818),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: AppColors.accent,
                      labelColor: AppColors.accent,
                      unselectedLabelColor: Colors.white38,
                      dividerColor: Colors.transparent,
                      tabs: categories
                          .map(
                            (cat) => Tab(
                              icon: Icon(cat['icon'] as IconData, size: 20),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.backspace_outlined,
                        color: Colors.white60, size: 20),
                    onPressed: () =>
                        deleteEmojiFromController(controller, onChanged),
                  ),
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white60, size: 20),
                      onPressed: onClose,
                    ),
                ],
              ),
            ),

            // TabBarView Grid
            Expanded(
              child: TabBarView(
                children: categories.map((cat) {
                  final emojis = cat['emojis'] as List<String>;
                  return GridView.builder(
                    padding: EdgeInsets.all(ResponsiveHelper.w(10)),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemCount: emojis.length,
                    itemBuilder: (context, idx) {
                      final emoji = emojis[idx];
                      return InkWell(
                        onTap: () =>
                            insertEmojiToController(controller, emoji, onChanged),
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(26),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
