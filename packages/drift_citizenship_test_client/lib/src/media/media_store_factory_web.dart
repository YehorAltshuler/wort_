import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:drift_citizenship_test_client/src/media/web_media_store.dart';

CitizenshipTestMediaStore createPlatformMediaStore() => WebMediaStore();
