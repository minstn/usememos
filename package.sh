#!/usr/bin/env bash
# Package the usememos skill for publishing to https://clawhub.ai
# Creates dist/ with all publishable files.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

VERSION=$(cat VERSION)
DIST_DIR="dist"
SKILL_NAME="usememos-${VERSION}"
TARGET="${DIST_DIR}/${SKILL_NAME}"

echo "Packaging usememos v${VERSION}..."

rm -rf "$DIST_DIR"
mkdir -p "$TARGET"

# Copy publishable files
cp -r scripts/ "$TARGET/scripts/"
cp -r tests/ "$TARGET/tests/"
cp -r references/ "$TARGET/references/"
cp SKILL.md "$TARGET/"
cp README.md "$TARGET/"
cp CHANGELOG.md "$TARGET/"
cp LICENSE "$TARGET/"
cp VERSION "$TARGET/"
cp .env.example "$TARGET/"
cp .gitignore "$TARGET/"
cp screenshot.png "$TARGET/"

# Clean unwanted files from dist
find "$TARGET" -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
find "$TARGET" -name '*.pyc' -delete 2>/dev/null || true
find "$TARGET" -name '.DS_Store' -delete 2>/dev/null || true

# Create archive
(cd "$DIST_DIR" && tar czf "${SKILL_NAME}.tar.gz" "${SKILL_NAME}")

echo "Done: ${DIST_DIR}/${SKILL_NAME}.tar.gz"
echo "Contents:"
tar tzf "${DIST_DIR}/${SKILL_NAME}.tar.gz" | head -20
COUNT=$(tar tzf "${DIST_DIR}/${SKILL_NAME}.tar.gz" | wc -l)
echo "... ${COUNT} files total"
