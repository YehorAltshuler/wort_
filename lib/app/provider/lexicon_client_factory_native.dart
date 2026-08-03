import 'package:lexicon_client/lexicon_client.dart';
import 'package:sqlite_lexicon_client/sqlite_lexicon_client.dart';

LexiconClient createLexiconClient() => SqliteLexiconClient();
