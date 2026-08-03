#!/usr/bin/env bash
set -euo pipefail

if command -v flutter >/dev/null 2>&1; then
  FLUTTER_BIN="$(command -v flutter)"
else
  FLUTTER_DIR="${TMPDIR:-/tmp}/flutter"
  if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  FLUTTER_BIN="$FLUTTER_DIR/bin/flutter"
fi

"$FLUTTER_BIN" config --enable-web
"$FLUTTER_BIN" pub get
"$FLUTTER_BIN" build web \
  --release \
  --dart-define="APK_DOWNLOAD_URL=${APK_DOWNLOAD_URL:-https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk}"
