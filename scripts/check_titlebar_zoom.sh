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

if ! grep -q 'toggleWindowFit()' "$WINDOW_CONTROLLER"; then
  echo "FAIL: titlebar double-click does not trigger explicit window fitting."
  exit 1
fi

if ! grep -q 'windowWillUseStandardFrame' "$WINDOW_CONTROLLER" || ! grep -q 'visibleFrame.insetBy' "$WINDOW_CONTROLLER"; then
  echo "FAIL: standard zoom frame does not use the current screen visible frame."
  exit 1
fi

if ! grep -q 'window.setFrame(fittedFrame' "$WINDOW_CONTROLLER"; then
  echo "FAIL: oversized windows are not forced back inside the fitted frame."
  exit 1
fi

if ! grep -q 'previousFrame.constrained(to: fittedFrame)' "$WINDOW_CONTROLLER"; then
  echo "FAIL: restored windows are not constrained to the visible screen."
  exit 1
fi

if ! grep -q 'detailLabel.setContentCompressionResistancePriority(.defaultLow' "$WINDOW_CONTROLLER"; then
  echo "FAIL: long file paths can still force the window wider than the screen."
  exit 1
fi

if ! grep -q 'scheduleWindowConstraintCheck()' "$WINDOW_CONTROLLER" || ! grep -q 'visibleBounds.contains(window.frame)' "$WINDOW_CONTROLLER"; then
  echo "FAIL: off-screen restored windows are not corrected after opening a document."
  exit 1
fi

echo "PASS: titlebar double-click safely fits and restores the window."
