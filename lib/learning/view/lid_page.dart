import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/dashboard_block.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class LidPage extends StatelessWidget {
  const LidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leben in Deutschland')),
      body: ResponsiveContent(
        child: ListView(
          padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
          children: [
            DashboardBlockGrid(
              children: [
                DashboardBlock(
                  icon: Icons.how_to_vote_outlined,
                  title: context.l10n.lidTestChoiceTitle,
                  subtitle: context.l10n.lidTestChoiceSubtitle,
                  onTap: () => context.push(AppRoute.citizenshipTest),
                ),
                DashboardBlock(
                  icon: Icons.translate_outlined,
                  title: context.l10n.lidVocabularyChoiceTitle,
                  subtitle: context.l10n.lidVocabularyChoiceSubtitle,
                  onTap: () => context.push(
                    AppRoute.modules(AppRoute.lidVocabularyBookId),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
