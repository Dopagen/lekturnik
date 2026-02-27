#!/bin/bash
set -euo pipefail

# Only run on remote (Claude Code on the web)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_HOME="${HOME:-/root}"
FLUTTER_DIR="$FLUTTER_HOME/flutter"
FLUTTER_BIN="$FLUTTER_DIR/bin"

# Install Flutter SDK if not present
if [ ! -f "$FLUTTER_BIN/flutter" ]; then
  echo "Installing Flutter SDK..."
  cd "$FLUTTER_HOME"
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

# Add Flutter to PATH for this session
echo "export PATH=\"$FLUTTER_BIN:\$PATH\"" >> "$CLAUDE_ENV_FILE"
export PATH="$FLUTTER_BIN:$PATH"

# Disable Flutter analytics/telemetry in CI-like environments
flutter config --no-analytics 2>/dev/null || true
dart --disable-analytics 2>/dev/null || true

# Pre-cache web platform artifacts (most likely build target)
flutter precache --web 2>/dev/null || true

# Install Supabase CLI via deb package if not present
if ! command -v supabase &>/dev/null; then
  echo "Installing Supabase CLI..."
  curl -fsSL "https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz" -o /tmp/supabase.tar.gz
  tar xz -C /usr/local/bin supabase -f /tmp/supabase.tar.gz
  rm -f /tmp/supabase.tar.gz
fi

# Install project dependencies if pubspec.yaml exists
if [ -f "$CLAUDE_PROJECT_DIR/pubspec.yaml" ]; then
  echo "Installing Flutter dependencies..."
  cd "$CLAUDE_PROJECT_DIR"
  flutter pub get
fi

echo "Session setup complete."
