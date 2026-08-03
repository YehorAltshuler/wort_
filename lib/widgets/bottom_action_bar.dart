import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    required this.child,
    this.feedback,
    super.key,
  });

  final Widget child;
  final Widget? feedback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ?feedback,
              SizedBox(
                height: 64,
                child: Center(child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
