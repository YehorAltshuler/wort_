import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class CitizenshipTestHttpException implements Exception {
  const CitizenshipTestHttpException(this.message);
  final String message;
  @override
  String toString() => message;
}

class HttpCitizenshipTestClient implements CitizenshipTestRemoteClient {
  HttpCitizenshipTestClient({
    http.Client? client,
    Uri? manifestUri,
    this.timeout = const Duration(seconds: 20),
    this.maximumImageBytes = 2 * 1024 * 1024,
  }) : _client = client ?? http.Client(),
       manifestUri =
           manifestUri ??
           Uri.parse(
             'https://yehoraltshuler.github.io/'
             'bamf-lid-dataset/manifest.json',
           );

  final http.Client _client;
  final Uri manifestUri;
  final Duration timeout;
  final int maximumImageBytes;

  @override
  Future<RemoteDatasetResponse> fetchDataset({
    String? etag,
    String? lastModified,
  }) async {
    final headers = <String, String>{};
    if (etag != null) headers['If-None-Match'] = etag;
    if (lastModified != null) headers['If-Modified-Since'] = lastModified;
    final response = await _client
        .get(manifestUri, headers: headers)
        .timeout(timeout);
    if (response.statusCode == 304) {
      return RemoteDatasetResponse.notModified(
        etag: response.headers['etag'] ?? etag,
        lastModified: response.headers['last-modified'] ?? lastModified,
      );
    }
    if (response.statusCode != 200) {
      throw CitizenshipTestHttpException(
        'Manifest request failed with HTTP ${response.statusCode}.',
      );
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on Object {
      throw const CitizenshipTestHttpException('Manifest is invalid JSON.');
    }
    if (decoded is! Map<String, Object?> || decoded['schemaVersion'] != 1) {
      throw const CitizenshipTestHttpException('Manifest schema is invalid.');
    }
    final questions = decoded['questions'];
    final version = decoded['datasetVersion'];
    if (questions is! Map<String, Object?> || version is! String) {
      throw const CitizenshipTestHttpException('Manifest is incomplete.');
    }
    final relativeUrl = questions['url'];
    final expectedHash = questions['sha256'];
    final expectedCount = questions['count'];
    if (relativeUrl is! String ||
        expectedHash is! String ||
        expectedCount is! int) {
      throw const CitizenshipTestHttpException(
        'Questions manifest is invalid.',
      );
    }
    final questionsResponse = await _client
        .get(manifestUri.resolve(relativeUrl))
        .timeout(timeout);
    if (questionsResponse.statusCode != 200) {
      throw CitizenshipTestHttpException(
        'Questions request failed with HTTP ${questionsResponse.statusCode}.',
      );
    }
    final actualHash = sha256.convert(questionsResponse.bodyBytes).toString();
    if (actualHash != expectedHash) {
      throw const CitizenshipTestHttpException('Questions checksum mismatch.');
    }
    return RemoteDatasetResponse.updated(
      bytes: questionsResponse.bodyBytes,
      datasetVersion: version,
      imagesBaseUrl: manifestUri.resolve('.').toString(),
      expectedHash: expectedHash,
      expectedCount: expectedCount,
      etag: response.headers['etag'],
      lastModified: response.headers['last-modified'],
    );
  }

  @override
  Future<MediaDownload> downloadImage(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https') {
      throw const CitizenshipTestHttpException('Unsafe image URL.');
    }
    final response = await _client.get(uri).timeout(timeout);
    if (response.statusCode != 200) {
      throw CitizenshipTestHttpException(
        'Image request failed with HTTP ${response.statusCode}.',
      );
    }
    final bytes = Uint8List.fromList(response.bodyBytes);
    if (bytes.isEmpty || bytes.length > maximumImageBytes) {
      throw const CitizenshipTestHttpException('Invalid image size.');
    }
    final mime = response.headers['content-type']?.split(';').first.trim();
    if (mime != 'image/jpeg' && mime != 'image/png') {
      throw CitizenshipTestHttpException('Unsupported image MIME type: $mime.');
    }
    return MediaDownload(
      bytes: bytes,
      mimeType: mime!,
      contentHash: sha256.convert(bytes).toString(),
    );
  }
}
