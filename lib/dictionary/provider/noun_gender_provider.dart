import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nounGenderIndexProvider = FutureProvider<Map<String, List<String>>>(
  (ref) async {
    final json =
        jsonDecode(
              await rootBundle.loadString('assets/lexicon/genders.json'),
            )!
            as Map<String, dynamic>;
    return json.map(
      (lemma, articles) => MapEntry(
        lemma,
        (articles as List<dynamic>).cast<String>(),
      ),
    );
  },
);

List<String> nounArticles(
  Map<String, List<String>> index,
  String lemma,
) => index[lemma.toLowerCase()] ?? const [];
