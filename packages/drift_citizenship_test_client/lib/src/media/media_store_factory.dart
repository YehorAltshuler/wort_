import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:drift_citizenship_test_client/src/media/media_store_factory_stub.dart'
    if (dart.library.io) 'media_store_factory_native.dart'
    if (dart.library.js_interop) 'media_store_factory_web.dart';

CitizenshipTestMediaStore createCitizenshipTestMediaStore() =>
    createPlatformMediaStore();
