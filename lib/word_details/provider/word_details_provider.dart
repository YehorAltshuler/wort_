import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';

final FutureProviderFamily<Lexeme?, String> wordDetailsProvider = FutureProvider
    .autoDispose
    .family<Lexeme?, String>(
      (ref, id) => ref.read(lexiconRepositoryProvider).getById(id),
    );
