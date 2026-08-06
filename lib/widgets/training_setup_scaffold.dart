import 'package:flutter/material.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class TrainingSetupScaffold extends StatelessWidget {
  const TrainingSetupScaffold({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final String title;
  final Widget body;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ResponsiveContent(child: body),
    bottomNavigationBar: BottomActionButton(
      label: actionLabel,
      onPressed: onAction,
    ),
  );
}
