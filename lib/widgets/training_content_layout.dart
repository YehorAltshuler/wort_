import 'package:flutter/material.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class TrainingContentLayout extends StatelessWidget {
  const TrainingContentLayout({
    required this.header,
    required this.answers,
    this.answersBottomPadding = 24,
    this.scrollTogether = false,
    super.key,
  });

  final Widget header;
  final Widget answers;
  final double answersBottomPadding;
  final bool scrollTogether;

  @override
  Widget build(BuildContext context) {
    if (scrollTogether) {
      return SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.horizontalPageInsets,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppSpacing.xl,
                    bottom: answersBottomPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header,
                      const SizedBox(height: 20),
                      answers,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

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
