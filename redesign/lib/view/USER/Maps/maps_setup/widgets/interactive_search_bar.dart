import 'package:flutter/material.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';


class InteractiveSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final MapsController mapsCtrl;

  InteractiveSearchBar({
    super.key,
    required this.controller,
    required this.mapsCtrl,
  });

  @override
  State<InteractiveSearchBar> createState() => _InteractiveSearchBarState();
}

class _InteractiveSearchBarState extends State<InteractiveSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
        border: Border.all(
          color: _isFocused ? kSpotifyGreen : Colors.white12,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: kSpotifyGreen.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        cursorColor: kSpotifyGreen,
        style: TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search turfs, areas, or streets...",
          hintStyle: TextStyle(color: kMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: kMuted, size: 20),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: kMuted, size: 18),
                  onPressed: () {
                    widget.controller.clear();
                    widget.mapsCtrl.searchResults.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(11)),
        ),
        onChanged: (query) {
          setState(() {});
          widget.mapsCtrl.searchPlaces(query);
        },
      ),
    );
  }
}
