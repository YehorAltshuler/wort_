import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/collections/view/collections_page.dart';
import 'package:wort_flutter/dictionary/provider/dictionary_provider.dart';
import 'package:wort_flutter/dictionary/view/dictionary_page.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/view/learning_page.dart';
import 'package:wort_flutter/settings/view/settings_page.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({required this.initialIndex, super.key});

  final int initialIndex;

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  late final PageController _pageController;

  static const List<Widget> _pages = [
    ResponsiveContent(child: LearningPage()),
    ResponsiveContent(child: DictionaryPage()),
    ResponsiveContent(child: CollectionsPage()),
    ResponsiveContent(child: SettingsPage()),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant NavigationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex == widget.initialIndex ||
        !_pageController.hasClients ||
        _pageController.page?.round() == widget.initialIndex) {
      return;
    }
    _pageController.jumpToPage(widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    if (index == widget.initialIndex) return;
    context.go(AppRoute.paths[index]);
    unawaited(
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _handlePageChanged(int index) {
    if (index == widget.initialIndex) return;
    context.go(AppRoute.paths[index]);
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(collectionsProvider)
      ..watch(lexiconWarmupProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded =
            constraints.maxWidth >= AppBreakpoints.expandedNavigation;
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubicEmphasized,
                  tween: Tween(end: expanded ? 1 : 0),
                  builder: (context, value, child) => value == 0
                      ? const SizedBox.shrink()
                      : ClipRect(
                          child: Align(widthFactor: value, child: child),
                        ),
                  child: NavigationRail(
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/brand/wort-wordmark-dark.png'
                            : 'assets/brand/wort-wordmark-light.png',
                        width: 96,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                    selectedIndex: widget.initialIndex,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: _selectPage,
                    destinations: _railDestinations(context),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _handlePageChanged,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
            child: expanded
                ? const SizedBox.shrink()
                : NavigationBar(
                    selectedIndex: widget.initialIndex,
                    onDestinationSelected: _selectPage,
                    destinations: _barDestinations(context),
                  ),
          ),
        );
      },
    );
  }

  List<NavigationDestination> _barDestinations(BuildContext context) => [
    NavigationDestination(
      icon: const Icon(Icons.school_outlined),
      label: context.l10n.learningTab,
    ),
    NavigationDestination(
      icon: const Icon(Icons.search),
      label: context.l10n.dictionaryTab,
    ),
    NavigationDestination(
      icon: const Icon(Icons.bookmark_outline),
      label: context.l10n.collectionsTab,
    ),
    NavigationDestination(
      icon: const Icon(Icons.settings_outlined),
      label: context.l10n.settingsTab,
    ),
  ];

  List<NavigationRailDestination> _railDestinations(BuildContext context) => [
    NavigationRailDestination(
      icon: const Icon(Icons.school_outlined),
      label: Text(context.l10n.learningTab),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.search),
      label: Text(context.l10n.dictionaryTab),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.bookmark_outline),
      label: Text(context.l10n.collectionsTab),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.settings_outlined),
      label: Text(context.l10n.settingsTab),
    ),
  ];
}
