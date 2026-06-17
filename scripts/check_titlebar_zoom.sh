#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WINDOW_CONTROLLER="$ROOT_DIR/Sources/LightMDReader/ReaderWindowController.swift"

if ! grep -q 'NSWindowDelegate' "$WINDOW_CONTROLLER"; then
  echo "FAIL: ReaderWindowController does not conform to NSWindowDelegate."
  exit 1
fi

if ! grep -q 'window.delegate = self' "$WINDOW_CONTROLLER"; then
  echo "FAIL: window delegate is not assigned."
  exit 1
fi

if ! grep -q 'window?.zoom(nil)' "$WINDOW_CONTROLLER"; then
  echo "FAIL: titlebar double-click does not trigger window zoom."
  exit 1
fi

if ! grep -q 'windowWillUseStandardFrame' "$WINDOW_CONTROLLER" || ! grep -q 'visibleFrame' "$WINDOW_CONTROLLER"; then
  echo "FAIL: standard zoom frame does not use the current screen visible frame."
  exit 1
fi

echo "PASS: titlebar double-click zoom fills the current screen."
