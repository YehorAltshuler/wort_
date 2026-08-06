import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class ModulesPage extends ConsumerWidget {
  const ModulesPage({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.modulesTitle)),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: books,
          errorMessage: context.l10n.courseLoadError,
          data: (items) {
            final book = items.where((item) => item.id == bookId).firstOrNull;
            if (book == null) {
              return Center(child: Text(context.l10n.invalidCourseRoute));
            }
            return _ModuleList(book: book);
          },
        ),
      ),
    );
  }
}

class _ModuleList extends StatelessWidget {
  const _ModuleList({required this.book});

  final CourseBook book;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: ResponsiveContent.insets(
              context,
              const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
            ),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primaryContainer,
                  colors.tertiaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.level,
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${book.modules.length} ${context.l10n.modulesCount}'),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: ResponsiveContent.insets(
            context,
            const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
          ),
          sliver: SliverList.separated(
            itemCount: book.modules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final module = book.modules[index];
              final title = _ModuleTitle.parse(module.title);
              return _ModuleCard(
                moduleLabel: title.label,
                title: title.title,
                wordCount: _WordCount(
                  bookId: book.id,
                  moduleFile: module.file,
                ),
                onTap: () => context.push(
                  AppRoute.module(book.id, module.file),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.moduleLabel,
    required this.title,
    required this.wordCount,
    required this.onTap,
  });

  final String? moduleLabel;
  final String title;
  final Widget wordCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: moduleLabel == null
                    ? Icon(Icons.menu_book_outlined, color: colors.primary)
                    : Text(
                        moduleLabel!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    DefaultTextStyle(
                      style: TextStyle(color: colors.onSurfaceVariant),
                      child: wordCount,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleTitle {
  const _ModuleTitle({required this.label, required this.title});

  factory _ModuleTitle.parse(String value) {
    final match = RegExp(
      r'^Modul\s+(\d+)\s*:?\s*(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());
    if (match == null) return _ModuleTitle(label: null, title: value);
    final number = match.group(1)!;
    final title = match.group(2)!.trim();
    return _ModuleTitle(
      label: 'Modul $number',
      title: title.isEmpty ? 'Modul $number' : title,
    );
  }

  final String? label;
  final String title;
}

class _WordCount extends ConsumerWidget {
  const _WordCount({required this.bookId, required this.moduleFile});

  final String bookId;
  final String moduleFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(
      moduleWordsProvider((bookId: bookId, moduleFile: moduleFile)),
    );
    return Text(
      words.maybeWhen(
        data: (items) => '${items.length} ${context.l10n.wordsCount}',
        orElse: () => '…',
      ),
    );
  }
}
