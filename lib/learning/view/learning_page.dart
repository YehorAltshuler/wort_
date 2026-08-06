import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/dashboard_block.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
      children: [
        DashboardBlock(
          icon: Icons.menu_book_outlined,
          title: context.l10n.coursebooksTitle,
          subtitle: context.l10n.booksSubtitle,
          onTap: () => context.push(AppRoute.coursebooks),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 180,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DashboardBlock(
              icon: Icons.fitness_center_outlined,
              title: context.l10n.exercisesTitle,
              subtitle: context.l10n.knowledgeCheckSubtitle,
              onTap: () => context.push(AppRoute.exercises),
            ),
            DashboardBlock(
              icon: Icons.how_to_vote_outlined,
              title: 'Leben in Deutschland',
              subtitle: context.l10n.citizenshipTestSubtitle,
              onTap: () => context.push(AppRoute.lid),
            ),
          ],
        ),
      ],
    );
  }
}
