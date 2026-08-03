import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:test/test.dart';

void main() {
  late _Local local;
  late _Remote remote;
  late CitizenshipTestRepository repository;
  final now = DateTime.utc(2026, 8, 2, 12);

  setUp(() {
    local = _Local();
    remote = _Remote();
    repository = CitizenshipTestRepository(
      localClient: local,
      remoteClient: remote,
      mediaStore: _Media(),
      parser: const CitizenshipQuestionParser(
        minimumQuestions: 1,
        maximumQuestions: 10,
      ),
      now: () => now,
    );
  });

  test('304 is a successful check', () async {
    remote.response = const RemoteDatasetResponse.notModified(etag: 'tag');
    final result = await repository.synchronize(manual: true);
    expect(result.outcome, SyncOutcome.notModified);
    expect(local.metadata.lastSuccessfulCheckAt, now);
    expect(local.metadata.consecutiveFailures, 0);
  });

  test('automatic sync honors retry cooldown', () async {
    local.metadata = SyncMetadataRecord(
      lastSuccessfulCheckAt: now.subtract(const Duration(days: 20)),
      nextAutomaticAttemptAt: now.add(const Duration(hours: 1)),
    );
    final result = await repository.synchronize();
    expect(result.outcome, SyncOutcome.skipped);
    expect(remote.fetchCount, 0);
  });

  test('parallel sync calls share a single remote request', () async {
    final completer = Completer<RemoteDatasetResponse>();
    remote.completer = completer;
    final first = repository.synchronize(manual: true);
    final second = repository.synchronize(manual: true);
    completer.complete(const RemoteDatasetResponse.notModified());
    await Future.wait([first, second]);
    expect(remote.fetchCount, 1);
  });

  test('malformed dataset is not activated and schedules retry', () async {
    final bytes = Uint8List.fromList(utf8.encode('{}'));
    remote.response = RemoteDatasetResponse.updated(
      bytes: bytes,
      datasetVersion: 'broken',
      imagesBaseUrl: 'https://example.com/',
      expectedHash: sha256.convert(bytes).toString(),
      expectedCount: 1,
    );
    await expectLater(
      repository.synchronize(manual: true),
      throwsA(isA<DatasetValidationException>()),
    );
    expect(local.activated, isEmpty);
    expect(local.metadata.consecutiveFailures, 1);
    expect(
      local.metadata.nextAutomaticAttemptAt,
      now.add(const Duration(hours: 1)),
    );
  });

  test('image failure activates valid text as partial dataset', () async {
    final bytes = _datasetWithImage();
    remote
      ..response = RemoteDatasetResponse.updated(
        bytes: bytes,
        datasetVersion: 'test',
        imagesBaseUrl: 'https://example.com/',
        expectedHash: sha256.convert(bytes).toString(),
        expectedCount: 1,
      )
      ..imageError = Exception('offline');
    final result = await repository.synchronize(manual: true);
    expect(result.outcome, SyncOutcome.partiallyUpdated);
    expect(result.missingImages, 1);
    expect(local.activated.single.questions.single.isAvailable, isFalse);
  });
}

Uint8List _datasetWithImage() => Uint8List.fromList(
  utf8.encode(
    jsonEncode({
      'schemaVersion': 1,
      'datasetVersion': 'test',
      'questions': [
        {
          'id': 'q',
          'officialNumber': 1,
          'scope': 'general',
          'stateCode': null,
          'question': 'Welches Bild zeigt das Wappen?',
          'answers': {'a': 'A', 'b': 'B', 'c': 'C', 'd': 'D'},
          'solution': 'a',
          'images': [
            {
              'path': 'images/a.png',
              'sha256':
                  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
                  'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
              'mime_type': 'image/png',
            },
          ],
        },
      ],
    }),
  ),
);

class _Local implements CitizenshipTestLocalClient {
  SyncMetadataRecord metadata = const SyncMetadataRecord();
  final activated = <DatasetCandidate>[];
  final pending = <MediaRecord>[];

  @override
  Future<void> activateDataset(DatasetCandidate candidate) async {
    activated.add(candidate);
    pending
      ..clear()
      ..addAll(candidate.media.where((m) => m.status != MediaStatus.available));
  }

  @override
  Future<SyncMetadataRecord> loadSyncMetadata() async => metadata;
  @override
  Future<void> saveSyncMetadata(SyncMetadataRecord value) async =>
      metadata = value;
  @override
  Future<List<MediaRecord>> loadPendingMedia() async => pending;
  @override
  Future<MediaRecord?> findReusableMedia(String sourceUrl) async => null;
  @override
  Future<void> updateMedia(MediaRecord media) async {}
  @override
  Future<void> cleanupObsoleteDatasets() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Remote implements CitizenshipTestRemoteClient {
  RemoteDatasetResponse response = const RemoteDatasetResponse.notModified();
  Completer<RemoteDatasetResponse>? completer;
  Exception? imageError;
  int fetchCount = 0;

  @override
  Future<RemoteDatasetResponse> fetchDataset({
    String? etag,
    String? lastModified,
  }) async {
    fetchCount++;
    return completer?.future ?? response;
  }

  @override
  Future<MediaDownload> downloadImage(String url) async {
    if (imageError case final error?) throw error;
    return MediaDownload(
      bytes: Uint8List.fromList([1]),
      mimeType: 'image/png',
      contentHash: 'hash',
    );
  }
}

class _Media implements CitizenshipTestMediaStore {
  @override
  Future<String> write({
    required String datasetId,
    required String mediaKey,
    required Uint8List bytes,
    required String extension,
  }) async => '$datasetId/$mediaKey';
  @override
  Future<void> copy({required String from, required String to}) async {}
  @override
  Future<void> deleteDataset(String datasetId) async {}
  @override
  Future<Uint8List?> read(String relativePath) async => null;
}
