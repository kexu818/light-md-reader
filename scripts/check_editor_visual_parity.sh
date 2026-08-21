#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RENDERER="$ROOT_DIR/Sources/LightMDReader/MarkdownRenderer.swift"

REQUIRED_RULES=(
  '--document-width: 720px'
  '#lightmd-editor .mu-container'
  '#lightmd-editor .mu-paragraph'
  '#lightmd-editor .mu-container ul'
  '#lightmd-editor blockquote::before'
  '#lightmd-editor .mu-code-block'
  '#lightmd-editor .mu-table-inner'
  '#lightmd-editor .mu-thematic-break'
)

for rule in "${REQUIRED_RULES[@]}"; do
  if ! grep -Fq -- "$rule" "$RENDERER"; then
    echo "FAIL: editor visual parity rule is missing: $rule"
    exit 1
  fi
done

echo "PASS: editing mode styles the Muya document structure like reading mode."
