import 'dart:math' as math;

import 'package:flutter/widgets.dart';

abstract final class AppBreakpoints {
  static const expandedNavigation = 600.0;
  static const maxContentWidth = 960.0;
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: math.min(
            constraints.maxWidth,
            AppBreakpoints.maxContentWidth,
          ),
          height: constraints.maxHeight,
          child: child,
        ),
      ),
    );
  }
}
