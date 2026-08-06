import 'package:flutter/material.dart';

abstract final class AppBreakpoints {
  static const expandedNavigation = 600.0;
  static const maxContentWidth = 960.0;
}

class ResponsiveContent extends StatefulWidget {
  const ResponsiveContent({required this.child, super.key});

  final Widget child;

  static EdgeInsets insets(BuildContext context, EdgeInsets base) {
    final overflow =
        (MediaQuery.sizeOf(context).width - AppBreakpoints.maxContentWidth) / 2;
    final extra = overflow > 0 ? overflow : 0.0;
    return EdgeInsets.fromLTRB(
      base.left + extra,
      base.top,
      base.right + extra,
      base.bottom,
    );
  }

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
    return Scrollbar(
      controller: _scrollController,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: PrimaryScrollController(
          controller: _scrollController,
          automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
          child: SizedBox.expand(child: widget.child),
        ),
      ),
    );
  }
}
