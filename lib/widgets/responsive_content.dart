import 'dart:math' as math;

import 'package:flutter/gestures.dart';
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _ScrollGutter(controller: _scrollController)),
                SizedBox(
                  width: math.min(
                    constraints.maxWidth,
                    AppBreakpoints.maxContentWidth,
                  ),
                  height: constraints.maxHeight,
                  child: widget.child,
                ),
                Expanded(child: _ScrollGutter(controller: _scrollController)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollGutter extends StatelessWidget {
  const _ScrollGutter({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.opaque,
    onPointerSignal: (event) {
      if (event is! PointerScrollEvent || !controller.hasClients) return;
      GestureBinding.instance.pointerSignalResolver.register(event, (_) {
        controller.position.pointerScroll(event.scrollDelta.dy);
      });
    },
    child: const SizedBox.expand(),
  );
}
