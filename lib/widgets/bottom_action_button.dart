import 'package:flutter/material.dart';
import 'package:wort_flutter/widgets/bottom_action_bar.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BottomActionBar(
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
