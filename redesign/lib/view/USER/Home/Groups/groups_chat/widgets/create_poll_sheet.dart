import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kMuted = Colors.white38;

class CreatePollSheet extends StatefulWidget {
  CreatePollSheet({super.key});

  @override
  State<CreatePollSheet> createState() => _CreatePollSheetState();
}

class _CreatePollSheetState extends State<CreatePollSheet> {
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionsCtrls = [
    TextEditingController(),
    TextEditingController(),
  ];
  bool _allowMultiple = false;

  void _addOption() {
    if (_optionsCtrls.length < 12) {
      setState(() {
        _optionsCtrls.add(TextEditingController());
      });
    }
  }

  void _submit() {
    final q = _questionCtrl.text.trim();
    if (q.isEmpty) {
      Get.snackbar('Error', 'Please enter a question');
      return;
    }
    final opts = _optionsCtrls
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (opts.length < 2) {
      Get.snackbar('Error', 'Please provide at least 2 options');
      return;
    }

    final ctrl = Get.find<GroupChatController>();
    ctrl.sendPollMessage(q, opts, _allowMultiple);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(20))),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Poll",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 80),
              children: [
                Text(
                  "QUESTION",
                  style: TextStyle(
                    color: _kMuted,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _questionCtrl,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Ask a question...",
                    hintStyle: TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                Text(
                  "OPTIONS",
                  style: TextStyle(
                    color: _kMuted,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8),

                ...List.generate(_optionsCtrls.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _optionsCtrls[index],
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Option ${index + 1}",
                        hintStyle: TextStyle(color: Colors.white38),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: _kMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFF2A2A2A),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  );
                }),

                if (_optionsCtrls.length < 12)
                  InkWell(
                    onTap: _addOption,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Add Option",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 24),

                // Allow Multiple Switch
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                        decoration: BoxDecoration(
                          color: _kGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.checklist,
                          color: _kGreen,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Allow multiple answers",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Users can pick more than one option",
                              style: TextStyle(color: _kMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _allowMultiple,
                        activeThumbColor: _kGreen,
                        onChanged: (val) =>
                            setState(() => _allowMultiple = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Floating Send Button
    ).applyFloatingActionButton(context, _submit);
  }
}

extension on Widget {
  Widget applyFloatingActionButton(
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return Stack(
      children: [
        this,
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          right: ResponsiveHelper.w(16),
          child: FloatingActionButton(
            backgroundColor: _kGreen,
            onPressed: onPressed,
            child: Icon(Icons.send, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
