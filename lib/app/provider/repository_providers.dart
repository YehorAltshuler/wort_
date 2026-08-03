import 'package:asset_course_client/asset_course_client.dart';
import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:collections_repository/collections_repository.dart';
import 'package:course_repository/course_repository.dart';
import 'package:drift_citizenship_test_client/drift_citizenship_test_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_citizenship_test_client/http_citizenship_test_client.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:preferences_client/preferences_client.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/app/provider/collections_client_factory.dart';
import 'package:wort_flutter/app/provider/lexicon_client_factory.dart';

final lexiconRepositoryProvider = Provider<LexiconRepository>(
  (ref) => LexiconRepository(client: createLexiconClient()),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(client: PreferencesClient()),
);

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => const CourseRepository(client: AssetCourseClient()),
);

final collectionsRepositoryProvider = Provider<CollectionsRepository>(
  (ref) => CollectionsRepository(client: createCollectionsClient()),
);

final learningProgressRepositoryProvider = Provider<LearningProgressRepository>(
  (ref) => LearningProgressRepository(),
);

final Provider<CitizenshipTestMediaStore> citizenshipTestMediaStoreProvider =
    Provider(
      (ref) => createCitizenshipTestMediaStore(),
    );

final Provider<CitizenshipTestLocalClient> citizenshipTestLocalClientProvider =
    Provider(
      (ref) => DriftCitizenshipTestClient(
        mediaStore: ref.watch(citizenshipTestMediaStoreProvider),
      ),
    );

final citizenshipTestRepositoryProvider = Provider<CitizenshipTestRepository>(
  (ref) => CitizenshipTestRepository(
    localClient: ref.watch(citizenshipTestLocalClientProvider),
    remoteClient: HttpCitizenshipTestClient(),
    mediaStore: ref.watch(citizenshipTestMediaStoreProvider),
  ),
);
