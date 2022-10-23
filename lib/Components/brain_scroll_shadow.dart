import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

import '../Backend/design.dart';

class BrainScrollShadow extends StatefulWidget {
  const BrainScrollShadow({
    super.key,
    required this.child,
    required this.controller
  });

  final Widget child;
  final ScrollController controller;

  @override
  State<StatefulWidget> createState() => _BrainScrollShadow();
}

class _BrainScrollShadow extends State<BrainScrollShadow> {
  bool renderWithShadow = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.controller.position.maxScrollExtent > 0) {
        setState(() {
          renderWithShadow = true;
        });
      } else {
        setState(() {
          renderWithShadow = false;
        });
      }
    });

    if (renderWithShadow) {
      return ScrollShadow(
        color: AppDesign.colors.background.withOpacity(0.8),
        curve: Curves.ease,
        size: 15,
        controller: widget.controller,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}