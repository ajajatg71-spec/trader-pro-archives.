#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXPECTED_SHA256="fe40bf6be7c81faca3d0eecf5fecf0de6cdc2eae0c6d7651074182c38992c77f"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cat "$ROOT"/ci/overlay-r113/part-*.b64 > "$TMP/overlay.b64"
base64 --decode "$TMP/overlay.b64" > "$TMP/overlay.tar.xz"
echo "$EXPECTED_SHA256  $TMP/overlay.tar.xz" | sha256sum --check --status
xz --test "$TMP/overlay.tar.xz"
tar -tJf "$TMP/overlay.tar.xz" >/dev/null
printf 'OK: R113 overlay is complete, decodes cleanly, and matches SHA-256 %s\n' "$EXPECTED_SHA256"
