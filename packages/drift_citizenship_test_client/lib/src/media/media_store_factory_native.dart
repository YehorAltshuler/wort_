import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:drift_citizenship_test_client/src/media/native_media_store.dart';

CitizenshipTestMediaStore createPlatformMediaStore() => NativeMediaStore();
