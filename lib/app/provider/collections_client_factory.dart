import 'package:collections_client/collections_client.dart';
import 'package:wort_flutter/app/provider/collections_client_factory_stub.dart'
    if (dart.library.io) 'package:wort_flutter/app/provider/collections_client_factory_native.dart'
    if (dart.library.js_interop) 'package:wort_flutter/app/provider/collections_client_factory_web.dart'
    as implementation;

CollectionsClient createCollectionsClient() {
  return implementation.createCollectionsClient();
}
