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

  test('304 reports images that are still missing after retry', () async {
    local.pending.add(
      const MediaRecord(
        datasetId: 'active',
        mediaKey: 'oversized.png',
        sourceUrl: 'https://example.com/oversized.png',
        relativePath: 'active/oversized.png',
        status: MediaStatus.failed,
        mimeType: 'image/png',
        contentHash: 'hash',
      ),
    );
    remote
      ..response = const RemoteDatasetResponse.notModified(etag: 'tag')
      ..imageError = Exception('Invalid image size.');

    final result = await repository.synchronize(manual: true);

    expect(result.outcome, SyncOutcome.partiallyUpdated);
    expect(result.missingImages, 1);
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

  test('bundled image failure does not prevent catalog bootstrap', () async {
    final imageBytes = Uint8List.fromList([1, 2, 3]);
    final imageHash = sha256.convert(imageBytes).toString();
    final bytes = Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'schemaVersion': 1,
          'questions': [
            {
              'id': 'q',
              'officialNumber': 1,
              'scope': 'general',
              'stateCode': null,
              'question': 'Welches Bild ist richtig?',
              'answers': {'a': 'A', 'b': 'B', 'c': 'C', 'd': 'D'},
              'solution': 'a',
              'images': [
                {
                  'path': 'images/a.png',
                  'sha256': imageHash,
                  'mime_type': 'image/png',
                },
              ],
            },
          ],
        }),
      ),
    );
    final failingMedia = _Media()..writeError = Exception('cache unavailable');
    repository = CitizenshipTestRepository(
      localClient: local,
      remoteClient: remote,
      mediaStore: failingMedia,
      parser: const CitizenshipQuestionParser(
        minimumQuestions: 1,
        maximumQuestions: 10,
      ),
      now: () => now,
    );

    await repository.bootstrap(
      jsonBytes: bytes,
      datasetVersion: 'test',
      expectedHash: sha256.convert(bytes).toString(),
      imageAssets: {
        'https://yehoraltshuler.github.io/bamf-lid-dataset/images/a.png':
            'assets/a.png',
      },
      loadAsset: (_) async => imageBytes,
    );

    expect(local.activated.single.questions, hasLength(1));
    expect(local.activated.single.questions.single.isAvailable, isFalse);
    expect(local.pending, hasLength(1));
    expect(local.metadata.questionCount, 1);
    expect(local.metadata.lastSuccessfulUpdateAt, now);
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
  Future<bool> get isEmpty async => activated.isEmpty;

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
  Future<void> updateMedia(MediaRecord media) async {
    pending.removeWhere(
      (item) =>
          item.datasetId == media.datasetId && item.mediaKey == media.mediaKey,
    );
    if (media.status != MediaStatus.available) pending.add(media);
  }

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
  Exception? writeError;

  @override
  Future<String> write({
    required String datasetId,
    required String mediaKey,
    required Uint8List bytes,
    required String extension,
  }) async {
    if (writeError case final error?) throw error;
    return '$datasetId/$mediaKey';
  }

  @override
  Future<void> copy({required String from, required String to}) async {}
  @override
  Future<void> deleteDataset(String datasetId) async {}
  @override
  Future<Uint8List?> read(String relativePath) async => null;
}
