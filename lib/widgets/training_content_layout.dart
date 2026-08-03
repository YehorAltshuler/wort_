import 'package:flutter/material.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class TrainingContentLayout extends StatelessWidget {
  const TrainingContentLayout({
    required this.header,
    required this.answers,
    this.answersBottomPadding = 24,
    super.key,
  });

  final Widget header;
  final Widget answers;
  final double answersBottomPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: AppSpacing.horizontalPageInsets,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: header,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: answersBottomPadding,
                        ),
                        child: answers,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
