import 'package:web/web.dart' as web;

const supportsApkDownload = true;

const _apkDownloadUrl = String.fromEnvironment(
  'APK_DOWNLOAD_URL',
  defaultValue:
      'https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk',
);

void downloadApk() {
  web.window.open(_apkDownloadUrl, '_blank');
}
