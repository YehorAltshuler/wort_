import 'package:lexicon_client/lexicon_client.dart';
import 'package:wort_flutter/app/provider/lexicon_client_factory_stub.dart'
    if (dart.library.io) 'package:wort_flutter/app/provider/lexicon_client_factory_native.dart'
    if (dart.library.js_interop) 'package:wort_flutter/app/provider/lexicon_client_factory_web.dart'
    as implementation;

LexiconClient createLexiconClient() => implementation.createLexiconClient();
