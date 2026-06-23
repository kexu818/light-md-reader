#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DELEGATE="$ROOT_DIR/Sources/LightMDReader/AppDelegate.swift"

if ! grep -q 'NSMenu(title: "编辑")' "$APP_DELEGATE"; then
  echo "FAIL: Main menu is missing the standard Edit menu."
  exit 1
fi

REQUIRED_ACTIONS=(
  "copy: c"
  "paste: v"
  "cut: x"
  "selectAll: a"
)

for item in "${REQUIRED_ACTIONS[@]}"; do
  action="${item%% *}"
  key="${item##* }"
  method="${action%:}"
  if ! grep -q "action: #selector(NSText\\.${method}.*keyEquivalent: \"${key}\"" "$APP_DELEGATE"; then
    echo "FAIL: Edit menu is missing ${action} with Command-${key}."
    exit 1
  fi
done

echo "PASS: Standard Edit menu shortcuts are wired into the macOS responder chain."
