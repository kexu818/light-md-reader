#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DELEGATE="$ROOT_DIR/Sources/LightMDReader/AppDelegate.swift"
WINDOW_CONTROLLER="$ROOT_DIR/Sources/LightMDReader/ReaderWindowController.swift"

if ! grep -q '另存为...' "$APP_DELEGATE"; then
  echo "FAIL: File menu is missing Save As."
  exit 1
fi

if ! grep -q 'saveCurrentDocumentAs' "$WINDOW_CONTROLLER"; then
  echo "FAIL: ReaderWindowController is missing a Save As action."
  exit 1
fi

if ! grep -q 'title: "另存为 Markdown"' "$WINDOW_CONTROLLER"; then
  echo "FAIL: Save As does not use a dedicated save panel title."
  exit 1
fi

echo "PASS: Save As is available as an independent file action."
