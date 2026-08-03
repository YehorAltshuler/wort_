import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';

final lexiconWarmupProvider = FutureProvider<void>((ref) async {
  await ref.watch(lexiconRepositoryProvider).search('a', limit: 1);
});

final NotifierProvider<DictionaryNotifier, DictionaryState> dictionaryProvider =
    NotifierProvider.autoDispose<DictionaryNotifier, DictionaryState>(
      DictionaryNotifier.new,
    );

class DictionaryState {
  const DictionaryState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.error,
  });

  final String query;
  final List<Lexeme> results;
  final bool isLoading;
  final bool hasSearched;
  final Object? error;

  DictionaryState copyWith({
    String? query,
    List<Lexeme>? results,
    bool? isLoading,
    bool? hasSearched,
    Object? error,
    bool clearError = false,
  }) {
    return DictionaryState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class DictionaryNotifier extends Notifier<DictionaryState> {
  var _requestId = 0;

  @override
  DictionaryState build() => const DictionaryState();

  void queryChanged(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      _requestId++;
      state = const DictionaryState();
      return;
    }

    state = state.copyWith(query: query, isLoading: true, clearError: true);
    unawaited(_search(query));
  }

  Future<void> _search(String query) async {
    final requestId = ++_requestId;
    try {
      final results = await ref
          .read(lexiconRepositoryProvider)
          .search(query, limit: 10);
      if (requestId != _requestId) return;
      state = state.copyWith(
        query: query,
        results: results,
        isLoading: false,
        hasSearched: true,
        clearError: true,
      );
    } on Object catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(
        query: query,
        results: const [],
        isLoading: false,
        hasSearched: true,
        error: error,
      );
    }
  }
}
