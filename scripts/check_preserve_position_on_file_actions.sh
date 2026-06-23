#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WINDOW_CONTROLLER="$ROOT_DIR/Sources/LightMDReader/ReaderWindowController.swift"

if awk '/private func saveDocument/,/^    }/' "$WINDOW_CONTROLLER" | grep -q 'loadHTMLString'; then
  echo "FAIL: saving reloads the main WebView and loses position."
  exit 1
fi

if ! grep -q 'restoreContentFocus' "$WINDOW_CONTROLLER"; then
  echo "FAIL: file actions do not restore focus to the content area."
  exit 1
fi

if ! awk '/private func showExportSuccess/,/^    }/' "$WINDOW_CONTROLLER" | grep -q 'restoreContentFocus'; then
  echo "FAIL: export success does not restore content focus."
  exit 1
fi

echo "PASS: save/export actions preserve the current content position."
