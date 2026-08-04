import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class AppBreakpoints {
  static const expandedNavigation = 600.0;
  static const maxContentWidth = 960.0;
}

class ResponsiveContent extends StatefulWidget {
  const ResponsiveContent({required this.child, super.key});

  final Widget child;

  @override
  State<ResponsiveContent> createState() => _ResponsiveContentState();
}

class _ResponsiveContentState extends State<ResponsiveContent> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scrollbar(
        controller: _scrollController,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
          ),
          child: PrimaryScrollController(
            controller: _scrollController,
            automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: math.min(
                  constraints.maxWidth,
                  AppBreakpoints.maxContentWidth,
                ),
                height: constraints.maxHeight,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
